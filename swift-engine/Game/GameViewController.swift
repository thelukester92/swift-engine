//
//  GameViewController.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/3/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController
{
	func initialize()
	{
		let scene = createGameScene()
		
		let skview = self.view as SKView
		let engine = LGEngine(view: skview)
		
		engine.gotoScene(scene)
	}
	
	func createGameScene() -> LGScene
	{
		let scene = LGScene(size: self.view.frame.size)
		
		let physicsSystem = LGPhysicsSystem()
		let tileSystem = LGTileSystem(scene: scene)
		
		scene.addSystems(
			LGRenderingSystem(scene: scene),
			LGCameraSystem(scene: scene),
			LGAnimationSystem(),
			physicsSystem,
			tileSystem,
			PlayerInputSystem(scene: scene),
			PlayerOutputSystem(),
			PlatformSystem(scene: scene)
		)
		
		let platform = LGEntity()
		platform.put(
			LGPosition(x: 100, y: 100),
			LGSprite(textureName: "Tileset", rows: 3, cols: 6),
			LGPhysicsBody(width: 32, height: 32)
		)
		platform.get(LGSprite)!.frame = 13
//		platform.get(LGPhysicsBody)!.dynamic = false
		platform.get(LGPhysicsBody)!.onlyCollidesOnTop = true
		platform.get(LGPhysicsBody)!.velocity.x = 1.0
		scene.addEntity(platform, named: "platform")
		
		let player = LGEntity()
		player.put(
			LGPosition(x: 50, y: 200),
			LGPhysicsBody(width: 20, height: 35),
			LGCamera(size: LGVector(x: Double(self.view.frame.size.width), y: Double(self.view.frame.size.height)), offset: LGVector(x: -Double(self.view.frame.size.width / 2), y: -Double(self.view.frame.size.height / 2))),
			Player()
		)
		
		let animatable = LGAnimatable(animations:
			[
				"idle":		LGAnimation(frame: 1),
				"walk":		LGAnimation(start: 8, end: 9, loops: true),
				"fall":		LGAnimation(frame: 7),
			])
		animatable.gotoAnimation("idle")
		player.put(animatable)
		
		let sprite = LGSprite(textureName: "Player", rows: 1, cols: 9)
		sprite.offset.x = -12
		player.put(sprite)
		
		scene.addEntity(player, named: "player")
		
		let parser = LGTMXParser()
		let map = parser.parseFile("Level")
		
		physicsSystem.collisionLayer = parser.collisionLayer
		tileSystem.loadMap(map)
		
		return scene
	}
	
	// MARK: UIViewController Overrides
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		initialize()
	}
	
	override func loadView()
	{
		self.view = SKView(frame: UIScreen.mainScreen().applicationFrame)
	}
	
    override func shouldAutorotate() -> Bool
	{
		return true
	}
	
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