//
//  LGDeserializer.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/4/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public class LGDeserializer
{
	var deserializers: [String:(String) -> LGComponent?]
	
	public init()
	{
		deserializers = [:]
	}
	
	public func registerDeserializable<T: protocol<LGComponent, LGDeserializable>>(deserializable: T.Type)
	{
		deserializers[deserializable.type()] = { serialized in deserializable.deserialize(serialized) }
	}
	
	public func deserialize(serialized: String, withType type: String) -> LGComponent?
	{
		if let deserializer = deserializers[type]
		{
			return deserializer(serialized)
		}
		
		return nil
	}
}
