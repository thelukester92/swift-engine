//
//  LGPhysicsSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 7/8/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import Foundation

public final class LGPhysicsSystem: LGSystem
{
	public enum Event: String
	{
		case Collision		= "collision"
		case CollisionStart	= "collisionStart"
		case CollisionEnd	= "collisionEnd"
	}
	
	// Configuration variables
	public var gravity: LGVector
	public var terminalVelocity: Double
	public var collisionLayer: LGTileLayer!
	
	// Entities by type
	var dynamicEntities	= [Int]()
	var staticEntities	= [Int]()
	
	// Cached
	var position		= [LGPosition]()
	var body			= [LGPhysicsBody]()
	var scriptable		= [LGScriptable?]()
	var tent			= [LGVector]()
	var collidedWith	= [[Int:LGEntity]]()
	
	// Events to call
	var collisionEvents: [(a: Int, b: Int)] = []
	var collisionStartEvents: [(a: Int, b: Int)] = []
	var collisionEndEvents: [(a: Int, b: LGEntity)] = []
	
	// Partitions
	var dynamicGrid: LGSpatialGrid!
	var staticGrid: LGSpatialGrid!
	
	public init(gravity: LGVector, terminalVelocity: Double = 30.0)
	{
		self.gravity = gravity
		self.terminalVelocity = terminalVelocity
		
		super.init()
		self.updatePhase = .Physics
		
		dynamicGrid	= LGSpatialGrid(system: self)
		staticGrid	= LGSpatialGrid(system: self)
	}
	
	// MARK: LGSystem Overrides
	
	override public convenience init()
	{
		self.init(gravity: LGVector(x: 0, y: -0.1))
	}
	
