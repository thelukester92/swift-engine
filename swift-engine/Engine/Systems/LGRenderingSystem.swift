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
		// TODO: Don't depend on super's ordering in array
		super.add(entity)
		
		let position = entity.get(LGPosition)!
		let sprite = entity.get(LGSprite)!
		
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
		
		positions += position
		sprites += sprite
	}
	
	override func update()
	{
		// TODO: Don't render everything every time... only render moved things
		for id in 0 ..< entities.count
		{
			let sprite = sprites[id]
			let position = positions[id]
			
			sprite.node.position.x = CGFloat(position.x + sprite.offset.x + Double(sprite.node.size.width / 2))
			sprite.node.position.y = CGFloat(position.y + sprite.offset.y)
		}
	}
}