//
//  LGAnimatable.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/8/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGAnimatable: LGComponent
{
	public class func type() -> String
	{
		return "LGAnimatable"
	}
	
	public func type() -> String
	{
		return LGAnimatable.type()
	}
	
	public var animations: [String:LGAnimation]
	public var counter = 0
	
	public var currentAnimation: LGAnimation?
	
	public init(animations: [String:LGAnimation])
	{
		self.animations = animations
	}
	
	public convenience init()
	{
		self.init(animations: [String:LGAnimation]())
	}
	
	public func gotoAnimation(name: String)
	{
		currentAnimation = animations[name]
	}
}