	override public func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGPosition) && entity.has(LGPhysicsBody)
	}
	
	override public func add(entity: LGEntity)
	{
		super.add(entity)
		
		let pos	= entity.get(LGPosition)!
		let bod	= entity.get(LGPhysicsBody)!
		
		// Assign local entity ID based on entities.count
		let localId = entities.count - 1
		
		// TODO: Allow physics bodies to switch between static and dynamic on the fly via reindex
		if bod.dynamic
		{
			dynamicEntities.append(localId)
		}
		else
		{
			staticEntities.append(localId)
		}
		
		// Cache entity information
		
		position.append(pos)
		body.append(bod)
		scriptable.append(entity.get(LGScriptable))
		tent.append(LGVector())
		collidedWith.append([Int:LGEntity]())
	}
	
	override public func remove(index: Int)
	{
		super.remove(index)
		
		body.removeAtIndex(index)
		scriptable.removeAtIndex(index)
		position.removeAtIndex(index)
		tent.removeAtIndex(index)
		collidedWith.removeAtIndex(index)
		
		reindex()
	}
	
	// Update values that may have been added/removed in change
	override public func change(index: Int)
	{
		scriptable[index] = entities[index].get(LGScriptable)
	}
	
	override public func update()
	{
		collisionEvents.removeAll(keepCapacity: false)
		collisionStartEvents.removeAll(keepCapacity: false)
		collisionEndEvents.removeAll(keepCapacity: false)
		
		for id in 0 ..< entities.count
		{
			applyPhysics(id)
			
			// Save previous collision list
			collidedWith[id] = body[id].collidedWith
			
			// Reset previous collision list
			body[id].collidedTop	= false
			body[id].collidedBottom	= false
			body[id].collidedLeft	= false
			body[id].collidedRight	= false
			body[id].collidedWith.removeAll()
		}
		
		dynamicGrid.populate(dynamicEntities)
		staticGrid.populate(staticEntities)
		
		for id in dynamicEntities
		{
			resolveDynamicCollisions(id)
		}
		
		for id in dynamicEntities
		{
			resolveStaticCollisions(id)
		}
		
		for id in 0 ..< entities.count
		{
			position[id].x = tent[id].x
			position[id].y = tent[id].y
			
			updateFollowers(id)
			
			for a in collidedWith[id].values
			{
				var contained = false
				for b in body[id].collidedWith.values
				{
					if a === b
					{
						contained = true
						break
					}
				}
				
				// If old collisions (collidedWith[id]) have collisions that aren't in new collisions (body[id].collidedWith)...
				if !contained
				{
					addCollisionEnd(id, a)
				}
			}
		}
		
		triggerEvents()
	}
	
	func reindex()
	{
		dynamicEntities = [Int]()
		staticEntities = [Int]()
		
		for i in 0 ..< entities.count
		{
			if body[i].dynamic
			{
				dynamicEntities.append(i)
			}
			else
			{
				staticEntities.append(i)
			}
		}
	}
	
	// MARK: Update Methods
	
	func applyPhysics(id: Int)
	{
		// Apply gravity to dynamic entities
		
		if body[id].dynamic
		{
			body[id].velocity += gravity
		}
		
		// Update the entity's velocity as a follower
		
		if let follower = entities[id].get(LGFollower)
		{
			switch follower.followerType
			{
				case .Velocity(let lastVelocity):
					if follower.axis == LGAxis.X || follower.axis == LGAxis.Both
					{
						body[id].velocity.x += lastVelocity.x
					}
					
					if follower.axis == LGAxis.Y || follower.axis == LGAxis.Both
					{
						body[id].velocity.y += lastVelocity.y
					}
				
				case .Position:
					break
			}
		}
		
		// Impose terminal velocity
		
		limit(&body[id].velocity, maximum: terminalVelocity)
		
		// Set the entity's tentative position
		
		tent[id].x = position[id].x + body[id].velocity.x
		tent[id].y = position[id].y + body[id].velocity.y
	}
	
	func resolveDynamicCollisions(id: Int)
	{
		// NOTE: Entities that only collide on top are ignored here, because they can only cause collisions during static chaining
		
		for other in dynamicGrid.entitiesNearRect(tentRect(id))
		{
			if id != other && !body[id].onlyCollidesOnTop && !body[other].onlyCollidesOnTop && overlap(id, other, axis: .X)
			{
				resolveDynamicCollision(id, other, axis: .X)
			}
		}
		
		for other in dynamicGrid.entitiesNearRect(tentRect(id))
		{
			if id != other && !body[id].onlyCollidesOnTop && !body[other].onlyCollidesOnTop && overlap(id, other, axis: .Y)
			{
				resolveDynamicCollision(id, other, axis: .Y)
			}
		}
	}
	
	func resolveDynamicCollision(a: Int, _ b: Int, axis: LGAxis)
	{
		switch axis
		{
			case .X:
				// Calculate resolution and update velocity
				
				var resolution = 0.0
				if tent[a].x > tent[b].x
				{
					resolution = tent[b].x + body[b].width - tent[a].x + 1
					
					body[a].velocity.x = max(0, body[a].velocity.x)
					body[b].velocity.x = min(0, body[b].velocity.x)
					
					body[a].collidedLeft	= true
					body[b].collidedRight	= true
				}
				else
				{
					resolution = tent[b].x - (tent[a].x + body[a].width) - 1
					
					body[a].velocity.x = min(0, body[a].velocity.x)
					body[b].velocity.x = max(0, body[b].velocity.x)
					
					body[a].collidedRight	= true
					body[b].collidedLeft	= true
				}
				
				// Update position (tentative)
				
				tent[a].x += resolution / 2
				tent[b].x -= resolution / 2
			
			case .Y:
				// Calculate resolution and update velocity
				
				var resolution = 0.0
				if tent[a].y > tent[b].y
				{
					resolution = tent[b].y + body[b].height - tent[a].y + 1
					
					body[a].velocity.y = max(0, body[a].velocity.y)
					body[b].velocity.y = min(0, body[b].velocity.y)
					
					body[a].collidedBottom	= true
					body[b].collidedTop		= true
				}
				else
				{
					resolution = tent[b].y - (tent[a].y + body[a].height) - 1
					
					body[a].velocity.y = min(0, body[a].velocity.y)
					body[b].velocity.y = max(0, body[b].velocity.y)
					
					body[a].collidedTop		= true
					body[b].collidedBottom	= true
				}
				
				// Update position (tentative)
				
				tent[a].y += resolution / 2
				tent[b].y -= resolution / 2
			
			default:
				break
		}
		
		addCollision(a, b)
		
		// Block chained collisions
		
		let rectA = tentRect(a)
		let rectB = tentRect(b)
		
		var rect		= LGRect(x: min(rectA.x, rectB.x), y: min(rectA.y, rectB.y), width: 0, height: 0)
		rect.width		= max(rectA.x + rectA.width, rectB.x + rectB.width) - rect.x
		rect.height		= max(rectA.y + rectA.height, rectB.y + rectB.height) - rect.y
		
		for id in dynamicGrid.entitiesNearRect(rect)
		{
			if id != a && id != b
			{
				if overlap(id, a, axis: axis)
				{
					resolveStaticCollision(a, tentRect(id), axis: axis)
					break
				}
				else if overlap(id, b, axis: axis)
				{
					resolveStaticCollision(b, tentRect(id), axis: axis)
					break
				}
			}
		}
	}
	
	func resolveStaticCollisions(id: Int)
	{
		resolveTileCollisions(id)
		
		for other in staticGrid.entitiesNearRect(tentRect(id))
		{
			if overlap(id, other, axis: .X)
			{
				resolveStaticCollision(id, other, axis: .X)
			}
		}
		
		for other in staticGrid.entitiesNearRect(tentRect(id))
		{
			if overlap(id, other, axis: .Y)
			{
				resolveStaticCollision(id, other, axis: .Y)
			}
		}
	}
	
	func resolveTileCollisions(id: Int)
	{
		if collisionLayer != nil
		{
			// x-axis
			
			var rows = [ tileAtY(position[id].y), tileAtY(position[id].y + body[id].height) ]
			var cols = [ tileAtX(tent[id].x - 1), tileAtX(tent[id].x + body[id].width + 1) ]
			
			// Loop through cols by endpoint; sweep rows
			
			outerLoop:
			for col in cols
			{
				for row in rows[0]...rows[1]
				{
					switch collisionLayer.collisionTypeAt(row: row, col: col)
					{
						case .Collision:
							resolveStaticCollision(id, tileRect(row, col), axis: .X)
							break outerLoop
						
						default:
							break
					}
				}
			}
			
			// y-axis
			
			rows = [ tileAtY(tent[id].y - 1), tileAtY(tent[id].y + body[id].height + 1) ]
			cols = [ tileAtX(tent[id].x), tileAtX(tent[id].x + body[id].width) ]
			
			// Loop through rows by endpoint; sweep cols
			
			outerLoop:
			for row in rows
			{
				for col in cols[0]...cols[1]
				{
					switch collisionLayer.collisionTypeAt(row: row, col: col)
					{
						case .Collision:
							resolveStaticCollision(id, tileRect(row, col), axis: .Y)
							break outerLoop
						
						case .OnlyCollidesOnTop:
							let rect = tileRect(row, col)
							if rect.y > tent[id].y || position[id].y < rect.y + rect.height
							{
								break
							}
							
							resolveStaticCollision(id, rect, axis: .Y)
							break outerLoop
						
						default:
							break
					}
				}
			}
		}
	}
	
	func resolveStaticCollision(id: Int, _ rect: LGRect, axis: LGAxis)
	{
		resolveStaticCollision(id, -1, axis: axis, rect: rect)
	}
	
	func resolveStaticCollision(var id: Int, var _ other: Int, axis: LGAxis, var rect: LGRect! = nil)
	{
		var collisions: [(id: Int, other: Int)] = [ (id: id, other: other) ]
		while collisions.count > 0
		{
			id = collisions[0].id
			other = collisions[0].other
			collisions.removeAtIndex(0)
			
			if body[id].trigger || (other >= 0 && body[other].trigger)
			{
				addCollision(id, other)
				break
			}
			
			if other >= 0
			{
				// Check for directional collisions
				
				if axis == LGAxis.X
				{
					if body[id].onlyCollidesOnTop || body[other].onlyCollidesOnTop
					{
						return
					}
				}
				else if axis == LGAxis.Y
				{
					if body[id].onlyCollidesOnTop && (tent[id].y > tent[other].y || position[other].y < position[id].y + body[id].height)
					{
						return
					}
					
					if body[other].onlyCollidesOnTop && (tent[other].y > tent[id].y || position[id].y < position[other].y + body[other].height)
					{
						return
					}
					
					// Create a follower
					
					if position[id].y > position[other].y && !entities[id].has(LGFollower)
					{
						entities[id].put(LGFollower(following: entities[other], axis: .X))
					}
				}
				
				rect = tentRect(other)
			}
			
			// Resolve the collision
			
			switch axis
			{
				case .X:
					if tent[id].x > rect.x
					{
						tent[id].x = rect.x + rect.width + 1
						body[id].velocity.x = max(0, body[id].velocity.x)
						
						body[id].collidedLeft = true
					}
					else
					{
						tent[id].x = rect.x - body[id].width - 1
						body[id].velocity.x = min(0, body[id].velocity.x)
						
						body[id].collidedRight = true
					}
				
				case .Y:
					if tent[id].y > rect.y
					{
						tent[id].y = rect.y + rect.height + 1
						body[id].velocity.y = max(0, body[id].velocity.y)
						
						body[id].collidedBottom = true
					}
					else
					{
						tent[id].y = rect.y - body[id].height - 1
						body[id].velocity.y = min(0, body[id].velocity.y)
						
						body[id].collidedTop = true
					}
				
				default:
					break
			}
			
			addCollision(id, other)
			
			// Chain collisions
			
			for another in dynamicGrid.entitiesNearRect(tentRect(id))
			{
				if id != another && overlap(id, another, axis: axis)
				{
					// TODO: See if we can remove the variable declaration here in a future version of Swift
					let newTuple: (id: Int, other: Int) = (id: another, other: id)
					collisions.append(newTuple)
				}
			}
		}
	}
	
	func updateFollowers(id: Int)
	{
		// Update position or velocity of the entity to follow another entity
		
		// TODO: Determine if this is really the best place for followers
		// ... because static followers may not need physics bodies
		
		if let follower = entities[id].get(LGFollower)
		{
			// TODO: Determine if all dynamic followers really should be removed
			
			if body[id].dynamic && !body[id].collidedBottom
			{
				entities[id].remove(LGFollower)
			}
			else if let following = follower.following
			{
				switch follower.followerType
				{
					case .Velocity(var lastVelocity):
						if let followingBody = following.get(LGPhysicsBody)
						{
							switch follower.axis
							{
								case .X:
									lastVelocity.x = followingBody.velocity.x
								
								case .Y:
									lastVelocity.y = followingBody.velocity.y
								
								case .Both:
									lastVelocity.x = followingBody.velocity.x
									lastVelocity.y = followingBody.velocity.y
								
								case .None:
									break
							}
						}
					
					case .Position(let offset):
						if let followingPosition = following.get(LGPosition)
						{
							switch follower.axis
							{
								case .X:
									position[id].x = followingPosition.x + offset.x
								
								case .Y:
									position[id].y = followingPosition.y + offset.y
								
								case .Both:
									position[id].x = followingPosition.x + offset.x
									position[id].y = followingPosition.y + offset.y
								
								case .None:
									break
							}
						}
				}
			}
		}
	}
	
	func triggerEvents()
	{
		for event in collisionStartEvents
		{
			onCollisionStart(event.a, event.b)
		}
		
		for event in collisionEvents
		{
			onCollision(event.a, event.b)
		}
		
		for event in collisionEndEvents
		{
			onCollisionEnd(event.a, event.b)
		}
	}
	
	// MARK: Callback Methods
	
	func addCollision(a: Int, _ b: Int)
	{
		if b >= 0
		{
			body[a].collidedWith[entities[b].globalId] = entities[b]
			body[b].collidedWith[entities[a].globalId] = entities[a]
			
			var contained = false
			for entity in collidedWith[b].values
			{
				if entity === entities[a]
				{
					contained = true
					break
				}
			}
			
			if !contained
			{
				collidedWith[b][entities[a].globalId] = entities[a]
				addCollisionStart(a, b)
			}
		}
		
		collisionEvents.append(a: a, b: b)
	}
	
	func onCollision(a: Int, _ b: Int)
	{
		if b >= 0
		{
			scriptable[a]?.events.append(LGScriptable.Event(name: Event.Collision.toRaw(), params: [entities[a].globalId, entities[b].globalId]))
			scriptable[b]?.events.append(LGScriptable.Event(name: Event.Collision.toRaw(), params: [entities[b].globalId, entities[a].globalId]))
		}
		else
		{
			scriptable[a]?.events.append(LGScriptable.Event(name: Event.Collision.toRaw(), params: [entities[a].globalId, "nil"]))
		}
	}
	
	func addCollisionStart(a: Int, _ b: Int)
	{
		collisionStartEvents.append(a: a, b: b)
	}
	
	func onCollisionStart(a: Int, _ b: Int)
	{
		scriptable[a]?.events.append(LGScriptable.Event(name: Event.CollisionStart.toRaw(), params: [entities[a].globalId, entities[b].globalId]))
		scriptable[b]?.events.append(LGScriptable.Event(name: Event.CollisionStart.toRaw(), params: [entities[b].globalId, entities[a].globalId]))
	}
	
	func addCollisionEnd(a: Int, _ b: LGEntity)
	{
		collisionEndEvents.append(a: a, b: b)
	}
	
	func onCollisionEnd(a: Int, _ b: LGEntity)
	{
		// Only one call is necessary, because it will be called once for each collidee
		scriptable[a]?.events.append(LGScriptable.Event(name: Event.CollisionEnd.toRaw(), params: [entities[a].globalId, b.globalId]))
	}
	
	// MARK: Helper Methods
	
	func overlap(a: Int, _ b: Int, axis: LGAxis) -> Bool
	{
		switch axis
		{
			case .X:
				return !(tent[a].x >= tent[b].x + body[b].width + 1
					|| tent[a].x <= tent[b].x - body[a].width - 1
					|| position[a].y > position[b].y + body[b].height
					|| position[a].y < position[b].y - body[a].height
				)
			
			case .Y:
				return !(tent[a].x > tent[b].x + body[b].width
					|| tent[a].x < tent[b].x - body[a].width
					|| tent[a].y >= tent[b].y + body[b].height + 1
					|| tent[a].y <= tent[b].y - body[a].height - 1
				)
			
			default:
				return false
		}
	}
	
	func limit(inout vector: LGVector, maximum: Double)
	{
		if vector.x > maximum
		{
			vector.x = maximum
		}
		else if vector.x < -maximum
		{
			vector.x = -maximum
		}
		
		if vector.y > maximum
		{
			vector.y = maximum
		}
		else if vector.y < -maximum
		{
			vector.y = -maximum
		}
	}
	
	func tentRect(id: Int) -> LGRect
	{
		return LGRect(x: tent[id].x, y: tent[id].y, width: body[id].width, height: body[id].height)
	}
	
	func tileRect(row: Int, _ col: Int) -> LGRect
	{
		return LGRect(x: Double(col * collisionLayer.tileWidth), y: Double(row * collisionLayer.tileHeight), width: Double(collisionLayer.tileWidth), height: Double(collisionLayer.tileHeight))
	}
	
	func tileAtX(x: Double) -> Int
	{
		return Int(floor(x / Double(collisionLayer.tileWidth)))
	}
	
	func tileAtY(y: Double) -> Int
	{
		return Int(floor(y / Double(collisionLayer.tileHeight)))
	}
	
	class LGSpatialGrid
	{
		var system: LGPhysicsSystem
		
		final var grid: [Int: [Int]]	= [:]
		var cellSize: Double			= 100
		var rowHash						= 10000
		var padding						= 0.0
		
		init(system: LGPhysicsSystem)
		{
			self.system = system
		}
		
		func clear()
		{
			grid = [:]
		}
		
		func populate(entities: [Int])
		{
			clear()
			
			for entity in entities
			{
				insertEntity(entity)
			}
		}
		
		func insertEntity(id: Int)
		{
			let position	= system.position[id]
			let body		= system.body[id]
			let row			= cellAt(position.y)
			let col			= cellAt(position.x)
			
			for i in row...cellAt(position.y + body.height)
			{
				for j in col...cellAt(position.x + body.width)
				{
					if grid[i * rowHash + j] != nil
					{
						grid[i * rowHash + j]!.append(id)
					}
					else
					{
						grid[i * rowHash + j] = [id]
					}
				}
			}
		}
		
		func entitiesNearRect(rect: LGRect) -> [Int]
		{
			let row = cellAt(rect.y - padding)
			let col = cellAt(rect.x - padding)
			
			var nearby: [Int:Int] = [:]
			
			for i in row...cellAt(rect.y + rect.height + padding)
			{
				for j in col...cellAt(rect.x + rect.width + padding)
				{
					if let cell = grid[i * rowHash + j]
					{
						for id in cell
						{
							nearby[id] = 1
						}
					}
				}
			}
			
			return nearby.keys.array
		}
		
		func cellAt(px: Double) -> Int
		{
			return Int(px / cellSize)
		}
	}
}
