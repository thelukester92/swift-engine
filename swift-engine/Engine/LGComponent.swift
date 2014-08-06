//
//  LGComponent.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

protocol LGComponent
{
	// In real life, only class func type() is needed... but dynamicType.type() doesn't work yet
	class func type() -> String
	func type() -> String
}
