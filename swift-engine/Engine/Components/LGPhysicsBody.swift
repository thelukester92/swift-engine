//
//  LGPhysicsBody.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGPhysicsBody: LGComponent
{
	class func type() -> String
	{
		return "LGPhysicsBody"
	}
	
	func type() -> String
	{
		return LGPhysicsBody.type()
	}
	
	var skphysicsbody: SKPhysicsBody
	
	init(skphysicsbody: SKPhysicsBody)
	{
		self.skphysicsbody = skphysicsbody
		
		// Initial settings for the physics body
		// TODO: Expose these as computed properties
		skphysicsbody.mass = 1
		skphysicsbody.friction = 0
		skphysicsbody.restitution = 0
		skphysicsbody.linearDamping = 0
		skphysicsbody.allowsRotation = false
	}
	
	convenience init()
	{
		self.init(skphysicsbody: SKPhysicsBody())
	}
}