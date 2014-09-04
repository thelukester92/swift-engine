//
//  LGSprite.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGSprite: LGComponent
{
	public typealias Texture = (name: String, rows: Int, cols: Int)
	public typealias Color = (red: Double, green: Double, blue: Double)
	
	public class func type() -> String
	{
		return "LGSprite"
	}
	
	public func type() -> String
	{
		return LGSprite.type()
	}
	
	public var texture: Texture?
	public var color: Color?
	
	public var size: LGVector
	
	public var frame		= 0
	public var scale		= LGVector(1.0)
	public var offset		= LGVector()
	public var opacity		= 1.0
	public var rotation		= 0.0
	public var layer		= 0
	public var isVisible	= true
	
	public init(textureName: String, rows: Int = 1, cols: Int = 1)
	{
		self.texture = (name: textureName, rows: rows, cols: cols)
		self.size = LGVector()
	}
	
	public init(red: Double, green: Double, blue: Double, size: LGVector)
	{
		self.color = (red: red, green: green, blue: blue)
		self.size = size
	}
}

extension LGSprite: LGDeserializable
{
	public class func deserialize(serialized: String) -> LGComponent?
	{
		if let json = LGJSON.JSONFromString(serialized)
		{
			let textureName	= json["textureName"]?.stringValue
			let rows		= json["rows"]?.intValue
			let cols		= json["cols"]?.intValue
			
			if textureName != nil && rows != nil && cols != nil
			{
				let sprite = LGSprite(textureName: textureName!, rows: rows!, cols: cols!)
				
				if let offset = json["offset"]
				{
					if let x = offset["x"]?.doubleValue
					{
						sprite.offset.x = x
					}
					
					if let y = offset["y"]?.doubleValue
					{
						sprite.offset.y = y
					}
				}
				
				return sprite
			}
		}
		
		return nil
	}
}
