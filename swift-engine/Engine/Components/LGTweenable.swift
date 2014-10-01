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
	
	public var target: LGVector?
	{
		didSet
		{
			isNew = true
		}
	}
	
	public var original: LGVector!
	public var axis = LGAxis.Both
	public var easing = EasingType.Linear
	public var duration = 60.0
	public var time = 0.0
	public var isNew = false
	
	public init() {}
	
	public enum EasingType
	{
		case Linear, EaseIn, EaseOut, EaseInOut
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
		return []
	}
	
	public class func instantiate() -> LGDeserializable
	{
		return LGTweenable()
	}
	
	public func setValue(value: LGJSON, forKey key: String) -> Bool
	{
		switch key
		{
			case "target":
				target		= target ?? LGVector()
				target!.x	= value["x"]?.doubleValue ?? target!.x
				target!.y	= value["y"]?.doubleValue ?? target!.y
				return true
			
			case "targetX":
				target		= target ?? LGVector()
				target!.x	= value.doubleValue ?? target!.x
				return true
			
			case "targetY":
				target		= target ?? LGVector()
				target!.y	= value.doubleValue ?? target!.y
				return true
			
			case "axis":
				switch value.stringValue
				{
					case .Some(let val) where val == "x":
						axis = .X
						return true
					
					case .Some(let val) where val == "y":
						axis = .Y
						return true
					
					case .Some(let val) where val == "both":
						axis = .Both
						return true
					
					default:
						break
				}
			
			default:
				break
		}
		
		return false
	}
	
	public func valueForKey(key: String) -> LGJSON
	{
		return LGJSON(value: nil)
	}
}
