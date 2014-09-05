//
//  PlatformSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/11/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import LGSwiftEngine

class PlatformSystem: LGSystem
{
	override func update()
	{
		let position = scene.entityNamed("platform")!.get(LGPosition)!
		let bod = scene.entityNamed("platform")!.get(LGPhysicsBody)!
		
		if bod.velocity.x == 0
		{
			bod.velocity.x = -1
		}
		
		if position.x + 32 > Double(scene.view.frame.size.width) || position.x <= 1
		{
			bod.velocity.x = -bod.velocity.x
		}
	}
}
