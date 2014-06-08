//
//  LGPhysicalSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

class LGPhysicalSystem: LGSystem
{
	init()
	{
		super.init()
		self.updatePhase = .None
	}
	
	override func accepts(entity: LGEntity) -> Bool
	{
		return entity.has( LGPhysicsBody.type(), LGNode.type() )
	}
	
	override func add(entity: LGEntity)
	{
		super.add(entity)
		
		let body	= entity.get( LGPhysicsBody.type() ) as LGPhysicsBody
		let node	= entity.get( LGNode.type() ) as LGNode
		
		node.sknode.physicsBody = body
	}
}