//
//  LGSpriteSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//
//	Attaches an entity's LGSprite to its LGNode
//	Animates sprites each frame

import SpriteKit

class LGSpriteSystem: LGSystem
{
	var scene: LGScene
	
	init(scene: LGScene)
	{
		self.scene = scene
		
		super.init()
		self.updatePhase = .Last
	}
	
	override func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGSprite)
	}
	
	override func add(entity: LGEntity)
	{
		super.add(entity)
		
		let sprite	= entity.get(LGSprite)!
		var pos		= 1
		
		let node = SKSpriteNode()
		node.anchorPoint = CGPoint(x: 0, y: 0)
		sprite.node = node
		scene.addChild(node)
		
		if let position = entity.get(LGPosition)
		{
			node.position.x = CGFloat(position.x)
			node.position.y = CGFloat(position.y)
			position.node = node
		}
		
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
	}
	
	override func update()
	{/*
		for entity in self.entities
		{
			let sprite = entity.get(LGSprite)!
			
			if let state = sprite.currentState
			{
				// TODO: Don't make it fetch a new texture using textureAtPosition every time...
				
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
		}*/
	}
}