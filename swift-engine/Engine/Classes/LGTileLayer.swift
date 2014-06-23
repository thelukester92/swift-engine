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
	var zOrder		= 0
	var offsetX		= 0
	var offsetY		= 0
	
	var isVisible	= true
	var isCollision	= false
	
	var data		= LGSpriteState[][]()
	
	func spriteStateAt(#row: Int, col: Int) -> LGSpriteState?
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
			if let sprite = spriteStateAt(row: row, col: col)
			{
				return sprite.start == 0 && sprite.end == 0
			}
		}
		return true
	}
}