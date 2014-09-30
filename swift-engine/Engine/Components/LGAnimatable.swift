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
		return [ "defaultAnimation" ]
	}
	
	public class func instantiate() -> LGDeserializable
	{
		return LGAnimatable()
	}
	
	public func setProp(prop: String, val: LGJSON) -> Bool
	{
		switch prop
		{
			case "animations":
				// TODO: replace with for key in val
				for key in val.dictionaryValue!.allKeys as [String]
				{
					var animation: LGAnimation?
					
					if let frame = val[key]?["frame"]?.intValue
					{
						animation = LGAnimation(frame: frame)
					}
					
					if let start = val[key]?["start"]?.intValue
					{
						if let end = val[key]?["end"]?.intValue
						{
							animation = LGAnimation(start: start, end: end)
							
							if let loops = val[key]?["loops"]?.boolValue
							{
								animation!.loops = loops
							}
							
							if let ticksPerFrame = val[key]?["ticksPerFrame"]?.intValue
							{
								animation!.ticksPerFrame = ticksPerFrame
							}
						}
					}
					
					if animation != nil
					{
						animations[key] = animation
					}
				}
				
				return true
			
			case "defaultAnimation":
				currentAnimation = animations[val.stringValue!]
				return true
			
			default:
				break
		}
		
		return false
	}
}
