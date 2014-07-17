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
	var positions = [LGPosition]()
	var nodes = [SKSpriteNode]()
	
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
			node.anchorPoint = CGPoint(x: 0, y: 0)
			sprite.node = node
		}
		
		scene.addChild(node)
		
		positions += position
		nodes += node
	}
	
	override func update()
	{
		for id in 0 ..< entities.count
		{
			nodes[id].position.x = CGFloat(positions[id].x)
			nodes[id].position.y = CGFloat(positions[id].y)
		}
	}
}