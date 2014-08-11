//
//  LGAnimatable.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/8/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

final class LGAnimatable: LGComponent
{
	class func type() -> String
	{
		return "LGAnimatable"
	}
	
	func type() -> String
	{
		return LGAnimatable.type()
	}
	
	var animations: [String:LGAnimation]
	var counter = 0
	
	var currentAnimation: LGAnimation?
	
	init(animations: [String:LGAnimation])
	{
		self.animations = animations
	}
	
	convenience init()
	{
		self.init(animations: [String:LGAnimation]())
	}
	
	func gotoAnimation(name: String)
	{
		currentAnimation = animations[name]
	}
}
