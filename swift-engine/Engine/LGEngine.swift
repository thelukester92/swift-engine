//
//  LGEngine.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

public final class LGEngine
{
	var view: SKView
	var currentScene: LGScene!
	
	public init(view: SKView)
	{
		self.view = view
		
		// view.showsFPS = true
		// view.showsNodeCount = true
		view.ignoresSiblingOrder = true
		
		// TODO: Remove this
		LGLuaBridge.sharedBridge()
	}
	
	public func gotoScene(scene: LGScene)
	{
		currentScene = scene
		
		scene.scene.scaleMode = .AspectFill
		view.presentScene(scene.scene)
		
		scene.initialize()
		scene.update()
	}
}
