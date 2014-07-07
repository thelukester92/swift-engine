//
//  LGTileLayer.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/21/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

class LGTileLayer: LGSystem
{
	var opacity		= 100.0
	var offsetX		= 0
	var offsetY		= 0
	var renderLayer	= LGRenderLayer.Background
	
	var isVisible	= true
	var isCollision	= false
	
	var data		= LGTile[][]()
	
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
		return false
	}
}