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
	var states = [String:LGSpriteState]()
	var currentState: LGSpriteState?
	
	var offset		= LGVector()
	var scale		= LGVector(x: 1.0, y: 1.0)
	var rotation	= 0.0
	
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
	
	func addState(state: LGSpriteState, name: String)
	{
		states[name] = state
	}
	
	func stateNamed(name: String) -> LGSpriteState?
	{
		return states[name]
	}
}
