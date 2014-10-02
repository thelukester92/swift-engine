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
	
	public init(animations: [String:LGAnimation], defaultAnimation: String? = nil)
	{
		self.animations = animations
		
		if defaultAnimation != nil
		{
			currentAnimation = animations[defaultAnimation!]
		}
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

extension LGAnimatable: LGDeserializable
{
	public class var requiredProps: [String]
	{
		return [ "animations" ]
	}
	
	public class var optionalProps: [String]
	{
		return [ "currentAnimation" ]
	}
	
	public class func instantiate() -> LGDeserializable
	{
		return LGAnimatable()
	}
	
	public func setValue(value: LGJSON, forKey key: String) -> Bool
	{
		switch key
		{
			case "animations":
				// TODO: replace with for key in val
				for vKey in value.dictionaryValue!.allKeys as [String]
				{
					var animation: LGAnimation?
					
					if let frame = value[vKey]?["frame"]?.intValue
					{
						animation = LGAnimation(frame: frame)
					}
					
					if let start = value[vKey]?["start"]?.intValue
					{
						if let end = value[vKey]?["end"]?.intValue
						{
							animation = LGAnimation(start: start, end: end)
							
							if let loops = value[vKey]?["loops"]?.boolValue
							{
								animation!.loops = loops
							}
							
							if let ticksPerFrame = value[vKey]?["ticksPerFrame"]?.intValue
							{
								animation!.ticksPerFrame = ticksPerFrame
							}
						}
					}
					
					if animation != nil
					{
						animations[vKey] = animation
					}
				}
			
			case "currentAnimation":
				currentAnimation = value.stringValue != nil ? animations[value.stringValue!] : currentAnimation
			
			default:
				return false
		}
		
		return true
	}
	
	public func valueForKey(key: String) -> LGJSON
	{
		return LGJSON(value: nil)
	}
}
