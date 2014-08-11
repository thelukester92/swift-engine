//
//  LGSprite.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

final class LGSprite: LGComponent
{
	typealias Texture = (name: String, rows: Int, cols: Int)
	typealias Color = (red: Double, green: Double, blue: Double)
	
	class func type() -> String
	{
		return "LGSprite"
	}
	
	func type() -> String
	{
		return LGSprite.type()
	}
	
	var texture: Texture?
	var color: Color?
	
	var size: LGVector
	
	var frame		= 0
	var scale		= LGVector(1.0)
	var offset		= LGVector()
	var opacity		= 1.0
	var rotation	= 0.0
	var layer		= 0
	var isVisible	= true
	
	init(textureName: String, rows: Int = 1, cols: Int = 1)
	{
		self.texture = (name: textureName, rows: rows, cols: cols)
		self.size = LGVector()
	}
	
	init(red: Double, green: Double, blue: Double, size: LGVector)
	{
		self.color = (red: red, green: green, blue: blue)
		self.size = size
	}
}
