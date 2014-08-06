//
//  GameScene.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/3/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

class GameScene: LGScene
{
	var tileSystem: LGTileSystem!
	
	override func didMoveToView(view: SKView)
	{
		tileSystem = LGTileSystem(scene: self)
		
		var physicsSystem = LGPhysicsSystem()
		
		self.addSystems(
			LGRenderingSystem(scene: self),
			LGCameraSystem(scene: self),
			physicsSystem,
			tileSystem,
			PlayerInputSystem(scene: self)
		)
		
		let platform = LGEntity()
		platform.put(
			LGPosition(x: 100, y: 100),
			LGSprite(spriteSheet: LGSpriteSheet(textureName: "Tileset", rows: 3, cols: 6)),
			LGPhysicsBody(width: 32, height: 32)
		)
		platform.get(LGSprite)!.position = 13
//		platform.get(LGPhysicsBody)!.dynamic = false
		platform.get(LGPhysicsBody)!.onlyCollidesOnTop = true
		platform.get(LGPhysicsBody)!.velocity.x = 1.0
		self.addEntity(platform, named: "platform")
		
		let player = LGEntity()
		player.put(
			LGPosition(x: 50, y: 200),
			LGSprite(spriteSheet: LGSpriteSheet(textureName: "Player", rows: 1, cols: 9)),
			LGPhysicsBody(width: 20, height: 35),
			LGCamera(size: LGVector(x: Double(self.view.frame.size.width), y: Double(self.view.frame.size.height)), offset: LGVector(x: -Double(self.view.frame.size.width / 2), y: -Double(self.view.frame.size.height / 2))),
			Player()
		)
		
		let sprite = player.get(LGSprite)!
		sprite.addState(LGSpriteState(position: 1), name: "idle")
		sprite.addState(LGSpriteState(start: 8, end: 9, loops: true), name: "walk")
		sprite.addState(LGSpriteState(position: 7), name: "fall")
		sprite.currentState = sprite.stateNamed("idle")
		sprite.offset.x = -12
		
		self.addEntity(player, named: "player")
		
		let parser = LGTMXParser()
		let map = parser.parseFile("Level")
		
		physicsSystem.collisionLayer = parser.collisionLayer
		tileSystem.loadMap(map)
	}
	
	// TODO: The following logic should go in a separate system that acts as a delegate for receiving inputs and updating player sprites. It's only here temporarily due to convenience of development.
	
	override func update(currentTime: NSTimeInterval)
	{
		super.update(currentTime)
		
		let player = entityNamed("player")!
		let body = player.get(LGPhysicsBody)!
		let sprite = player.get(LGSprite)!
		
		if body.velocity.y != 0
		{
			sprite.currentState = sprite.stateNamed("fall")
		}
		else if body.velocity.x != 0
		{
			sprite.currentState = sprite.stateNamed("walk")
		}
		else
		{
			sprite.currentState = sprite.stateNamed("idle")
		}
		
		if body.velocity.x != 0
		{
			sprite.scale.x = body.velocity.x > 0 ? 1 : -1
		}
		
		let position = entityNamed("platform")!.get(LGPosition)!
		let bod = entityNamed("platform")!.get(LGPhysicsBody)!
		
		if bod.velocity.x == 0
		{
			bod.velocity.x = -1
		}
		
		if position.x + 32 > Double(self.view.frame.size.width) || position.x < 10
		{
			bod.velocity.x = -bod.velocity.x
		}
	}
}