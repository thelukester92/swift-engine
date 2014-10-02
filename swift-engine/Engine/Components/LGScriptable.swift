//
//  LGScriptable.swift
//  swift-engine
//
//  Created by Luke Godfrey on 10/2/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGScriptable: LGComponent
{
	public class func type() -> String
	{
		return "LGScriptable"
	}
	
	public func type() -> String
	{
		return LGScriptable.type()
	}
	
	public var scripts = [String:String]()
	public var events = [String]()
	
	public init() {}
}
