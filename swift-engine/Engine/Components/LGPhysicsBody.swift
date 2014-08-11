//
//  LGPhysicsBody.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

public class LGPhysicsBody: LGComponent
{
	public class func type() -> String
	{
		return "LGPhysicsBody"
	}
	
	public func type() -> String
	{
		return LGPhysicsBody.type()
	}
	
	public var dynamic	= true
	public var velocity	= LGVector()
	
	public var width: Double
	public var height: Double
	
	// TODO: allow other kinds of directional collisions
	public var onlyCollidesOnTop = false
	
	public var collidedTop		= false
	public var collidedBottom	= false
	public var collidedLeft		= false
	public var collidedRight	= false
	
	public init(width: Double, height: Double)
	{
		self.width	= width
		self.height	= height
	}
	
	public func resetCollided()
	{
		collidedTop		= false
		collidedBottom	= false
		collidedLeft	= false
		collidedRight	= false
	}
}
