//
//  LGCamera.swift
//  swift-engine
//
//  Created by Luke Godfrey on 7/31/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGCamera: LGComponent
{
	public class func type() -> String
	{
		return "LGCamera"
	}
	
	public func type() -> String
	{
		return LGCamera.type()
	}
	
	var offset = LGVector()
	var size: LGVector
	
	public init(size: LGVector)
	{
		self.size = size
	}
	
	public convenience init(size: LGVector, offset: LGVector)
	{
		self.init(size: size)
		self.offset = offset
	}
}
