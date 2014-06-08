//
//  LGPosition.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/7/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGPosition: LGComponent
{
	class func type() -> String
	{
		return "LGPosition"
	}
	
	func type() -> String
	{
		return LGPosition.type()
	}
	
	// node is required for SpriteKit integration
	var node: SKNode!
	
	var _x: Double
	var _y: Double
		
	var x: Double
	{
		get { if node { return Double(node.position.x) } else { return _x } }
		set { if node { node.position.x = CGFloat(newValue) } else { _x = newValue } }
	}
	
	var y: Double
	{
		get { if node { return Double(node.position.y) } else { return _y } }
		set { if node { node.position.y = CGFloat(newValue) } else { _y = newValue } }
	}
	
	init()
	{
		_x = 0
		_y = 0
	}
	
	convenience init(node: SKNode)
	{
		self.init()
		self.node = node
	}
	
	convenience init(x: Double, y: Double)
	{
		self.init()
		self._x = x
		self._y = y
	}
}