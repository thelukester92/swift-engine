//
//  LGDeserializable.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/1/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

// TODO: Remove @objc ; it is only here so we can check for conformance
@objc public protocol LGDeserializable
{
	init(serialized: String)
}
