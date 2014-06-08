//
//  LGSprite.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGSprite: LGComponent
{
	class func type() -> String
	{
		return "LGSprite"
	}
	
	func type() -> String
	{
		return LGSprite.type()
	}
	
	// node is required for SpriteKit integration
	var node: SKSpriteNode!
	
	var spriteSheet: LGSpriteSheet?
	var states = Dictionary<String, SpriteState>()
	var currentState: SpriteState?
	
	init() {}
	
	convenience init(spriteSheet: LGSpriteSheet)
	{
		self.init()
		self.spriteSheet = spriteSheet
	}
	
	convenience init(image: String)
	{
		self.init()
		self.spriteSheet = LGSpriteSheet(texture: SKTexture(imageNamed: image), rows: 1, cols: 1)
	}
	
	func addState(state: SpriteState, name: String)
	{
		states[name] = state
	}
	
	func stateNamed(name: String) -> SpriteState?
	{
		return states[name]
	}
	
	class SpriteState
	{
		var start: Int
		var end: Int
		var position: Int
		var loops: Bool
		var duration: Int
		var counter: Int = 0
		
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
}