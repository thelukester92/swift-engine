//
//  LGPositionSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGPositionSystem: LGSystem
{
	init()
	{
		super.init()
		self.updatePhase = .None
	}
	
	override func accepts(entity: LGEntity) -> Bool
	{
		return entity.has( LGPosition.type(), LGNode.type() )
	}
	
	override func add(entity: LGEntity)
	{
		super.add(entity)
		
		let position	= entity.get( LGPosition.type() ) as LGPosition
		let node		= entity.get( LGNode.type() ) as LGNode
		
		node.sknode.position = CGPointMake(CGFloat(position.x), CGFloat(position.y))
		position.node = node.sknode
	}
}