//
//  LGGame.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/11/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

public class LGGame: UIViewController
{
	public final func createScene() -> LGScene
	{
		let scene = LGScene(size: view.frame.size)
		
		addSystems(scene)
		addEntities(scene)
		
		return scene
	}
	
	public func addSystems(scene: LGScene) {}
	public func addEntities(scene: LGScene) {}
	
	// MARK: UIViewController Overrides
	
	override public func viewDidLoad()
	{
		super.viewDidLoad()
		
		let scene = createScene()
		
		let skview = self.view as SKView
		let engine = LGEngine(view: skview)
		
		engine.gotoScene(scene)
	}
	
	override public func loadView()
	{
		self.view = SKView(frame: UIScreen.mainScreen().applicationFrame)
	}
	
	override public func shouldAutorotate() -> Bool
	{
		return true
	}
}
