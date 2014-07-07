//
//  LGSpriteKitSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/27/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGSpriteKitSystem: LGSystem
{
	var scene: SKScene
	
	init(scene: SKScene)
	{
		self.scene = scene
		
		super.init()
		self.updatePhase = .None
	}
	
	override func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGSprite) || entity.has(LGPhysicsBody)
	}
	
	override func add(entity: LGEntity)
	{
		var node: SKNode!
		
		if let sprite = entity.get(LGSprite)
		{
			node = SKSpriteNode()
			sprite.node = node as SKSpriteNode
			sprite.node.anchorPoint = CGPointMake(0, 0)
		}
		else
		{
			node = SKNode()
		}
		
		if let position = entity.get(LGPosition)
		{
			node.position.x = CGFloat(position.x)
			node.position.y = CGFloat(position.y)
			position.node = node
		}
		
		if let physicsBody = entity.get(LGPhysicsBody)
		{
			node.physicsBody = physicsBody.skphysicsbody
		}
		
		scene.addChild(node)
	}
}