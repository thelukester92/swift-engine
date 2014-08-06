//
//  LGTMXObject.swift
//  swift-engine
//
//  Created by Luke Godfrey on 7/31/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

class LGTMXObject
{
	var x: Int
	var y: Int
	var properties = [String:String]()
	
	var name: String!
	var type: String!
	var width: Int!
	var height: Int!
	
	init(x: Int, y: Int)
	{
		self.x = x
		self.y = y
	}
}
