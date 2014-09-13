//
//  MenuInputSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/13/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import UIKit
import LGSwiftEngine

class MenuInputSystem: LGSystem
{
	override func initialize()
	{
		let position	= LGPosition()
		let sprite		= LGSprite(text: "Tap to Begin")
		
		let message = LGEntity(position, sprite)
		scene.addEntity(message)
		
		position.x = Double(scene.view.frame.size.width / 2) - sprite.size.x / 2
		position.y = Double(scene.view.frame.size.height / 2) - sprite.size.y / 2
	}
}

extension MenuInputSystem: LGTouchObserver
{
	func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
	{
		
	}
	
	func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
	{
		
	}
	
	func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)
	{
		scene.game.gotoScene("game")
	}
}
