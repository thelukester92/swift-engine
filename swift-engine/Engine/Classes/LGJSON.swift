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
	public class func JSONFromData(data: NSData) -> LGJSON?
	{
		if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
		{
			return LGJSON(value: json)
		}
		
		return nil
	}
	
	public class func JSONFromString(serialized: String) -> LGJSON?
	{
		if let data = serialized.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
		{
			return JSONFromData(data)
		}
		
		return nil
	}
	
	public class func JSONFromFile(name: String) -> LGJSON?
	{
		if let data = NSData.dataWithContentsOfFile(NSBundle.mainBundle().pathForResource(name, ofType: "json")!, options: nil, error: nil)
		{
			return JSONFromData(data)
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
		return (value as? String) ?? NSString(data: NSJSONSerialization.dataWithJSONObject(value!, options: nil, error: nil)!, encoding: NSUTF8StringEncoding)
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

extension LGJSON: SequenceType
{
	// TODO: fix this... it's exc bad access
	public func generate() -> GeneratorOf<String>
	{
		let dict = dictionaryValue!.allKeys as [String]
		var i = 0
		
		return GeneratorOf<String>
		{
			return dict[i++]
		}
	}
}
