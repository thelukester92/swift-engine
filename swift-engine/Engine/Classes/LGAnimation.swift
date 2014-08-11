//
//  LGAnimation.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/8/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

class LGAnimation: Equatable
{
	var start: Int
	var end: Int
	var loops: Bool
	var ticksPerFrame: Int
	
	init(start: Int, end: Int, loops: Bool, ticksPerFrame: Int)
	{
		self.start			= start
		self.end			= end
		self.loops			= loops
		self.ticksPerFrame	= ticksPerFrame
	}
	
	convenience init(start: Int, end: Int, loops: Bool)
	{
		self.init(start: start, end: end, loops: loops, ticksPerFrame: 5)
	}
	
	convenience init(start: Int, end: Int)
	{
		self.init(start: start, end: end, loops: false)
	}
	
	convenience init(frame: Int)
	{
		self.init(start: frame, end: frame)
	}
}

func == (lhs: LGAnimation, rhs: LGAnimation) -> Bool
{
	return lhs.start == rhs.start && lhs.end == rhs.end && lhs.loops == rhs.loops && lhs.ticksPerFrame == rhs.ticksPerFrame
}
