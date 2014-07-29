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
	
	func constructPhysicsBody(layer: LGTileLayer, tile: LGEntity, row: Int, col: Int)
	{
		// tile.put(LGPhysicsBody(width: Double(map.tileWidth), height: Double(map.tileHeight)))
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
					let tile = LGEntity()
					tile.put(LGPosition(x: Double(map.tileWidth * j), y: Double(map.tileHeight * i)))
					
					if !layer.isCollision
					{
						let sprite = LGSprite(spriteSheet: map.spriteSheet)
						let t = layer.tileAt(row: i, col: j)!
						
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
						
						tile.put(sprite)
					}
					
					// TODO: use an algorithm to create only a few physics bodies instead of one per tile
					if layer.isCollision && layer.collidesAt(row: i, col: j)
					{
						constructPhysicsBody(layer, tile: tile, row: i, col: j)
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
