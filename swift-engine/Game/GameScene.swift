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
			Player()
		)
		
		let block = LGEntity()
		block.put(
			LGPosition(x: Double(CGRectGetMidX(self.frame)), y: Double(CGRectGetMidY(self.frame) + 50)),
			LGSprite(),
			LGPhysicsBody(width: 20, height: 35)
		)
		
		let sprite = player.get(LGSprite)!
		sprite.addState(LGSpriteState(position: 1), name: "idle")
		sprite.addState(LGSpriteState(start: 8, end: 9, loops: true), name: "walk")
		sprite.addState(LGSpriteState(position: 7), name: "fall")
		sprite.currentState = sprite.stateNamed("idle")
		sprite.offset.x = -12
		
		self.add(player, block)
		self.player = player
		
		let WIDTH = 15
		let HEIGHT = 9
		
		let spriteSheet = LGSpriteSheet(textureName: "Tileset", rows: 3, cols: 6)
		let map = LGTileMap(spriteSheet: spriteSheet, width: WIDTH, height: HEIGHT, tileWidth: 32, tileHeight: 32)
		
		var states = [[LGTile]]()
		var collisionStates = [[LGTile]]()
		
		let layerdata = [
			17,13,13,13,13,13,13,13,17,17,17,17,17,17,17,
			17,0,0,0,0,14,0,0,17,17,17,17,17,17,17,
			13,0,0,0,0,0,0,0,13,13,13,13,13,13,13,
			0,0,0,0,0,0,0,0,0,15,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		]
		
		for i in 0 ..< HEIGHT
		{
			states += [LGTile]()
			collisionStates += [LGTile]()
			
			for j in 0 ..< WIDTH
			{
				let gid = UInt32(layerdata[i * WIDTH + j])
				
				states[i] += LGTile(gid: gid)
				collisionStates[i] += LGTile(gid: (gid > 0 && gid != 15 && gid != 14 ? 1 : 0))
			}
		}
		
		var layer = LGTileLayer()
		layer.data = states
		map.add(layer)
		
		var collisionlayer = LGTileLayer()
		collisionlayer.isCollision = true
		collisionlayer.tilesize = 32
		collisionlayer.data = collisionStates
		
		physicsSystem.collisionLayer = collisionlayer
		
		tileSystem.loadMap(map)
	}
	
	// TODO: The following logic should go in a separate system that acts as a delegate for receiving inputs and updating player sprites. It's only here temporarily due to convenience of development.
	
	var player: LGEntity?
	
	var useless = 50
	let maxUseless = 50
	
	override func update(currentTime: NSTimeInterval)
	{
		/* uncomment this section to make frames go slowly for debugging
		if ++useless > maxUseless
		{
			useless = 0
		}
		else
		{
			return
		} */
		
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
	}
}
