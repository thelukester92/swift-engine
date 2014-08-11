//
//  LGSpriteKitScene.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/11/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

class LGSpriteKitScene: SKScene
{
	var touchObservers	= [LGTouchObserver]()
	var updateObservers	= [LGUpdatable]()
	
	override func update(currentTime: NSTimeInterval)
	{
		for updateObserver in updateObservers
		{
			updateObserver.update()
		}
	}
	
	override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
	{
		for touchObserver in touchObservers
		{
			touchObserver.touchesBegan(touches, withEvent: event)
		}
	}
	
	override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
	{
		for touchObserver in touchObservers
		{
			touchObserver.touchesMoved(touches, withEvent: event)
		}
	}
	
	override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)
	{
		for touchObserver in touchObservers
		{
			touchObserver.touchesEnded(touches, withEvent: event)
		}
	}
}
