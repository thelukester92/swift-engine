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
			LGSpriteSystem(scene: self),
			physicsSystem,
			tileSystem
		)
		
		let player = LGEntity()
		player.put(
			LGPosition(x: Double(CGRectGetMidX(self.frame)), y: Double(CGRectGetMidY(self.frame))),
			LGSprite(spriteSheet: LGSpriteSheet(textureName: "Player", rows: 1, cols: 9)),
			LGPhysicsBody(width: 20, height: 35)
		)
		
		let sprite = player.get(LGSprite)!
		sprite.addState(LGSpriteState(position: 1), name: "idle")
		sprite.addState(LGSpriteState(start: 8, end: 9, loops: true), name: "walk")
		sprite.addState(LGSpriteState(position: 7), name: "fall")
		
		sprite.currentState = sprite.stateNamed("walk")
		
		self.add(player)
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
		
		var collisionlayer = LGTileLayer()
		collisionlayer.isCollision = true
		collisionlayer.data = collisionStates
		
		map.add(layer)
		// map.add(collisionlayer)
		
		physicsSystem.collisionLayer = collisionlayer
		
		tileSystem.loadMap(map)
	}
	
	var player: LGEntity?
	
	override func update(currentTime: NSTimeInterval)
	{
		super.update(currentTime)
		
		// TODO: This logic should go in a separate system for managing player animation states
		//       Putting it here breaks the ECS paradigm, but it simplifies development while testing things out
		
		if let entity = player
		{
			let body = entity.get(LGPhysicsBody)!
			let sprite = entity.get(LGSprite)!
			
			if false // if(abs(body.skphysicsbody.velocity.dy) > 0)
			{
				// sprite.currentState = sprite.stateNamed("fall")
			}
			else
			{
				sprite.currentState = sprite.stateNamed("idle")
			}
		}
		
		
	}
	
	override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
	{
		// TODO: This logic should go in a separate system that acts as a delegate for receiving these inputs
		//       Putting it here breaks the ECS paradigm, but it simplifies development while testing things out
		
		if let body = player?.get(LGPhysicsBody)
		{
			if let touch = touches.anyObject() as? UITouch
			{
				if touch.locationInView(self.view).x > self.view.frame.size.width / 2
				{
					body.velocity.x += 1
				}
				else
				{
					body.velocity.x += -1
				}
			}
			
			body.velocity.y = 10
		}
	}
}