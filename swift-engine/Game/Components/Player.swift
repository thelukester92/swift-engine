//
//  Player.swift
//  swift-engine
//
//  Created by Luke Godfrey on 7/28/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

class Player: LGComponent
{
	class func type() -> String
	{
		return "Player"
	}
	
	func type() -> String
	{
		return Player.type()
	}
	
	var jumpSpeed: Double = 4
	var moveSpeed: Double = 1
}