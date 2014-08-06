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
	
	var dynamic		= true
	var velocity	= LGVector()
	
	var width: Double
	var height: Double
	
	// TODO: allow other kinds of directional collisions
	var onlyCollidesOnTop = false
	
	var collidedTop		= false
	var collidedBottom	= false
	var collidedLeft	= false
	var collidedRight	= false
	
	init(width: Double, height: Double)
	{
		self.width	= width
		self.height	= height
	}
	
	func resetCollided()
	{
		collidedTop		= false
		collidedBottom	= false
		collidedLeft	= false
		collidedRight	= false
	}
}
