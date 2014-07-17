//
//  LGPosition.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGPosition: LGComponent
{
	class func type() -> String
	{
		return "LGPosition"
	}
	
	func type() -> String
	{
		return LGPosition.type()
	}
		
	var x: Double
	var y: Double
	
	init(x: Double, y: Double)
	{
		self.x = x
		self.y = y
	}
	
	convenience init()
	{
		self.init(x: 0, y: 0)
	}
}