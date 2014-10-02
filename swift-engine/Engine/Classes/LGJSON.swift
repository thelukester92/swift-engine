//
//  LGJSON.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/2/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import Foundation

// TODO: remove @objc when Swift allows protocol checking
@objc public class LGJSON: NSObject
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
	
	public var value: AnyObject?
	
	public var isNil: Bool
	{
		return value == nil
	}
	
	public var numberValue: NSNumber?
	{
		return value as? NSNumber
	}
	
	public var boolValue: Bool?
	{
		return numberValue?.boolValue
	}
	
	public var intValue: Int?
	{
		return numberValue?.integerValue
	}
	
	public var doubleValue: Double?
	{
		return numberValue?.doubleValue
	}
	
	public var stringValue: String?
	{
		if arrayValue != nil || dictionaryValue != nil
		{
			return NSString(data: NSJSONSerialization.dataWithJSONObject(value!, options: nil, error: nil)!, encoding: NSUTF8StringEncoding)
		}
		
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
	
	public init(value: AnyObject?)
	{
		self.value = value
	}
	
	override public convenience init()
	{
		self.init(value: nil)
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
	public func generate() -> GeneratorOf<(String, LGJSON)>
	{
		let keys = dictionaryValue != nil ? dictionaryValue!.allKeys as [String] : [String]()
		var i = 0
		
		return GeneratorOf<(String, LGJSON)>
		{
			if i < keys.count
			{
				return (keys[i], LGJSON(value: self.dictionaryValue![keys[i++]]))
			}
			
			return .None
		}
	}
}
