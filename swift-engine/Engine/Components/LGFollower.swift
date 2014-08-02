//
//  LGFollower.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/2/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

class LGFollower: LGComponent
{
	class func type() -> String
	{
		return "LGFollower"
	}
	
	func type() -> String
	{
		return LGFollower.type()
	}
	
	weak var following: LGEntity?
	var axis: LGAxis
	
	init(following: LGEntity, axis: LGAxis)
	{
		self.following = following
		self.axis = axis
	}
	
	convenience init(following: LGEntity)
	{
		self.init(following: following, axis: .Both)
	}
}
