//
//  LGSound.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/27/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public class LGSound: LGComponent
{
	public class func type() -> String
	{
		return "LGSound"
	}
	
	public func type() -> String
	{
		return LGSound.type()
	}
	
	var name: String
	
	public init(name: String)
	{
		self.name = name
	}
}
