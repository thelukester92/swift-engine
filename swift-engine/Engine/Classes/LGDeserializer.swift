//
//  LGDeserializer.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/4/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public class LGDeserializer
{
	typealias Deserializer = (String) -> LGComponent?
	
	// TODO: Use stored property when Swift allows it
	struct Static
	{
		static var deserializers = [String:Deserializer]()
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
		Static.deserializers[deserializable.type()] = { serialized in deserializable.deserialize(serialized) }
	}
	
	public class func deserialize(serialized: String, withType type: String) -> LGComponent?
	{
		initialize()
		
		if let deserializer = Static.deserializers[type]
		{
			return deserializer(serialized)
		}
		
		return nil
	}
}
