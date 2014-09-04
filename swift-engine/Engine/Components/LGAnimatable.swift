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
	public class func deserialize(serialized: String) -> LGComponent?
	{
		if let json = LGJSON.JSONFromString(serialized)
		{
			if let anims = json["animations"]
			{
				var animations = [String:LGAnimation]()
				
				for key in anims.dictionaryValue!.allKeys as [String]
				{
					var animation: LGAnimation?
					
					if let frame = anims[key]?["frame"]?.intValue
					{
						animation = LGAnimation(frame: frame)
					}
					
					if let start = anims[key]?["start"]?.intValue
					{
						if let end = anims[key]?["end"]?.intValue
						{
							animation = LGAnimation(start: start, end: end)
							
							if let loops = anims[key]?["loops"]?.boolValue
							{
								animation!.loops = loops
							}
							
							if let ticksPerFrame = anims[key]?["ticksPerFrame"]?.intValue
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
				
				return LGAnimatable(animations: animations, defaultAnimation: json["defaultAnimation"]?.stringValue)
			}
		}
		
		return nil
	}
}
