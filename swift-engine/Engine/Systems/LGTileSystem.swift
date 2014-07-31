//
//  LGTileSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/17/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGTileSystem : LGSystem
{
	var scene: LGScene
	var map: LGTileMap!
	
	final var reusePool		= [LGEntity]()
	final var entitiesByRow	= [Int:[LGEntity]]()
	final var entitiesByCol	= [Int:[LGEntity]]()
	
	var minRow = 0
	var maxRow = 0
	var minCol = 0
	var maxCol = 0
	
	var cameraPosition: LGPosition!
	var camera: LGCamera!
	
	init(scene: LGScene)
	{
		self.scene = scene
		super.init()
	}
	
	override func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGPosition) && entity.has(LGCamera)
	}
	
	override func add(entity: LGEntity)
	{
		cameraPosition	= entity.get(LGPosition)
		camera			= entity.get(LGCamera)
	}
	
	func loadMap(map: LGTileMap)
	{
		self.map = map
		
		if cameraPosition == nil && camera == nil
		{
			println("No visible area defined; rendering the entire map.")
			
			// Render the entire map when no visible area is defined
			for layer in map.layers
			{
				for i in 0 ..< map.height
				{
					for j in 0 ..< map.width
					{
						if layer.visibleAt(row: i, col: j)
						{
							reuseTileEntity(layer: layer, row: i, col: j)
						}
					}
				}
			}
		}
		else
		{
			println("Visible area detected; will render visible part of the map in the update method.")
		}
	}
	
	func reuseTileEntity(#layer: LGTileLayer, row: Int, col: Int)
	{
		let t = layer.tileAt(row: row, col: col)!
		
		var tile: LGEntity!
		var position: LGPosition!
		var sprite: LGSprite!
		
		// Create or reuse a tile entity
		
		if reusePool.count > 0
		{
			tile		= reusePool.removeLast()
			position	= tile.get(LGPosition)!
			sprite		= tile.get(LGSprite)!
			
			sprite.isVisible = true
		}
		else
		{
			tile		= LGEntity()
			position	= LGPosition()
			sprite		= LGSprite(spriteSheet: map.spriteSheet)
			
			tile.put(position, sprite)
			scene.add(tile)
		}
		
		// Index the entity and keep record of extremes
		
		minRow = min(row, minRow)
		maxRow = max(row, maxRow)
		minCol = min(col, minCol)
		maxCol = max(col, maxCol)
		
		if var arr = entitiesByRow[row]
		{
			arr += tile
			entitiesByRow[row] = arr
		}
		else
		{
			entitiesByRow[row] = [tile]
		}
		
		if var arr = entitiesByCol[col]
		{
			arr += tile
			entitiesByCol[col] = arr
		}
		else
		{
			entitiesByCol[col] = [tile]
		}
		
		// Place entity and update its sprite
		
		position.x = Double(map.tileWidth * col)
		position.y = Double(map.tileHeight * row)
		
		sprite.opacity		= layer.opacity
		sprite.layer		= layer.renderLayer.toRaw()
		sprite.currentState	= LGSpriteState(position: t.pos)
		
		if t.flippedDiagonal
		{
			if t.flippedHorizontal
			{
				sprite.rotation = -M_PI_2
			}
			else if t.flippedVertical
			{
				sprite.rotation = M_PI_2
			}
			else
			{
				sprite.rotation	= -M_PI_2
				sprite.scale.y	= -1
			}
		}
		else
		{
			sprite.scale.x = t.flippedHorizontal ? -1 : 1
			sprite.scale.y = t.flippedVertical ? -1 : 1
		}
	}
	
	func recycleTileEntity(entity: LGEntity)
	{
		let sprite = entity.get(LGSprite)!
		sprite.isVisible = false
		
		reusePool += entity
	}
	
	func recycleTileEntities(entities: [LGEntity])
	{
		for entity in entities
		{
			recycleTileEntity(entity)
		}
	}
	
	override func update()
	{
		if cameraPosition && camera
		{
			// Remove columns
			
			while Int(cameraPosition.x / map.tileWidth) > minCol
			{
				if let entitiesInCol = entitiesByCol[minCol]
				{
					recycleTileEntities(entitiesInCol)
					entitiesByCol[minCol] = nil
				}
				minCol++
			}
			
			while Int((cameraPosition.x + camera.size.x) / map.tileWidth) < maxCol
			{
				if let entitiesInCol = entitiesByCol[maxCol]
				{
					recycleTileEntities(entitiesInCol)
					entitiesByCol[maxCol] = nil
				}
				maxCol--
			}
			
			// Remove rows
			
			while Int(cameraPosition.y / map.tileHeight) > minRow
			{
				if let entitiesInRow = entitiesByRow[minRow]
				{
					recycleTileEntities(entitiesInRow)
					entitiesByRow[minRow] = nil
				}
				minRow++
			}
			
			while Int((cameraPosition.y + camera.size.y) / map.tileHeight) < maxRow
			{
				if let entitiesInRow = entitiesByRow[maxRow]
				{
					recycleTileEntities(entitiesInRow)
					entitiesByRow[maxRow] = nil
				}
				maxRow--
			}
			
			// Add columns
			
			// TODO: check for out-of-bounds before doing all these loops (currently checked in layer.visibleAt)
			
			while Int(cameraPosition.x / map.tileWidth) < minCol
			{
				minCol--
				
				for layer in map.layers
				{
					for i in minRow...maxRow
					{
						if layer.visibleAt(row: i, col: minCol)
						{
							reuseTileEntity(layer: layer, row: i, col: minCol)
						}
					}
				}
			}
			
			while Int((cameraPosition.x + camera.size.x) / map.tileWidth) > maxCol
			{
				maxCol++
				
				for layer in map.layers
				{
					for i in minRow...maxRow
					{
						if layer.visibleAt(row: i, col: maxCol)
						{
							reuseTileEntity(layer: layer, row: i, col: maxCol)
						}
					}
				}
			}
			
			// Add rows
			
			while Int(cameraPosition.y / map.tileHeight) < minRow
			{
				minRow--
				
				for layer in map.layers
				{
					for i in minCol...maxCol
					{
						if layer.visibleAt(row: minRow, col: i)
						{
							reuseTileEntity(layer: layer, row: minRow, col: i)
						}
					}
				}
			}
			
			while Int((cameraPosition.y + camera.size.y) / map.tileHeight) > maxRow
			{
				maxRow++
				
				for layer in map.layers
				{
					for i in minCol...maxCol
					{
						if layer.visibleAt(row: maxRow, col: i)
						{
							reuseTileEntity(layer: layer, row: maxRow, col: i)
						}
					}
				}
			}
		}
	}
}