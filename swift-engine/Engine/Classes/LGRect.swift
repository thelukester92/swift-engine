//
//  LGRect.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/28/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGRect
{
	public var origin	= LGVector()
	public var size		= LGVector()
	
	public var x: Double
	{
		get { return origin.x }
		set { origin.x = newValue }
	}
	
	public var y: Double
	{
		get { return origin.y }
		set { origin.y = newValue }
	}
	
	public var width: Double
	{
		get { return size.x }
		set { size.x = newValue }
	}
	
	public var height: Double
	{
		get { return size.y }
		set { size.y = newValue }
	}
	
	public var extremeX: Double
	{
		return origin.x + size.x
	}
	
	public var extremeY: Double
	{
		return origin.y + size.y
	}
	
	public init() {}
	
	public convenience init(x: Double, y: Double, width: Double, height: Double)
	{
		self.init()
		
		self.x		= x
		self.y		= y
		self.width	= width
		self.height	= height
	}
}
