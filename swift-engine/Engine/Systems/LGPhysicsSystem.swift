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
	typealias Rect = (x: Double, y: Double, width: Double, height: Double)
	
	// Configuration variables
	public var gravity: LGVector
	public var terminalVelocity: Double
	
	// Entities by type
	private final var dynamicEntities	= [Int]()
	private final var staticEntities	= [Int]()
	
	// Helper dictionaries for removing entities
	private final var dynamicIndices	= [Int:Int]()
	private final var staticIndices		= [Int:Int]()
	
	// Cached components
	private final var position	= [LGPosition]()
	private final var body		= [LGPhysicsBody]()
	private final var tent		= [LGVector]()
	
	public var collisionLayer: LGTileLayer!
	
	public init(gravity: LGVector, terminalVelocity: Double = 30.0)
	{
		self.gravity = gravity
		self.terminalVelocity = terminalVelocity
		
		super.init()
		self.updatePhase = .Physics
	}
	
	// MARK: LGSystem Overrides
	
	override public init()
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
		
		if bod.dynamic
		{
			dynamicIndices[localId] = dynamicEntities.count
			dynamicEntities.append(localId)
		}
		else
		{
			staticIndices[localId] = staticEntities.count
			staticEntities.append(localId)
		}
		
		// Cache entity information
		
		position.append(pos)
		body.append(bod)
		tent.append(LGVector())
	}
	
	override public func remove(index: Int)
	{
		super.remove(index)
		
		if body[index].dynamic
		{
			dynamicEntities.removeAtIndex(dynamicIndices[index]!)
			dynamicIndices[index] = nil
		}
		else
		{
			staticEntities.removeAtIndex(staticIndices[index]!)
			staticIndices[index] = nil
		}
		
		body.removeAtIndex(index)
		position.removeAtIndex(index)
		tent.removeAtIndex(index)
	}
	
	override public func update()
	{
		for id in 0 ..< entities.count
		{
			applyPhysics(id)
			body[id].resetCollided()
		}
		
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
		}
	}
	
	// MARK: Update Methods
	
	func applyPhysics(id: Int)
	{
		// Apply gravity to dynamic entities
		
		if body[id].dynamic
		{
			body[id].velocity += gravity
			limit(&body[id].velocity, maximum: terminalVelocity)
		}
		
		// Update position and/or velocity of the entity to follow another entity
		
		var vel = LGVector(x: body[id].velocity.x, y: body[id].velocity.y)
		
		if let follower = entities[id].get(LGFollower)
		{
			// TODO: Don't remove just any follower ... this makes followers only useful for platforms when they could be good for combining boss entities
			// Maybe only do this to dynamic followers?
			
			if !body[id].collidedBottom
			{
				entities[id].remove(LGFollower)
			}
			else if let following = follower.following
			{
				if let followingBody = following.get(LGPhysicsBody)
				{
					switch follower.axis
					{
						case .X:
							vel.x += followingBody.velocity.x
						
						case .Y:
							vel.y += followingBody.velocity.y
						
						case .Both:
							vel.x += followingBody.velocity.x
							vel.y += followingBody.velocity.y
						
						case .None:
							break
					}
				}
				limit(&vel, maximum: terminalVelocity)
			}
		}
		
		// Set the entity's tentative position
		
		tent[id].x = position[id].x + vel.x
		tent[id].y = position[id].y + vel.y
	}
	
	func resolveDynamicCollisions(id: Int)
	{
		for other in dynamicEntities
		{
			if id != other && !body[id].onlyCollidesOnTop && !body[other].onlyCollidesOnTop && overlap(id, other, axis: .X)
			{
				resolveDynamicCollision(id, other, axis: .X)
			}
		}
		
		for other in dynamicEntities
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
		
		// Block chained collisions
		
		for id in dynamicEntities
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
		
		for other in staticEntities
		{
			if overlap(id, other, axis: .X)
			{
				resolveStaticCollision(id, other, axis: .X)
			}
		}
		
		for other in staticEntities
		{
			if overlap(id, other, axis: .Y)
			{
				resolveStaticCollision(id, other, axis: .Y)
			}
		}
	}
	
	func resolveTileCollisions(id: Int)
	{
		if collisionLayer
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
					if collisionLayer.collidesAt(row: row, col: col)
					{
						resolveStaticCollision(id, tileRect(row, col), axis: .X)
						break outerLoop
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
					if collisionLayer.collidesAt(row: row, col: col)
					{
						resolveStaticCollision(id, tileRect(row, col), axis: .Y)
						break outerLoop
					}
				}
			}
		}
	}
	
	func resolveStaticCollision(id: Int, _ rect: Rect, axis: LGAxis)
	{
		resolveStaticCollision(id, -1, axis: axis, rect: rect)
	}
	
	func resolveStaticCollision(var id: Int, var _ other: Int, axis: LGAxis, var rect: Rect! = nil)
	{
		var collisions: [(id: Int, other: Int)] = [ (id: id, other: other) ]
		while collisions.count > 0
		{
			id = collisions[0].id
			other = collisions[0].other
			collisions.removeAtIndex(0)
			
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
			
			// Chain collisions
			
			for another in dynamicEntities
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
	
	func tentRect(id: Int) -> Rect
	{
		return (x: tent[id].x, y: tent[id].y, width: body[id].width, height: body[id].height)
	}
	
	func tileRect(row: Int, _ col: Int) -> Rect
	{
		return (x: Double(col * collisionLayer.tileWidth), y: Double(row * collisionLayer.tileHeight), width: Double(collisionLayer.tileWidth), height: Double(collisionLayer.tileHeight))
	}
	
	func tileAtX(x: Double) -> Int
	{
		return Int(floor(x / Double(collisionLayer.tileWidth)))
	}
	
	func tileAtY(y: Double) -> Int
	{
		return Int(floor(y / Double(collisionLayer.tileHeight)))
	}
}
