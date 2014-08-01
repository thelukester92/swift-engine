//
//  LGPhysicsSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 7/8/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

class LGPhysicsSystem: LGSystem
{
	typealias Rect = (x: Double, y: Double, width: Double, height: Double)
	
	let TERMINAL_VELOCITY	= 30.0
	let GRAVITY				= LGVector(x: 0, y: -0.1)
	
	final var dynamicEntities	= [Int]()
	final var staticEntities	= [Int]()
	
	// Helper dictionaries for removing entities
	final var dynamicIndices	= [Int:Int]()
	final var staticIndices		= [Int:Int]()
	
	final var position	= [LGPosition]()
	final var body		= [LGPhysicsBody]()
	final var tent		= [LGVector]()
	
	var collisionLayer: LGTileLayer!
	
	// MARK: LGSystem Overrides
	
	init()
	{
		super.init()
		self.updatePhase = .Physics
	}
	
	override func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGPosition) && entity.has(LGPhysicsBody)
	}
	
	override func add(entity: LGEntity)
	{
		super.add(entity)
		
		let pos	= entity.get(LGPosition)!
		let bod	= entity.get(LGPhysicsBody)!
		
		// Assign local entity ID based on entities.count
		let localId = entities.count - 1
		
		if bod.dynamic
		{
			dynamicIndices[localId] = dynamicEntities.count
			dynamicEntities += localId
		}
		else
		{
			staticIndices[localId] = staticEntities.count
			staticEntities += localId
		}
		
		// Cache entity information
		
		position	+= pos
		body		+= bod
		tent		+= LGVector()
	}
	
	override func remove(index: Int)
	{
		super.remove(index)
		
		if body[index].dynamic
		{
			dynamicEntities.removeAtIndex(dynamicIndices[localId])
			dynamicIndices[localId] = nil
		}
		else
		{
			staticEntities.removeAtIndex(staticIndices[localId])
			staticIndices[localId] = nil
		}
		
		body.removeAtIndex(index)
		position.removeAtIndex(index)
		tent.removeAtIndex(index)
	}
	
	override func update()
	{
		for id in 0 ..< entities.count
		{
			applyPhysics(id)
		}
		
		for id in dynamicEntities
		{
			resolveDynamicCollisions(id)
		}
		
		for id in dynamicEntities
		{
			resolveStaticCollisions(id)
		}
		
		for id in dynamicEntities
		{
			position[id].x = tent[id].x
			position[id].y = tent[id].y
		}
	}
	
	// MARK: Update Methods
	
	func applyPhysics(id: Int)
	{
		body[id].velocity += GRAVITY
		limit(&body[id].velocity, maximum: TERMINAL_VELOCITY)
		
		tent[id].x = position[id].x + body[id].velocity.x
		tent[id].y = position[id].y + body[id].velocity.y
	}
	
	func resolveDynamicCollisions(id: Int)
	{
		for other in dynamicEntities
		{
			if id != other && overlap(id, other, axis: .X)
			{
				resolveDynamicCollision(id, other, axis: .X)
			}
		}
		
		for other in dynamicEntities
		{
			if id != other && overlap(id, other, axis: .Y)
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
			}
			else
			{
				resolution = tent[b].x - (tent[a].x + body[a].width) - 1
				body[a].velocity.x = min(0, body[a].velocity.x)
				body[b].velocity.x = max(0, body[b].velocity.x)
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
			}
			else
			{
				resolution = tent[b].y - (tent[a].y + body[a].height) - 1
				body[a].velocity.y = min(0, body[a].velocity.y)
				body[b].velocity.y = max(0, body[b].velocity.y)
			}
			
			// Update position (tentative)
			
			tent[a].y += resolution / 2
			tent[b].y -= resolution / 2
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
			if id != other && overlap(id, other, axis: .X)
			{
				resolveStaticCollision(id, tentRect(other), axis: .X)
			}
		}
		
		for other in staticEntities
		{
			if id != other && overlap(id, other, axis: .Y)
			{
				resolveStaticCollision(id, tentRect(other), axis: .Y)
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
	
	func resolveStaticCollision(var id: Int, var _ rect: Rect, axis: LGAxis)
	{
		var collisions: [(id: Int, rect: Rect)] = [ (id: id, rect: rect) ]
		while collisions.count > 0
		{
			id = collisions[0].id
			rect = collisions[0].rect
			collisions.removeAtIndex(0)
			
			switch axis
			{
				case .X:
				
				if tent[id].x > rect.x
				{
					tent[id].x = rect.x + rect.width + 1
					body[id].velocity.x = max(0, body[id].velocity.x)
				}
				else
				{
					tent[id].x = rect.x - body[id].width - 1
					body[id].velocity.x = min(0, body[id].velocity.x)
				}
				
				case .Y:
				
				if tent[id].y > rect.y
				{
					tent[id].y = rect.y + rect.height + 1
					body[id].velocity.y = max(0, body[id].velocity.y)
				}
				else
				{
					tent[id].y = rect.y - body[id].height - 1
					body[id].velocity.y = min(0, body[id].velocity.y)
				}
			}
			
			// Chain collisions
			
			for other in dynamicEntities
			{
				if id != other && overlap(id, other, axis: axis)
				{
					collisions += (id: other, rect: tentRect(id))
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
			
			return !(tent[a].x > tent[b].x + body[b].width + 0.9
				|| tent[a].x < tent[b].x - body[a].width - 0.9
				|| position[a].y > position[b].y + body[b].height
				|| position[a].y < position[b].y - body[a].height
			)
			
			case .Y:
			
			return !(tent[a].x > tent[b].x + body[b].width
				|| tent[a].x < tent[b].x - body[a].width
				|| tent[a].y > tent[b].y + body[b].height + 0.9
				|| tent[a].y < tent[b].y - body[a].height - 0.9
			)
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
		return Int(x / Double(collisionLayer.tileWidth))
	}
	
	func tileAtY(y: Double) -> Int
	{
		return Int(y / Double(collisionLayer.tileHeight))
	}
}
