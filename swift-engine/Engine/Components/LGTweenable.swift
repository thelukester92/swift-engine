//
//  LGTweenable.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/20/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGTweenable: LGComponent
{
	public class func type() -> String
	{
		return "LGTweenable"
	}
	
	public func type() -> String
	{
		return LGTweenable.type()
	}
	
	public var originalX: Double!
	public var originalY: Double!
	public var isNew = false
	
	public var targetX: Double?
	{
		didSet { isNew = true }
	}
	
	public var targetY: Double?
	{
		didSet { isNew = true }
	}
	
	public var easingType = EasingType.Linear
	public var duration = 60.0
	public var time = 0.0
	
	public init() {}
	
	public enum EasingType: Int
	{
		case Linear = 0, EaseIn, EaseOut, EaseInOut
	}
}

extension LGTweenable: LGDeserializable
{
	public class var requiredProps: [String]
	{
		return []
	}
	
	public class var optionalProps: [String]
	{
		return [ "targetX", "targetY", "easingType", "duration", "time" ]
	}
	
	public class func instantiate() -> LGDeserializable
	{
		return LGTweenable()
	}
	
	public func setValue(value: LGJSON, forKey key: String) -> Bool
	{
		switch key
		{
			case "targetX":
				targetX = value.doubleValue ?? targetX
			
			case "targetY":
				targetY = value.doubleValue ?? targetY
			
			case "easingType":
				easingType = EasingType.fromRaw(value.intValue ?? 0) ?? .Linear
			
			case "duration":
				duration = value.doubleValue ?? duration
			
			case "time":
				time = value.doubleValue ?? duration
			
			default:
				return false
		}
		
		return true
	}
	
	public func valueForKey(key: String) -> LGJSON
	{
		var value = LGJSON()
		
		switch key
		{
			case "targetX":
				if targetX != nil
				{
					value.value = NSNumber(double: targetX!)
				}
				
			case "targetY":
				if targetY != nil
				{
					value.value = NSNumber(double: targetY!)
				}
				
			case "easingType":
				value.value = NSNumber(integer: easingType.toRaw())
				
			case "duration":
				value.value = NSNumber(double: duration)
				
			case "time":
				value.value = NSNumber(double: time)
				
			default:
				break
		}
		
		return value
	}
}
