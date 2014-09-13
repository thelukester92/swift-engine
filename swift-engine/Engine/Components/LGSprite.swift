//
//  LGSprite.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGSprite: LGComponent
{
	public class func type() -> String
	{
		return "LGSprite"
	}
	
	public func type() -> String
	{
		return LGSprite.type()
	}
	
	public var spriteType: SpriteType
	public var size: LGVector
	
	public var frame		= 0
	public var scale		= LGVector(1.0)
	public var offset		= LGVector()
	public var opacity		= 1.0
	public var rotation		= 0.0
	public var layer		= 0
	public var isVisible	= true
	
	public init(spriteType: SpriteType, size: LGVector = LGVector())
	{
		self.spriteType	= spriteType
		self.size		= size
	}
	
	public convenience init(textureName: String, rows: Int, cols: Int)
	{
		self.init(spriteType: SpriteType.Texture(name: textureName, rows: rows, cols: cols))
	}
	
	public convenience init(red: Double, green: Double, blue: Double, size: LGVector)
	{
		self.init(spriteType: SpriteType.Color(r: red, g: green, b: blue), size: size)
	}
	
	public enum SpriteType
	{
		case Texture(name: String, rows: Int, cols: Int)
		case Color(r: Double, g: Double, b: Double)
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
			
			var sprite: LGSprite?
			
			if textureName != nil && rows != nil && cols != nil
			{
				sprite = LGSprite(textureName: textureName!, rows: rows!, cols: cols!)
			}
			else
			{
				let red		= json["red"]?.doubleValue
				let blue	= json["blue"]?.doubleValue
				let green	= json["green"]?.doubleValue
				
				let size	= json["size"]
				let x		= size?["x"]?.doubleValue
				let y		= size?["y"]?.doubleValue
				
				if red != nil && blue != nil && green != nil && x != nil && y != nil
				{
					let vector = LGVector(x: x!, y: y!)
					sprite = LGSprite(red: red!, green: green!, blue: blue!, size: vector)
				}
			}
			
			if sprite != nil
			{
				if let offset = json["offset"]
				{
					if let x = offset["x"]?.doubleValue
					{
						sprite!.offset.x = x
					}
					
					if let y = offset["y"]?.doubleValue
					{
						sprite!.offset.y = y
					}
				}
				
				return sprite
			}
		}
		
		return nil
	}
}
