//
//  LGTile.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/24/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

class LGTile
{
	let FlippedHorizontalFlag	= UInt32(0x80000000)
	let FlippedVerticalFlag		= UInt32(0x40000000)
	let FlippedDiagonalFlag		= UInt32(0x20000000)
	
	var pos: Int
	var flippedHorizontal: Bool
	var flippedVertical: Bool
	var flippedDiagonal: Bool
	
	init(gid: UInt32)
	{
		pos					= Int(gid & ~(FlippedHorizontalFlag | FlippedVerticalFlag | FlippedDiagonalFlag))
		flippedHorizontal	= (gid & FlippedHorizontalFlag) > 0
		flippedVertical		= (gid & FlippedVerticalFlag) > 0
		flippedDiagonal		= (gid & FlippedDiagonalFlag) > 0
	}
	
	init(pos: Int, flippedHorizontal: Bool, flippedVertical: Bool, flippedDiagonal: Bool)
	{
		self.pos				= pos
		self.flippedHorizontal	= flippedHorizontal
		self.flippedVertical	= flippedVertical
		self.flippedDiagonal	= flippedDiagonal
	}
	
	convenience init(pos: Int)
	{
		self.init(pos: pos, flippedHorizontal: false, flippedVertical: false, flippedDiagonal: false)
	}
}