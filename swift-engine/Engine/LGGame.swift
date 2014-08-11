//
//  LGGame.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/11/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGGame: UIViewController
{
	func createScene() -> LGScene
	{
		return LGScene(size: view.frame.size)
	}
	
	// MARK: UIViewController Overrides
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		let scene = createScene()
		
		let skview = self.view as SKView
		let engine = LGEngine(view: skview)
		
		engine.gotoScene(scene)
	}
	
	override func loadView()
	{
		self.view = SKView(frame: UIScreen.mainScreen().applicationFrame)
	}
	
	override func shouldAutorotate() -> Bool
	{
		return true
	}
}
