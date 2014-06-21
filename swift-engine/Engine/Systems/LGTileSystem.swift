//
//  LGTileSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/17/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import UIKit

class LGTileSystem : LGSystem
{
	/*
	var map: LGTileMap!
	
	init()
	{
		super.init()
		self.updatePhase = .None
	}
	
	func loadMap(map: LGTileMap)
	{
		self.map = map
		
		// TODO: Only add entities for the visible part of the map
		
		for layer in map.layers
		{
			for i in 0..map.height
			{
				for j in 0..map.width
				{
					let sprite = LGSprite(spriteSheet: map.spriteSheet)
					sprite.currentState = layer.stateAt(row: i, col: j)
					
					let tile = LGEntity()
					tile.put(
						LGPosition(x: map.tileWidth * j, y: map.tileHeight * i),
						LGNode(sprite: true),
						sprite
					)
					
					entities += tile
					scene.add(tile)
				}
			}
		}
	}
	
	override func update()
	{
		// TODO: Add/remove rows/cols as necessary using a tileEntity pool once the camera system is in place
	}
	*/
}