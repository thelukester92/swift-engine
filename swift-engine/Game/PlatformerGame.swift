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
		// Registering for deserialization is needed because Swift has no instrospection or reflection
		
		LGDeserializer.registerDeserializable(LGAnimatable)
		LGDeserializer.registerDeserializable(LGPhysicsBody)
		LGDeserializer.registerDeserializable(LGSprite)
		LGDeserializer.registerDeserializable(Player)
		
		let parser = LGTMXParser()
		let (map, objects) = parser.parseFile("Level")
		
		// Add level entities (may change each level)
		
		for object in objects
		{
			let entity = LGEntity( LGPosition(x: Double(object.x), y: Double(map.height * map.tileHeight) - Double(object.y)) )
			
			var properties = [String:String]()
			
			// Properties from the EntityType template
			if object.type != nil
			{
				if let json = LGJSON.JSONFromFile(object.type)
				{
					if let dictionary = json.dictionaryValue
					{
						for key in dictionary.allKeys as [String]
						{
							properties[key] = json[key]?.stringValue
						}
					}
				}
			}
			
			// Properties unique to the entity
			for (key, val) in object.properties
			{
				properties[key] = val
			}
			
			// Deserialize the properties
			for (type, serialized) in properties
			{
				if let component = LGDeserializer.deserialize(serialized, withType: type)
				{
					entity.put(component: component)
				}
				else
				{
					println("WARNING: Failed to deserialize a component of type '\(type)'")
				}
			}
			
			scene.addEntity(entity, named: object.name)
		}
		
		// Add scene entities (always the same in every level in this scene)
		
		if let player = scene.entityNamed("player")
		{
			let width			= Double(self.view.frame.size.width)
			let height			= Double(self.view.frame.size.height)
			
			let camera			= LGCamera()
			camera.boundary		= LGRect(x: 0, y: 0, width: Double(map.width * map.tileWidth), height: Double(map.height * map.tileHeight))
			
			let cameraBody		= LGPhysicsBody(width: width, height: height, dynamic: false)
			cameraBody.trigger	= true
			
			let cameraOffset		= LGVector(x: -width / 2, y: -height / 2)
			let cameraFollower		= LGFollower(following: player, axis: .Both, followerType: .Position(cameraOffset))
			
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