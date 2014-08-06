//
//  LGSpriteState.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/21/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

class LGSpriteState
{
	var start: Int
	var end: Int
	var position: Int
	var loops: Bool
	var duration: Int
	var counter: Int = 0
	
	var isAnimated: Bool
	{
		return end > start
	}
	
	init(start: Int, end: Int, loops: Bool, duration: Int)
	{
		self.start		= start
		self.end		= end
		self.position	= start
		self.loops		= loops
		self.duration	= duration
	}
	
	convenience init(start: Int, end: Int, duration: Int)
	{
		self.init(start: start, end: end, loops: false, duration: duration)
	}
	
	convenience init(start: Int, end: Int, loops: Bool)
	{
		self.init(start: start, end: end, loops: loops, duration: 5)
	}
	
	convenience init(start: Int, end: Int)
	{
		self.init(start: start, end: end, loops: false)
	}
	
	convenience init(position: Int)
	{
		self.init(start: position, end: position)
	}
}
