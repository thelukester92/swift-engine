//
//  PlayerInputSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 7/28/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import UIKit
import LGSwiftEngine

class PlayerInputSystem: LGSystem
{
	var player: Player!
	var body: LGPhysicsBody!
	
	var shouldJump = false
	var shouldMove = 0.0
	
	override init()
	{
		super.init()
		self.updatePhase = .Input
	}
	
	override func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(Player) && entity.has(LGPhysicsBody)
	}
	
	override func add(entity: LGEntity)
	{
		super.add(entity)
		
		player	= entity.get(Player)
		body	= entity.get(LGPhysicsBody)
	}
	
	override func update()
	{
		if shouldJump
		{
			body.velocity.y = player.jumpSpeed
			shouldJump = false
		}
		
		body.velocity.x = shouldMove * player.moveSpeed
	}
}

extension PlayerInputSystem: LGTouchObserver
{
	func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
	{
		if event.allTouches()!.count == 2
		{
			shouldJump = true
		}
		else if let touch = touches.anyObject() as? UITouch
		{
			if touch.locationInView(scene.view).x > scene.view.frame.size.width / 2
			{
				shouldMove = 1
			}
			else
			{
				shouldMove = -1
			}
		}
	}
	
	func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
	{
		
	}
	
	func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)
	{
		if event.allTouches()!.count - touches.count == 0
		{
			shouldMove = 0
		}
	}
}
