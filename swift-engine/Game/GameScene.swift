//
//  GameScene.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/3/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class GameScene: LGScene
{
	var tileSystem: LGTileSystem!
	
	init(size: CGSize)
	{
		super.init(size: size)
	}
	
	override func didMoveToView(view: SKView)
	{
		tileSystem = LGTileSystem(scene: self)
		
		var physicsSystem = LGPhysicsSystem()
		
		self.add(
			LGRenderingSystem(scene: self),
			physicsSystem,
			tileSystem,
			PlayerInputSystem(scene: self)
		)
		
		let player = LGEntity()
		player.put(
			LGPosition(x: Double(CGRectGetMidX(self.frame)), y: Double(CGRectGetMidY(self.frame))),
			LGSprite(spriteSheet: LGSpriteSheet(textureName: "Player", rows: 1, cols: 9)),
			LGPhysicsBody(width: 20, height: 35),
			LGCamera(size: LGVector(x: 128, y: 128), offset: LGVector(x: -64, y: -64)),
			Player()
		)
		
		let sprite = player.get(LGSprite)!
		sprite.addState(LGSpriteState(position: 1), name: "idle")
		sprite.addState(LGSpriteState(start: 8, end: 9, loops: true), name: "walk")
		sprite.addState(LGSpriteState(position: 7), name: "fall")
		sprite.currentState = sprite.stateNamed("idle")
		sprite.offset.x = -12
		
		self.add(player)
		
		let block = LGEntity()
		block.put(
			LGPosition(x: 60, y: 60),
			LGSprite(spriteSheet: LGSpriteSheet(textureName: "Player", rows: 1, cols: 9)),
			LGPhysicsBody(width: 20, height: 35)
		)
		block.get(LGSprite)!.position = 1
		self.add(block)
		self.test = block
		
		self.player = player
		
		let parser = LGTMXParser()
		let map = parser.parseFile("Level")
		
		physicsSystem.collisionLayer = parser.collisionLayer
		tileSystem.loadMap(map)
	}
	
	// TODO: The following logic should go in a separate system that acts as a delegate for receiving inputs and updating player sprites. It's only here temporarily due to convenience of development.
	
	var player: LGEntity?
	var test: LGEntity?
	
	var something = 0
	var somethingElse = 500
	
	override func update(currentTime: NSTimeInterval)
	{
		super.update(currentTime)
		
		let body = player!.get(LGPhysicsBody)!
		let sprite = player!.get(LGSprite)!
		
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
		
		if ++something > somethingElse
		{
			if let block = test
			{
				println("removing here")
				remove(block)
				test = nil
			}
		}
	}
}