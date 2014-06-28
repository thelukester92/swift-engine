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
	
	init(scene: LGScene)
	{
		self.scene = scene
		
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
					sprite.currentState = LGSpriteState(position: layer.tileAt(row: i, col: j)!.pos)
					
					/* TODO: Make sure anchor points are good
					let node = LGNode(sprite: true)
					let snode = node.sknode as SKSpriteNode
					snode.anchorPoint = CGPointMake(0, 0)
					*/
					
					let tile = LGEntity()
					tile.put(
						LGPosition(x: Double(map.tileWidth * j), y: Double(map.tileHeight * (map.height - i - 1))),
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
}