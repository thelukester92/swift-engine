//
//  LGFollower.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/2/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public class LGFollower: LGComponent
{
	public class func type() -> String
	{
		return "LGFollower"
	}
	
	public func type() -> String
	{
		return LGFollower.type()
	}
	
	weak var following: LGEntity?
	var axis: LGAxis
	
	public init(following: LGEntity, axis: LGAxis)
	{
		self.following = following
		self.axis = axis
	}
	
	public convenience init(following: LGEntity)
	{
		self.init(following: following, axis: .Both)
	}
}
