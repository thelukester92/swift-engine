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
	
	convenience init(pos: Int, flipped: UInt32)
	{
		self.init(pos: pos)
		flippedHorizontal	= (flipped & FlippedHorizontalFlag) > 0
		flippedVertical		= (flipped & FlippedVerticalFlag) > 0
		flippedDiagonal		= (flipped & FlippedDiagonalFlag) > 0
	}
	
	convenience init(gid: UInt32)
	{
		self.init(pos: 0, flipped: gid)
		pos = Int(gid & ~(FlippedHorizontalFlag | FlippedVerticalFlag | FlippedDiagonalFlag))
	}
}
