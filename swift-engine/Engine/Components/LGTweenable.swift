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
