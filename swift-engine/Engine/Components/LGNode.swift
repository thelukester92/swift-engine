//
//  LGNode.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGNode: LGComponent
{
	class func type() -> String
	{
		return "LGNode"
	}
	
	func type() -> String
	{
		return LGNode.type()
	}
	
	var sknode: SKNode
	
	init(sknode: SKNode)
	{
		self.sknode = sknode
	}
}