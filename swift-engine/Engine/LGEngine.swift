//
//  LGEngine.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

class LGEngine
{
	var view: SKView
	var currentScene: LGScene!
	
	init(view: SKView)
	{
		self.view = view
		
		view.showsFPS = true
		view.showsNodeCount = true
		view.ignoresSiblingOrder = true
	}
	
	func gotoScene(scene: LGScene)
	{
		currentScene = scene
		
		scene.scaleMode = .AspectFill
		view.presentScene(scene)
		
		// Tick once before rendering
		scene.update(0)
	}
}
