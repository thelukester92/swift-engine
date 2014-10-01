//
//  LGDeserializable.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/1/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

// TODO: remove @objc when Swift allows protocol checking
@objc public protocol LGDeserializable: LGComponent
{
	class var requiredProps: [String] { get }
	class var optionalProps: [String] { get }
	
	class func instantiate() -> LGDeserializable
	
	func setValue(value: LGJSON, forKey key: String) -> Bool
	func valueForKey(key: String) -> LGJSON
}
