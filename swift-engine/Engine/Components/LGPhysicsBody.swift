//
//  LGPhysicsBody.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGPhysicsBody: SKPhysicsBody, LGComponent
{
	class func type() -> String
	{
		return "LGPhysicsBody"
	}
	
	func type() -> String
	{
		return LGPhysicsBody.type()
	}
}