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
		// TODO: Create sprite from string
		
		let message = LGEntity(
			LGPosition(x: Double(scene.view.frame.size.width / 2 - 100), y: Double(scene.view.frame.size.height / 2)),
			LGSprite(red: 0, green: 0.5, blue: 0.8, size: LGVector(x: 200, y: 30))
		)
		
		scene.addEntity(message)
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
