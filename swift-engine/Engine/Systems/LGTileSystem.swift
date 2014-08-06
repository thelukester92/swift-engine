//
//  LGTileSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/17/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

class LGTileSystem : LGSystem
{
	var scene: LGScene
	var map: LGTileMap!
	
	final var reusePool		= [Int]()
	final var entitiesByRow	= [Int:[Int]]()
	final var entitiesByCol	= [Int:[Int]]()
	final var rowsByEntity	= [Int:Int]()
	final var colsByEntity	= [Int:Int]()
	
	var nextLocalId = 0
	
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
		
		if !cameraPosition && !camera
		{
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
			minRow = Int(cameraPosition.x / Double(map.tileWidth)) - 1
			maxRow = minRow
			minCol = Int(cameraPosition.y / Double(map.tileHeight)) - 1
			maxCol = minCol
		}
	}
	
	func reuseTileEntity(#layer: LGTileLayer, row: Int, col: Int)
	{
		let t = layer.tileAt(row: row, col: col)!
		
		var localId: Int!
		var tile: LGEntity!
		var position: LGPosition!
		var sprite: LGSprite!
		
		// Create or reuse a tile entity
		
		if reusePool.count > 0
		{
			localId		= reusePool.removeLast()
			tile		= entities[localId]
			position	= tile.get(LGPosition)!
			sprite		= tile.get(LGSprite)!
		}
		else
		{
			localId		= nextLocalId++
			tile		= LGEntity()
			position	= LGPosition()
			sprite		= LGSprite(spriteSheet: map.spriteSheet)
			
			entities += tile
			
			tile.put(position, sprite)
			scene.addEntity(tile)
		}
		
		// Index the entity
		
		rowsByEntity[localId] = row
		if var arr = entitiesByRow[row]
		{
			arr += localId
			entitiesByRow[row] = arr
		}
		else
		{
			entitiesByRow[row] = [localId]
		}
		
		colsByEntity[localId] = col
		if var arr = entitiesByCol[col]
		{
			arr += localId
			entitiesByCol[col] = arr
		}
		else
		{
			entitiesByCol[col] = [localId]
		}
		
		// Place entity and update its sprite
		
		position.x = Double(map.tileWidth * col)
		position.y = Double(map.tileHeight * row)
		
		sprite.opacity		= layer.opacity
		sprite.layer		= layer.renderLayer.toRaw()
		sprite.position		= t.pos
		sprite.offset.x		= 0
		sprite.offset.y		= 0
		sprite.scale.x		= 1.0
		sprite.scale.y		= 1.0
		sprite.rotation		= 0.0
		sprite.isVisible	= true
		
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
	
	func recycleTileEntity(localId: Int)
	{
		let sprite = entities[localId].get(LGSprite)!
		sprite.isVisible = false
		
		reusePool += localId
		
		colsByEntity[localId] = nil
		rowsByEntity[localId] = nil
	}
	
	func recycleCol(col: Int)
	{
		if let entitiesInCol = entitiesByCol[col]
		{
			for localId in entitiesInCol
			{
				// Make sure this entity hasn't already been recycled by row
				if !(!colsByEntity[localId]) && col == colsByEntity[localId]
				{
					recycleTileEntity(localId)
				}
			}
			entitiesByCol[col] = nil
		}
	}
	
	func recycleRow(row: Int)
	{
		if let entitiesInRow = entitiesByRow[row]
		{
			for localId in entitiesInRow
			{
				// Make sure this entity hasn't already been recycled by col
				if !(!rowsByEntity[localId]) && row == rowsByEntity[localId]
				{
					recycleTileEntity(localId)
				}
			}
			entitiesByRow[row] = nil
		}
	}
	
	override func update()
	{
		if !(!cameraPosition && !camera)
		{
			let cam = (x: cameraPosition.x + camera.offset.x, y: cameraPosition.y + camera.offset.y, width: camera.size.x, height: camera.size.y)
			
			// Remove columns
			while Int(cam.x / Double(map.tileWidth)) > minCol
			{
				recycleCol(minCol)
				minCol++
			}
			
			while Int((cam.x + cam.width) / Double(map.tileWidth)) < maxCol
			{
				recycleCol(maxCol)
				maxCol--
			}
			
			// Remove rows
			
			while Int(cam.y / Double(map.tileHeight)) > minRow
			{
				recycleRow(minRow)
				minRow++
			}
			
			while Int((cam.y + cam.height) / Double(map.tileHeight)) < maxRow
			{
				recycleRow(maxRow)
				maxRow--
			}
			
			// Ensure that min is less than max
			
			maxCol = max(minCol, maxCol)
			maxRow = max(minRow, maxRow)
			
			// Add columns
			
			// TODO: check for out-of-bounds before doing all these loops (currently checked in layer.visibleAt)
			
			if Int(cam.x / Double(map.tileWidth)) < minCol
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
			
			while Int((cam.x + cam.width) / Double(map.tileWidth)) > maxCol
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
			
			while Int(cam.y / Double(map.tileHeight)) < minRow
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
			
			while Int((cam.y + cam.height) / Double(map.tileHeight)) > maxRow
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
