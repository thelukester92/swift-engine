//
//  LGDeserializer.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/4/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public class LGDeserializer
{
	// TODO: Don't use this hidden wrapper around LGDeserializable
	// This is currently needed because Swift is stupid and has a segfault at compile time if we pass LGDeserializable.Type directly
	struct Deserializable
	{
		var requiredProps: [String]
		var optionalProps: [String]
		var instantiate: () -> LGDeserializable
		var actualDeserializable: LGDeserializable.Type
		
		init(requiredProps: [String], optionalProps: [String], instantiate: @autoclosure () -> LGDeserializable, actualDeserializable: LGDeserializable.Type)
		{
			self.requiredProps			= requiredProps
			self.optionalProps			= optionalProps
			self.instantiate			= instantiate
			self.actualDeserializable	= actualDeserializable
		}
	}
	
	// TODO: Use stored property when Swift allows it
	struct Static
	{
		static var deserializables = [String:Deserializable]()
		static var initialized = false
	}
	
	public class func initialize()
	{
		if !Static.initialized
		{
			LGDeserializer.registerDeserializable(LGAnimatable)
			LGDeserializer.registerDeserializable(LGPhysicsBody)
			LGDeserializer.registerDeserializable(LGSprite)
			
			Static.initialized = true
		}
	}
	
	public class func registerDeserializable<T: LGDeserializable>(deserializable: T.Type)
	{
		// TODO: Don't be so ridiculous when Swift doesn't require it...
		Static.deserializables[deserializable.type()] = Deserializable(
			requiredProps: deserializable.requiredProps,
			optionalProps: deserializable.optionalProps,
			instantiate: deserializable.instantiate(),
			actualDeserializable: deserializable
		)
	}
	
	public class func deserialize(serialized: String, withType type: String) -> LGComponent?
	{
		initialize()
		
		if let deserializable = Static.deserializables[type]
		{
			if let json = LGJSON.JSONFromString(serialized)
			{
				let component = deserializable.instantiate()
				
				for prop in deserializable.requiredProps
				{
					if let val = json[prop]
					{
						if component.setProp(prop, val: val)
						{
							continue
						}
					}
					
					// if json[prop] == nil || !component(prop, val: val)
					return nil
				}
				
				for prop in deserializable.optionalProps
				{
					if let val = json[prop]
					{
						component.setProp(prop, val: val)
					}
				}
				
				return component
			}
		}
		
		return nil
	}
}
