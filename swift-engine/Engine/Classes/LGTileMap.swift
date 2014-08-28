//
//  LGTileMap.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/21/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public class LGTileMap
{
	/// The width of the map in tiles.
	public var width: Int
	
	/// The height of the map in tiles.
	public var height: Int
	
	/// The width of a single tile in pixels.
	public var tileWidth: Int
	
	/// The height of a single tile in pixels.
	public var tileHeight: Int
	
	public var layers = [LGTileLayer]()
	public var spriteSheet: LGSpriteSheet!
	
	public init(width: Int, height: Int, tileWidth: Int, tileHeight: Int)
	{
		self.width			= width
		self.height			= height
		self.tileWidth		= tileWidth
		self.tileHeight		= tileHeight
	}
	
	public convenience init(spriteSheet: LGSpriteSheet, width: Int, height: Int, tileWidth: Int, tileHeight: Int)
	{
		self.init(width: width, height: height, tileWidth: tileWidth, tileHeight: tileHeight)
		self.spriteSheet = spriteSheet
	}
	
	public func add(layer: LGTileLayer)
	{
		layers.append(layer)
	}
}
