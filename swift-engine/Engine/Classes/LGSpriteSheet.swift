//
//  LGSpriteSheet.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGSpriteSheet
{
	var texture: SKTexture
	var width: Int			// width of a single frame
	var height: Int			// height of a single frame
	
	var rows: Int { return Int(texture.size().height) / height }
	var cols: Int { return Int(texture.size().width) / width }
	
	init(texture: SKTexture, frameWidth: Int, frameHeight: Int)
	{
		self.texture	= texture
		self.width		= frameWidth
		self.height		= frameHeight
	}
	
	init(texture: SKTexture, rows: Int, cols: Int)
	{
		self.texture	= texture
		self.width		= Int(texture.size().width) / cols
		self.height		= Int(texture.size().height) / rows
	}
	
	convenience init(textureName: String, frameWidth: Int, frameHeight: Int)
	{
		self.init(texture: SKTexture(imageNamed: textureName), frameWidth: frameWidth, frameHeight: frameHeight)
	}
	
	convenience init(textureName: String, rows: Int, cols: Int)
	{
		self.init(texture: SKTexture(imageNamed: textureName), rows: rows, cols: cols)
	}
	
	func textureAt(#row: Int, col: Int) -> SKTexture?
	{
		if row < 0 || col < 0
		{
			return nil
		}
		
		let rect = CGRect(
			x: CGFloat(col * width) / texture.size().width,
			y: CGFloat((rows - row - 1) * height) / texture.size().height,
			width: CGFloat(width) / texture.size().width,
			height: CGFloat(height) / texture.size().height
		)
		
		// rows - row - 1 so that coordinates are inverted to make more sense
		
		return SKTexture(rect: rect, inTexture: texture)
	}
	
	func textureAtPosition(pos: Int) -> SKTexture?
	{
		return textureAt(row: (pos - 1) / cols, col: (pos - 1) % cols)
	}
}
