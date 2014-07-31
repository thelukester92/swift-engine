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
	
	var reusePool = [LGEntity]()
	
	init(scene: LGScene)
	{
		self.scene = scene
		super.init()
	}
	
	func loadMap(map: LGTileMap)
	{
		self.map = map
		
		// TODO: Only add entities for the visible part of the map
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
	
	func reuseTileEntity(#layer: LGTileLayer, row: Int, col: Int)
	{
		let t = layer.tileAt(row: row, col: col)!
		
		var tile: LGEntity!
		var position: LGPosition!
		var sprite: LGSprite!
		
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
		
		position.x = Double(map.tileWidth * col)
		position.y = Double(map.tileHeight * row)
		
		sprite.opacity		= layer.opacity
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
	
	override func update()
	{
		/*
		algorithm:
		1.	get visible area rect (i.e. from the camera entity)
		2.	if any cols are out of the visible rect
			a. recycle tile entities in that col (adds to reuse pool)
			b. reuse them for new col (gets from reuse pool)
		3.	if any rows are out of the visible rect
			a. recycle tile entities in that row (adds to reuse pool)
			b. reuse them for new row (gets from reuse pool)
		*/
	}
}
