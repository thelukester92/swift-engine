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

extension LGPosition: LGDeserializable
{
	public class var requiredProps: [String]
	{
		return []
	}
	
	public class var optionalProps: [String]
	{
		return []
	}
	
	public class func instantiate() -> LGDeserializable
	{
		return LGPosition()
	}
	
	public func setValue(value: LGJSON, forKey key: String) -> Bool
	{
		return false
	}
	
	public func valueForKey(key: String) -> LGJSON
	{
		switch key
		{
			case "x":
				return LGJSON(value: NSNumber(double: x))
			
			case "y":
				return LGJSON(value: NSNumber(double: y))
			
			default:
				break
		}
		
		return LGJSON(value: nil)
	}
}
