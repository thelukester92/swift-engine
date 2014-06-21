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
	override func didMoveToView(view: SKView)
	{
		self.add(
			LGNodeSystem(scene: self),
			LGSpriteSystem(),
			LGPositionSystem(),
			LGPhysicalSystem()
		)
		
		let player = LGEntity()
		player.put(
			LGPosition(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)),
			LGSprite(spriteSheet: LGSpriteSheet(textureName: "Player", rows: 1, cols: 9)),
			LGNode(sprite: true),
			LGPhysicsBody(skphysicsbody: SKPhysicsBody(rectangleOfSize: CGSize(width: 100, height: 100)))
		)
		
		let floor = LGEntity()
		floor.put(
			LGPosition(x: 0, y: 50),
			LGNode(),
			LGPhysicsBody(skphysicsbody: SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50)))
		)
		
		let sprite = player.get(LGSprite.type()) as LGSprite
		sprite.addState(LGSpriteState(position: 1), name: "idle")
		sprite.addState(LGSpriteState(start: 8, end: 9, loops: true), name: "walk")
		sprite.addState(LGSpriteState(position: 7), name: "fall")
		
		sprite.currentState = sprite.stateNamed("walk")
		
		self.add(player, floor)
		self.player = player
	}
	
	var player: LGEntity?
	
	override func update(currentTime: NSTimeInterval)
	{
		super.update(currentTime)
		
		// TODO: This logic should go in a separate system for managing player animation states
		//       Putting it here breaks the ECS paradigm, but it simplifies development while testing things out
		
		if let entity = player
		{
			let body = entity.get(LGPhysicsBody.type()) as LGPhysicsBody
			let node = entity.get(LGNode.type()) as LGNode
			let sprite = entity.get(LGSprite.type()) as LGSprite
			
			if(fabs(body.skphysicsbody.velocity.dy) > 0)
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
		if let body = player?.get(LGPhysicsBody.type()) as? LGPhysicsBody
		{
			body.skphysicsbody.applyImpulse(CGVectorMake(0, 250))
		}
	}
}