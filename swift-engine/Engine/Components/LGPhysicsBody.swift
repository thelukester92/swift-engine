//
//  LGPhysicsBody.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

public class LGPhysicsBody: LGComponent, LGDeserializable
{
	public class func type() -> String
	{
		return "LGPhysicsBody"
	}
	
	public func type() -> String
	{
		return LGPhysicsBody.type()
	}
	
	public var velocity	= LGVector()
	
	public var width: Double
	public var height: Double
	public var dynamic: Bool
	
	public var didCollide: ((LGEntity, LGEntity?) -> ())?
	public var trigger = false
	
	// TODO: allow other kinds of directional collisions
	public var onlyCollidesOnTop = false
	
	public var collidedTop		= false
	public var collidedBottom	= false
	public var collidedLeft		= false
	public var collidedRight	= false
	
	public init(width: Double = 0, height: Double = 0, dynamic: Bool = true)
	{
		self.width		= width
		self.height		= height
		self.dynamic	= dynamic
	}
	
	public convenience init(size: LGVector)
	{
		self.init(width: size.x, height: size.y)
	}
	
	required public convenience init(serialized: String)
	{
		self.init()
		
		println("Attempting to deserialize...")
		
		if let data = serialized.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
		{
			println("Got data. Getting JSON...")
			
			var err: NSError?
			
			if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? NSDictionary
			{
				if let value = json["width"] as? NSNumber
				{
					width = value.doubleValue
				}
				
				if let value = json["height"] as? NSNumber
				{
					height = value.doubleValue
				}
				
				if let value = json["dynamic"] as? NSNumber
				{
					dynamic = value.boolValue
				}
				
				println("deserialized \(width) and \(height) and \(dynamic)")
			}
			
			if let error = err
			{
				println("error: \(error.description)")
			}
		}
	}
	
	public func resetCollided()
	{
		collidedTop		= false
		collidedBottom	= false
		collidedLeft	= false
		collidedRight	= false
	}
}
