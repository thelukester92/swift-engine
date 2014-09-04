//
//  LGDeserializable.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/1/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public protocol LGDeserializable: class
{
	class func deserialize(serialized: String) -> LGComponent?
}
