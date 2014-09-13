//
//  GameViewController.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/3/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import UIKit
import LGSwiftEngine

class PlatformerGame: LGGame
{
	override func registerDeserializers()
	{
		LGDeserializer.registerDeserializable(Player)
	}
	
	override func createScenes()
	{
		addScene(MenuScene.self, named: "menu")
		addScene(GameScene.self, named: "game")
	}
	
	// MARK: UIViewController Overrides
	
	override func supportedInterfaceOrientations() -> Int
	{
		if UIDevice.currentDevice().userInterfaceIdiom == .Phone
		{
			return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
		}
		else
		{
			return Int(UIInterfaceOrientationMask.All.toRaw())
		}
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
	}
}