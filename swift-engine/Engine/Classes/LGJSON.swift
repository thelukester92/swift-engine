//
//  LGJSON.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/2/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import Foundation

public class LGJSON
{
	public class func JSONFromString(serialized: String) -> LGJSON?
	{
		if let data = serialized.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
		{
			if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
			{
				return LGJSON(value: json)
			}
		}
		
		return nil
	}
	
	var value: AnyObject?
	
	public var boolValue: Bool?
	{
		return (value as? NSNumber)?.boolValue
	}
	
	public var intValue: Int?
	{
		return (value as? NSNumber)?.integerValue
	}
	
	public var doubleValue: Double?
	{
		return (value as? NSNumber)?.doubleValue
	}
	
	public var stringValue: String?
	{
		return value as? String
	}
	
	public var arrayValue: NSArray?
	{
		return value as? NSArray
	}
	
	public var dictionaryValue: NSDictionary?
	{
		return value as? NSDictionary
	}
	
	public init(value: AnyObject? = nil)
	{
		self.value = value
	}
	
	public subscript(name: String) -> LGJSON?
	{
		if let newValue: AnyObject = dictionaryValue?[name]?
		{
			return LGJSON(value: newValue)
		}
		
		return nil
	}
	
	public subscript(index: Int) -> LGJSON?
	{
		if let newValue: AnyObject! = arrayValue?[index]
		{
			return LGJSON(value: newValue)
		}
		
		return nil
	}
}
