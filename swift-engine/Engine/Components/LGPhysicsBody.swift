//
//  LGPhysicsBody.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

public final class LGPhysicsBody: LGComponent
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
	
	public func resetCollided()
	{
		collidedTop		= false
		collidedBottom	= false
		collidedLeft	= false
		collidedRight	= false
	}
}

extension LGPhysicsBody: LGDeserializable
{
	public class func deserialize(serialized: String) -> LGComponent?
	{
		if let json = LGJSON.JSONFromString(serialized)
		{
			let width	= json["width"]?.doubleValue
			let height	= json["height"]?.doubleValue
			
			if width != nil && height != nil
			{
				let body = LGPhysicsBody(width: width!, height: height!)
				
				if let dynamic = json["dynamic"]?.boolValue
				{
					body.dynamic = dynamic
				}
				
				if let onlyCollidesOnTop = json["onlyCollidesOnTop"]?.boolValue
				{
					body.onlyCollidesOnTop = onlyCollidesOnTop
				}
				
				if let velocity = json["velocity"]
				{
					if let x = velocity["x"]?.doubleValue
					{
						body.velocity.x = x
					}
					
					if let y = velocity["y"]?.doubleValue
					{
						body.velocity.y = y
					}
				}
				
				return body
			}
		}
		
		return nil
	}
}
