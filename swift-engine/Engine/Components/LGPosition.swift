//
//  LGPosition.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

public final class LGPosition: LGComponent
{
	public class func type() -> String
	{
		return "LGPosition"
	}
	
	public func type() -> String
	{
		return LGPosition.type()
	}
		
	public var x: Double
	public var y: Double
	
	public init(x: Double, y: Double)
	{
		self.x = x
		self.y = y
	}
	
	public convenience init()
	{
		self.init(x: 0, y: 0)
	}
}
