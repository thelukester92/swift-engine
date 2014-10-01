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
	
	public var onCollision: ((LGEntity, LGEntity?) -> ())?
	public var onCollisionStart: ((LGEntity, LGEntity) -> ())?
	public var onCollisionEnd: ((LGEntity, LGEntity) -> ())?
	
	public var trigger = false
	
	// TODO: allow other kinds of directional collisions
	public var onlyCollidesOnTop = false
	
	public var collidedTop		= false
	public var collidedBottom	= false
	public var collidedLeft		= false
	public var collidedRight	= false
	public var collidedWith		= [Int:LGEntity]()
	
	public init(width: Double, height: Double, dynamic: Bool = true)
	{
		self.width		= width
		self.height		= height
		self.dynamic	= dynamic
	}
	
	public convenience init(size: LGVector, dynamic: Bool = true)
	{
		self.init(width: size.x, height: size.y, dynamic: dynamic)
	}
	
	public convenience init()
	{
		self.init(width: 0, height: 0)
	}
}

extension LGPhysicsBody: LGDeserializable
{
	public class var requiredProps: [String]
	{
		return [ "width", "height" ]
	}
	
	public class var optionalProps: [String]
	{
		return [ "dynamic", "onlyCollidesOnTop", "trigger", "velocity" ]
	}
	
	public class func instantiate() -> LGDeserializable
	{
		return LGPhysicsBody()
	}
	
	public func setValue(value: LGJSON, forKey key: String) -> Bool
	{
		switch key
		{
			case "width":
				width = value.doubleValue!
				return true
			
			case "height":
				height = value.doubleValue!
				return true
			
			case "dynamic":
				dynamic = value.boolValue!
				return true
			
			case "onlyCollidesOnTop":
				onlyCollidesOnTop = value.boolValue!
				return true
			
			case "trigger":
				trigger = value.boolValue!
				return true
			
			case "velocity":
				if let x = value["x"]?.doubleValue
				{
					velocity.x = x
				}
				
				if let y = value["y"]?.doubleValue
				{
					velocity.y = y
				}
				
				return true
			
			default:
				break
		}
		
		return false
	}
	
	public func valueForKey(key: String) -> LGJSON
	{
		return LGJSON(value: nil)
	}
}
