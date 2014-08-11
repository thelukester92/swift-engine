//
//  LGVector.swift
//  swift-engine
//
//  Created by Luke Godfrey on 7/14/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGVector
{
	public var x = 0.0
	public var y = 0.0
	
	public init() {}
	
	public convenience init(x: Double, y: Double)
	{
		self.init()
		self.x = x
		self.y = y
	}
	
	public convenience init(_ value: Double)
	{
		self.init()
		self.x = value
		self.y = value
	}
}

public prefix func - (vector: LGVector) -> LGVector
{
	return LGVector(x: -vector.x, y: -vector.y)
}

public func + (left: LGVector, right: LGVector) -> LGVector
{
	return LGVector(x: left.x + right.x, y: left.y + right.y)
}

public func - (left: LGVector, right: LGVector) -> LGVector
{
	return LGVector(x: left.x - right.x, y: left.y - right.y)
}

public func += (inout left: LGVector, right: LGVector)
{
	left = left + right
}
