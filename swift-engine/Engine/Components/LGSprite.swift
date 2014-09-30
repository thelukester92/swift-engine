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
	
	public var frame		= 1
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
	
	public convenience init(textureName: String, rows: Int = 1, cols: Int = 1)
	{
		self.init(spriteType: SpriteType.Texture(name: textureName, rows: rows, cols: cols))
	}
	
	public convenience init(red: Double, green: Double, blue: Double, size: LGVector)
	{
		self.init(spriteType: SpriteType.Color(r: red, g: green, b: blue), size: size)
	}
	
	public convenience init(text: String, font: String? = nil, fontSize: Double? = nil)
	{
		self.init(spriteType: SpriteType.Text(text: text, font: font ?? "Menlo-Regular", fontSize: fontSize ?? 24))
	}
	
	public enum SpriteType
	{
		case Texture(name: String, rows: Int, cols: Int)
		case Color(r: Double, g: Double, b: Double)
		case Text(text: String, font: String, fontSize: Double)
	}
}

extension LGSprite: LGDeserializable
{
	public class var requiredProps: [String]
	{
		return []
	}
	
	public class var optionalProps: [String]
	{
		return [ "spriteType", "offset", "layer" ]
	}
	
	public class func instantiate() -> LGDeserializable
	{
		return LGSprite(red: 0, green: 0, blue: 1, size: LGVector(x: 32, y: 32))
	}
	
	public func setProp(prop: String, val: LGJSON) -> Bool
	{
		switch prop
		{
			case "spriteType":
				// Textured sprite
				
				let textureName	= val["textureName"]?.stringValue
				let rows		= val["rows"]?.intValue
				let cols		= val["cols"]?.intValue
				
				if textureName != nil && rows != nil && cols != nil
				{
					spriteType = .Texture(name: textureName!, rows: rows!, cols: cols!)
					return true
				}
				
				// Colored sprite
				
				let red		= val["red"]?.doubleValue
				let green	= val["green"]?.doubleValue
				let blue	= val["blue"]?.doubleValue
				
				let x		= val["size"]?["x"]?.doubleValue
				let y		= val["size"]?["y"]?.doubleValue
				
				if red != nil && green != nil && blue != nil && x != nil && y != nil
				{
					spriteType	= .Color(r: red!, g: green!, b: blue!)
					size.x		= x!
					size.y		= y!
					return true
				}
				
				// Text sprite
				
				let text		= val["text"]?.stringValue
				let font		= val["font"]?.stringValue
				let fontSize	= val["fontSize"]?.doubleValue
				
				if text != nil
				{
					spriteType = .Text(text: text!, font: font ?? "Menlo-Regular", fontSize: fontSize ?? 24)
					return true
				}
			
			case "offset":
				if let x = val["x"]?.doubleValue
				{
					offset.x = x
				}
				
				if let y = val["y"]?.doubleValue
				{
					offset.y = y
				}
				
				return true
			
			case "layer":
				layer = val.intValue!
				return true
			
			default:
				break
		}
		
		return false
	}
}
