//
//  LGRenderingSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 7/14/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGRenderingSystem: LGSystem
{
	var scene: LGScene
	final var positions	= [LGPosition]()
	final var sprites	= [LGSprite]()
	
	init(scene: LGScene)
	{
		self.scene = scene
		
		super.init()
		self.updatePhase = .Render
	}
	
	override func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGPosition) && entity.has(LGSprite)
	}
	
	override func add(entity: LGEntity)
	{
		super.add(entity)
		
		let position	= entity.get(LGPosition)!
		let sprite		= entity.get(LGSprite)!
		var pos			= 1
		
		var node: SKSpriteNode!
		if let _ = sprite.node
		{
			node = sprite.node
		}
		else
		{
			node = SKSpriteNode()
			node.anchorPoint = CGPoint(x: 0.5, y: 0)
			sprite.node = node
		}
		scene.addChild(node)
		
		if let state = sprite.currentState
		{
			pos = state.position
		}
		
		if let texture = sprite.spriteSheet?.textureAtPosition(pos)
		{
			texture.filteringMode = .Nearest
			
			sprite.node.texture = texture
			sprite.node.size = texture.size()
		}
		else if let body = entity.get(LGPhysicsBody)
		{
			sprite.node.color = UIColor.whiteColor()
			sprite.node.size = CGSize(width: CGFloat(body.width), height: CGFloat(body.height))
		}
		
		positions += position
		sprites += sprite
	}
	
	override func update()
	{
		// TODO: Don't render everything every time... only render moved/changed things
		for id in 0 ..< entities.count
		{
			let sprite = sprites[id]
			let position = positions[id]
			
			// Update sprite frame
			
			if let state = sprite.currentState
			{
				// TODO: Don't make it fetch a new texture using textureAtPosition every time
				
				if ++state.counter > state.duration
				{
					state.position++
					if state.position > state.end
					{
						if state.loops
						{
							state.position = state.start
						}
						else
						{
							state.position = state.end
						}
					}
					sprite.node.texture = sprite.spriteSheet?.textureAtPosition(state.position)
					state.counter = 0
				}
			}
			
			// Update sprite position and orientation
			
			sprite.node.position.x	= CGFloat(position.x + sprite.offset.x + CGFloat(sprite.node.size.width / 2))
			sprite.node.position.y	= CGFloat(position.y + sprite.offset.y)
			sprite.node.xScale		= CGFloat(sprite.xScale)
			sprite.node.yScale		= CGFloat(sprite.yScale)
			sprite.node.zRotation	= CGFloat(sprite.rotation)
		}
	}
}
