//
//  LGSpriteSheet.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

public class LGSpriteSheet
{
	var texture: SKTexture
	var textureName: String
	
	var width: Int
	var height: Int
	
	var rows: Int { return Int(texture.size().height) / height }
	var cols: Int { return Int(texture.size().width) / width }
	
	public init(textureName: String, frameWidth: Int, frameHeight: Int)
	{
		self.texture		= SKTexture(imageNamed: textureName)
		self.textureName	= textureName
		self.width			= frameWidth
		self.height			= frameHeight
	}
	
	public init(textureName: String, rows: Int, cols: Int)
	{
		self.texture		= SKTexture(imageNamed: textureName)
		self.textureName	= textureName
		self.width			= Int(texture.size().width) / cols
		self.height			= Int(texture.size().height) / rows
	}
	
	public func textureAt(#row: Int, col: Int) -> SKTexture?
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
		
		return SKTexture(rect: rect, inTexture: texture)
	}
	
	public func textureAtPosition(pos: Int) -> SKTexture?
	{
		return textureAt(row: (pos - 1) / cols, col: (pos - 1) % cols)
	}
}
