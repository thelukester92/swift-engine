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
	init()
	{
		super.init()
		self.updatePhase = .Render
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
		
		var node: SKSpriteNode!
		if let _ = sprite.node
		{
			node = sprite.node
		}
		else
		{
			node = SKSpriteNode()
			sprite.node = node
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