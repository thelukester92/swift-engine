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
	typealias Point = (x: Double, y: Double)
	
	class func type() -> String
	{
		return "LGPhysicsBody"
	}
	
	func type() -> String
	{
		return LGPhysicsBody.type()
	}
	
	var isStatic			= false
	var velocity:Point		= (x: 0, y: 0)
	var acceleration:Point	= (x: 0, y: 0)
	
	var width: Double
	var height: Double
	
	init(width: Double, height: Double)
	{
		self.width	= width
		self.height	= height
	}
}