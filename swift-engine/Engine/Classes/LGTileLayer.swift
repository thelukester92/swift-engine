//
//  LGTileLayer.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/21/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

class LGTileLayer: LGSystem
{
	var opacity		= 1.0
	var renderLayer	= LGRenderLayer.Background
	
	var isVisible	= true
	var isCollision	= false
	
	var tileWidth: Int
	var tileHeight: Int
	
	var data		= [[LGTile]]()
	
	init(tileWidth: Int, tileHeight: Int)
	{
		self.tileWidth	= tileWidth
		self.tileHeight	= tileHeight
	}
	
	func tileAt(#row: Int, col: Int) -> LGTile?
	{
		if row >= 0 && row < data.count && col >= 0 && col < data[row].count
		{
			return data[row][col]
		}
		return nil
	}
	
	func collidesAt(#row: Int, col: Int) -> Bool
	{
		if isCollision
		{
			if let tile = tileAt(row: row, col: col)
			{
				return tile.pos != 0
			}
		}
		return true
	}
	
	func visibleAt(#row: Int, col: Int) -> Bool
	{
		if isVisible
		{
			if let tile = tileAt(row: row, col: col)
			{
				return tile.pos != 0
			}
		}
		return false
	}
}
