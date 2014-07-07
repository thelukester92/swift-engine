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
					
					let tile = LGEntity()
					tile.put(
						LGPosition(x: Double(map.tileWidth * j), y: Double(map.tileHeight * (map.height - i - 1))),
						sprite
					)
					
					// TODO: only do this for a single layer -- the collision layer
					// TODO: use an algorithm to create only a few physics bodies instead of one per tile
					if let pos = sprite.currentState?.position
					{
						if pos > 0
						{
							tile.put(LGPhysicsBody(skphysicsbody: SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: map.tileWidth, height: map.tileHeight))))
						}
					}
					
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