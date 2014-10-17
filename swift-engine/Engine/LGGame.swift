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
	public typealias SceneGenerator = () -> LGScene
	public final var sceneGenerators = [String:SceneGenerator]()
	
	public var currentScene: LGScene!
	public var currentSceneName: String!
	
	public func registerDeserializers() {}
	public func createScenes() {}
	
	public func addScene(generator: @autoclosure () -> LGScene, named name: String)
	{
		if currentSceneName == nil
		{
			currentSceneName = name
		}
		
		sceneGenerators[name] = generator
	}
	
	public func gotoScene(name: String)
	{
		if let generator = sceneGenerators[name]
		{
			currentSceneName = name
			currentScene = generator()
			
			currentScene.scene.scaleMode = .AspectFill
			(self.view as SKView).presentScene(currentScene.scene)
			
			currentScene.initialize()
			currentScene.update()
		}
	}
	
	// MARK: UIViewController Overrides
	
	override public func viewDidLoad()
	{
		super.viewDidLoad()
		
		registerDeserializers()
		createScenes()
		
		if currentSceneName != nil
		{
			gotoScene(currentSceneName)
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