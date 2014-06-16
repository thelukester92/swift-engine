//
//  LGNodeSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/16/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//
//	Attaches an entity's LGNode to the LGScene

import SpriteKit

class LGNodeSystem: LGSystem
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
		return entity.has( LGNode.type() )
	}
	
	override func add(entity: LGEntity)
	{
		super.add(entity)
		
		let node = entity.get( LGNode.type() ) as LGNode
		scene.addChild(node.sknode)
	}
}