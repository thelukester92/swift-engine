//
//  LGSpriteSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGSpriteSystem: LGSystem
{
	var scene: SKScene
	
	init(scene: SKScene)
	{
		self.scene = scene
		
		super.init()
		self.updatePhase = .Last
	}
	
	override func accepts(entity: LGEntity) -> Bool
	{
		return entity.has( LGSprite.type(), LGNode.type() )
	}
	
	override func add(entity: LGEntity)
	{
		super.add(entity)
		
		let sprite	= entity.get( LGSprite.type() ) as LGSprite
		let node	= entity.get( LGNode.type() ) as LGNode
		var pos		= 1
		
		if let state = sprite.currentState
		{
			pos = state.position
		}
		
		sprite.node = node.sknode as SKSpriteNode
		sprite.node.texture = sprite.spriteSheet?.textureAtPosition(pos)
		sprite.node.size = sprite.node.texture.size()
		
		scene.addChild(sprite.node)
	}
	
	override func update()
	{
		for entity in self.entities
		{
			let sprite: LGSprite = entity.get( LGSprite.type() ) as LGSprite
			if let state = sprite.currentState
			{
				if(++state.counter > state.duration)
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
		}
	}
}