//
//  LGDeserializable.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/1/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public protocol LGDeserializable: LGComponent, LGScriptable
{
	class var requiredProps: [String] { get }
	class var optionalProps: [String] { get }
	
	class func instantiate() -> LGDeserializable
}
