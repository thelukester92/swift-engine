//
//  LGTMXObject.swift
//  swift-engine
//
//  Created by Luke Godfrey on 7/31/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public class LGTMXObject
{
	public var x: Int
	public var y: Int
	public var properties = [String:String]()
	
	public var name: String!
	public var type: String!
	public var width: Int!
	public var height: Int!
	
	public init(x: Int, y: Int)
	{
		self.x = x
		self.y = y
	}
}
