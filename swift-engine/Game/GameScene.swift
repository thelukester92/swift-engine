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
		
		self.add(
			LGSpriteSystem(),
			tileSystem
		)
		
		let player = LGEntity()
		player.put(
			LGPosition(x: Double(CGRectGetMidX(self.frame)), y: Double(CGRectGetMidY(self.frame))),
			LGSprite(spriteSheet: LGSpriteSheet(textureName: "Player", rows: 1, cols: 9)),
			LGPhysicsBody(skphysicsbody: SKPhysicsBody(rectangleOfSize: CGSize(width: 20, height: 35)))
		)
		
		let floor = LGEntity()
		floor.put(
			LGPosition(x: 0, y: 64),
			LGPhysicsBody(skphysicsbody: SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 32)))
		)
		
		let sprite = player.get(LGSprite)!
		sprite.addState(LGSpriteState(position: 1), name: "idle")
		sprite.addState(LGSpriteState(start: 8, end: 9, loops: true), name: "walk")
		sprite.addState(LGSpriteState(position: 7), name: "fall")
		
		sprite.currentState = sprite.stateNamed("walk")
		
		self.add(player, floor)
		self.player = player
		
		let spriteSheet = LGSpriteSheet(textureName: "Tileset", rows: 3, cols: 6)
		let map = LGTileMap(spriteSheet: spriteSheet, width: 20, height: 4, tileWidth: 32, tileHeight: 32)
		
		var states = LGTile[][]()
		let layerdata = [
			0,0,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,13,13,13,13,13,13,13,0,0,0,0,0,
			0,0,0,0,0,14,0,0,17,17,17,17,17,17,17,13,13,13,13,13,
			13,13,13,13,13,13,13,13,17,17,17,17,17,17,17,17,17,17,17,17
		]
		
		for i in 0..4
		{
			states += LGTile[]()
			
			for j in 0..20
			{
				states[i] += LGTile(gid: UInt32(layerdata[i * 20 + j]))
			}
		}
		
		var layer = LGTileLayer()
		layer.data = states
		
		map.add(layer)
		
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
			
			if(abs(body.skphysicsbody.velocity.dy) > 0)
			{
				sprite.currentState = sprite.stateNamed("fall")
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
			body.skphysicsbody.applyImpulse(CGVectorMake(0, 250))
		}
	}
}