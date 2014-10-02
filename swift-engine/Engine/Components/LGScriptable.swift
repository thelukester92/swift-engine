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

extension LGScriptable: LGDeserializable
{
	public class var requiredProps: [String]
	{
		return []
	}
	
	public class var optionalProps: [String]
	{
		return []
	}
	
	public class func instantiate() -> LGDeserializable
	{
		return LGScriptable()
	}
	
	public func setValue(value: LGJSON, forKey key: String) -> Bool
	{
		switch key
		{
			case "nextEvent":
				if let val = value.stringValue
				{
					events.append(val)
				}
			
			default:
				return false
		}
		
		return true
	}
	
	public func valueForKey(key: String) -> LGJSON
	{
		return LGJSON(value: nil)
	}
}
