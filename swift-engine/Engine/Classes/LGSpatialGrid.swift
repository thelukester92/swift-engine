//
//  LGSpatialGrid.swift
//  swift-engine
//
//  Created by Luke Godfrey on 7/8/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

class LGSpatialGrid
{
	var grid: [Int: [LGEntity]]	= [:]
	var cellSize: Double		= 100
	var rowHash					= 10000
	
	func clear()
	{
		grid = [:]
	}
	
	func insertEntity(entity: LGEntity)
	{
		let position	= entity.get(LGPosition)!
		let row			= cellAt(position.y)
		let col			= cellAt(position.x)
		
		if var cell = grid[row * rowHash + col]
		{
			cell += entity
			grid[row * rowHash + col] = cell
		}
		else
		{
			grid[row * rowHash + col] = [entity]
		}
	}
	
	func entitiesNearEntity(entity: LGEntity, withFilter filter: (LGEntity) -> Bool = {e in return true}) -> [LGEntity]
	{
		let position	= entity.get(LGPosition)!
		let body		= entity.get(LGPhysicsBody)!
		let row			= cellAt(position.y)
		let col			= cellAt(position.x)
		
		var entities: [LGEntity] = []
		
		for i in row...cellAt(position.y + body.height)
		{
			for j in col...cellAt(position.x + body.width)
			{
				if let cell = grid[row * rowHash + col]
				{
					for e in cell
					{
						if filter(e)
						{
							entities += e
						}
					}
				}
			}
		}
		
		return entities
	}
	
	func cellAt(px: Double) -> Int
	{
		return Int(px / cellSize)
	}
}
