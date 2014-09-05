//
//  LGDeserializable.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/1/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public protocol LGDeserializable
{
	class func type() -> String
	class func deserialize(serialized: String) -> LGComponent?
}
