//
//  LGDeserializable.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/1/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public protocol LGDeserializable
{
	typealias DeserializableType
	class func deserialize(serialized: String) -> DeserializableType?
}