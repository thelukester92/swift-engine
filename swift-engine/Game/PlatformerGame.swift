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
	var physicsSystem: LGPhysicsSystem!
	var tileSystem: LGTileSystem!
	
	override func addSystems(scene: LGScene)
	{
		physicsSystem = LGPhysicsSystem()
		tileSystem = LGTileSystem()
		
		scene.addSystems(
			LGRenderingSystem(),
			LGCameraSystem(),
			LGAnimationSystem(),
			physicsSystem,
			tileSystem,
			PlayerInputSystem(),
			PlayerOutputSystem(),
			PlatformSystem()
		)
	}
	
	override func addEntities(scene: LGScene)
	{
		let platform = LGEntity(
			LGPosition(x: 100, y: 100),
			LGSprite(red: 0, green: 0, blue: 1, size: LGVector(x: 32, y: 32)),
			LGPhysicsBody(width: 32, height: 32)
		)
		platform.get(LGPhysicsBody)!.onlyCollidesOnTop = true
		platform.get(LGPhysicsBody)!.velocity.x = 1.0
		scene.addEntity(platform, named: "platform")
		
		let player = LGEntity(
			LGPosition(x: 50, y: 200),
			LGPhysicsBody(width: 20, height: 35),
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
		
		let width	= Double(self.view.frame.size.width)
		let height	= Double(self.view.frame.size.height)
		
		let camera		= LGCamera()
		camera.boundary	= LGRect(x: 0, y: 0, width: Double(map.width * map.tileWidth), height: Double(map.height * map.tileHeight))
		
		let cameraBody		= LGPhysicsBody(width: width, height: height, dynamic: false)
		cameraBody.trigger	= true
		
		let cameraOffset	= LGVector(x: -width / 2, y: -height / 2)
		let cameraFollower	= LGFollower(following: player, axis: .Both, followerType: .Position(cameraOffset))
		
		scene.addEntity( LGEntity(camera, cameraBody, cameraFollower, LGPosition()) )
		
		physicsSystem.collisionLayer = parser.collisionLayer
		tileSystem.loadMap(map)
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