//
//  LGTileMap.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/21/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

class LGTileMap
{
	var width: Int
	var height: Int
	var tileWidth: Int
	var tileHeight: Int
	
	var layers = LGTileLayer[]()
	var spriteSheet: LGSpriteSheet
	
	init(spriteSheet: LGSpriteSheet, width: Int, height: Int, tileWidth: Int, tileHeight: Int)
	{
		self.spriteSheet	= spriteSheet
		self.width			= width
		self.height			= height
		self.tileWidth		= tileWidth
		self.tileHeight		= tileHeight
	}
	
	func add(layer: LGTileLayer)
	{
		layers += layer
	}
}