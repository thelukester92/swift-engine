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
	typealias Vector = (x: Double, y: Double)
	
	let TERMINAL_VELOCITY: Double = 32
	let GRAVITY: Vector = (0, -0.5)
	
	let AXIS_X: UInt8 = 0x1 << 0
	let AXIS_Y: UInt8 = 0x1 << 1
	
	var dynamicEntities = [LGEntity]()
	var staticEntities = [LGEntity]()
	var collisionLayer: LGTileLayer!
	
	// MARK: LGSystem Overrides
	
	init()
	{
		super.init()
	}
	
	override func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGPosition) && entity.has(LGPhysicsBody)
	}
	
	override func add(entity: LGEntity)
	{
		super.add(entity)
		
		if entity.get(LGPhysicsBody)!.isStatic
		{
			staticEntities += entity
		}
		else
		{
			dynamicEntities += entity
		}
	}
	
	override func update()
	{
		for entity in dynamicEntities
		{
			applyPhysicsToEntity(entity)
		}
		
		for entity in dynamicEntities
		{
			resolveCollisionsForEntity(entity)
		}
	}
	
	// MARK: Update Methods
	
	func applyPhysicsToEntity(entity: LGEntity)
	{
		let position	= entity.get(LGPosition)!
		let body		= entity.get(LGPhysicsBody)!
		
		body.acceleration = GRAVITY
		
		body.velocity.x += body.acceleration.x
		body.velocity.y += body.acceleration.y
		
		if body.velocity.x > TERMINAL_VELOCITY
		{
			body.velocity.x = TERMINAL_VELOCITY
		}
		else if body.velocity.x < -TERMINAL_VELOCITY
		{
			body.velocity.x = -TERMINAL_VELOCITY
		}
		
		if body.velocity.y > TERMINAL_VELOCITY
		{
			body.velocity.y = TERMINAL_VELOCITY
		}
		else if body.velocity.y < -TERMINAL_VELOCITY
		{
			body.velocity.y = -TERMINAL_VELOCITY
		}
		
		position.x += body.velocity.x
		position.y += body.velocity.y
	}
	
	func resolveCollisionsForEntity(entity: LGEntity)
	{
		let position	= entity.get(LGPosition)!
		let body		= entity.get(LGPhysicsBody)!
		let rect		= rectForPosition(position, body: body)
		
		// Static tile collisions
		if collisionLayer
		{
			// AXIS_X
			
			position.y -= body.velocity.y
			
			outerLoop:
			for j in [tileAt(position.x), tileAt(position.x + body.width)]
			{
				for i in tileAt(position.y)...tileAt(position.y + body.height)
				{
					if collisionLayer.collidesAt(row: i, col: j)
					{
						resolve(dynamicEntity: entity, withPosition: position, andBody: body, withStaticRect: rectForTile(row: i, col: j), onAxis: AXIS_X)
						break outerLoop
					}
				}
			}
			
			position.y += body.velocity.y
			
			// AXIS_Y
			
			position.x -= body.velocity.x
			
			outerLoop:
			for i in [tileAt(position.y), tileAt(position.y + body.height)]
			{
				for j in tileAt(position.x)...tileAt(position.x + body.width)
				{
					if collisionLayer.collidesAt(row: i, col: j)
					{
						resolve(dynamicEntity: entity, withPosition: position, andBody: body, withStaticRect: rectForTile(row: i, col: j), onAxis: AXIS_Y)
						break outerLoop
					}
				}
			}
			
			position.x += body.velocity.x
		}
	}
	
	// MARK: Collision Resolution Methods
	
	func resolve(dynamicEntity entity: LGEntity, withPosition position: LGPosition, andBody body: LGPhysicsBody, withStaticRect rect: Rect, onAxis axis: UInt8)
	{
		if axis & AXIS_Y > 0
		{
			if position.y > rect.y
			{
				position.y = rect.y + rect.height
			}
			else
			{
				position.y = rect.y - body.height
			}
			body.velocity.y = 0
		}
		else if axis & AXIS_X > 0
		{
			if position.x > rect.x
			{
				position.x = rect.x + rect.width + 120
			}
			else
			{
				position.x = rect.x - body.width
			}
			body.velocity.x = 0
		}
	}
	
	// MARK: Helper Methods
	
	func tileAt(px: Double) -> Int
	{
		return Int(px / 32)
	}
	
	func rectForTile(#row: Int, col: Int) -> Rect
	{
		return (x: Double(col * 32), y: Double(row * 32), width: 32, height: 32)
	}
	
	func rectForPosition(position: LGPosition, body: LGPhysicsBody) -> Rect
	{
		return (x: position.x, y: position.y, width: body.width, height: body.height)
	}
	
	func resolutionForRects(a: Rect, _ b: Rect) -> Vector
	{
		var resolution: Vector = (0, 0)
		
		resolution.x = b.x > a.x ? b.x - a.x - a.width : b.x + b.width - a.x;
		resolution.y = b.y > a.y ? b.y - a.y - a.height : b.y + b.height - a.y;
		
		return resolution
	}
}