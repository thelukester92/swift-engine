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
		LGDeserializer.registerDeserializable(LGPhysicsBody)
		LGDeserializer.registerDeserializable(LGAnimatable)
		LGDeserializer.registerDeserializable(LGSprite)
		LGDeserializer.registerDeserializable(Player)
		
		let platform = LGEntity(
			LGPosition(x: 100, y: 100),
			LGSprite(red: 0, green: 0, blue: 1, size: LGVector(x: 32, y: 32)),
			LGPhysicsBody(width: 32, height: 32)
		)
		platform.get(LGPhysicsBody)!.onlyCollidesOnTop = true
		platform.get(LGPhysicsBody)!.velocity.x = 1.0
		scene.addEntity(platform, named: "platform")
		
		let parser = LGTMXParser()
		let map = parser.parseFile("Level")
		
		let width	= Double(self.view.frame.size.width)
		let height	= Double(self.view.frame.size.height)
		
		for object in parser.objects
		{
			let entity = LGEntity( LGPosition(x: Double(object.x), y: Double(map.height * map.tileHeight) - Double(object.y)) )
			
			for (type, serialized) in object.properties
			{
				if let component = LGDeserializer.deserialize(serialized, withType: type)
				{
					entity.put(component: component)
				}
			}
			
			scene.addEntity(entity, named: object.name)
		}
		
		if let player = scene.entityNamed("player")
		{
			let camera			= LGCamera()
			camera.boundary		= LGRect(x: 0, y: 0, width: Double(map.width * map.tileWidth), height: Double(map.height * map.tileHeight))
			
			let cameraBody		= LGPhysicsBody(width: width, height: height, dynamic: false)
			cameraBody.trigger	= true
			
			let cameraOffset	= LGVector(x: -width / 2, y: -height / 2)
			let cameraFollower	= LGFollower(following: player, axis: .Both, followerType: .Position(cameraOffset))
			
			scene.addEntity( LGEntity(camera, cameraBody, cameraFollower, LGPosition()) )
		}
		
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