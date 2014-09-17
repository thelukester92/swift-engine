//
//  GameScene.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/13/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import LGSwiftEngine

class GameScene: LGScene
{
	override func initialize()
	{
		let physicsSystem	= LGPhysicsSystem()
		let tileSystem		= LGTileSystem()
		
		addSystems(
			physicsSystem,
			tileSystem,
			LGRenderingSystem(),
			LGCameraSystem(),
			LGAnimationSystem(),
			PlayerInputSystem(),
			PlayerOutputSystem(),
			PlatformSystem()
		)
		
		let parser = LGTMXParser(filename: "Level")
		parser.addMapToTileSystem(tileSystem)
		parser.addCollisionLayerToPhysicsSystem(physicsSystem)
		parser.addObjectsToScene(self)
		
		// Add scene entities (always the same in every level in this scene)
		
		if let player = entityNamed("player")
		{
			let width			= Double(self.view.frame.size.width)
			let height			= Double(self.view.frame.size.height)
			
			let camera			= LGCamera()
			camera.boundary		= LGRect(x: 0, y: 0, width: Double(parser.map.width * parser.map.tileWidth), height: Double(parser.map.height * parser.map.tileHeight))
			
			let cameraBody		= LGPhysicsBody(width: width, height: height, dynamic: false)
			cameraBody.trigger	= true
			
			let cameraOffset	= LGVector(x: -width / 2, y: -height / 2)
			let cameraFollower	= LGFollower(following: player, axis: .Both, followerType: .Position(cameraOffset))
			
			addEntity( LGEntity(camera, cameraBody, cameraFollower, LGPosition()) )
		}
	}
}
