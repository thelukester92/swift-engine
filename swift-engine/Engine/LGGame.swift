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
	public final var sceneTypes = [String:LGScene.Type]()
	public var engine: LGEngine!
	public var currentScene: String!
	
	public func registerDeserializers() {}
	public func createScenes() {}
	
	public func addScene<T: LGScene>(sceneType: T.Type, named name: String)
	{
		if currentScene == nil
		{
			currentScene = name
		}
		
		sceneTypes[name] = sceneType
	}
	
	public func gotoScene(name: String)
	{
		if let sceneType = sceneTypes[name]
		{
			currentScene = name
			engine.gotoScene(sceneType(game: self))
		}
	}
	
	// MARK: UIViewController Overrides
	
	override public func viewDidLoad()
	{
		super.viewDidLoad()
		
		registerDeserializers()
		createScenes()
		
		engine = LGEngine(view: self.view as SKView)
		
		if currentScene != nil
		{
			gotoScene(currentScene)
		}
	}
	
	override public func loadView()
	{
		self.view = SKView(frame: UIScreen.mainScreen().bounds)
	}
	
	override public func shouldAutorotate() -> Bool
	{
		return true
	}
}
