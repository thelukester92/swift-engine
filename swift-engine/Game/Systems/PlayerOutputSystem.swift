//
//  PlayerOutputSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/11/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import LGSwiftEngine

class PlayerOutputSystem: LGSystem
{
	var entity: LGEntity!
	var player: Player!
	var sprite: LGSprite!
	var body: LGPhysicsBody!
	var animatable: LGAnimatable!
	
	override func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(Player) && entity.has(LGSprite) && entity.has(LGPhysicsBody)
	}
	
	override func add(entity: LGEntity)
	{
		self.entity	= entity
		player		= entity.get(Player)
		sprite		= entity.get(LGSprite)
		body		= entity.get(LGPhysicsBody)
		animatable	= entity.get(LGAnimatable)
	}
	
	override func update()
	{
		let vel = body.velocity
		
		if let follower = entity.get(LGFollower)
		{
			if let followingBody = follower.following?.get(LGPhysicsBody)
			{
				switch follower.followerType
				{
					case .Velocity(let lastVelocity):
						vel.x -= lastVelocity.x
						vel.y -= lastVelocity.y
					
					case .Position:
						break
				}
			}
		}
		
		if vel.y != 0
		{
			animatable.gotoAnimation("fall")
		}
		else if vel.x != 0
		{
			animatable.gotoAnimation("walk")
		}
		else
		{
			animatable.gotoAnimation("idle")
		}
		
		if vel.x != 0
		{
			sprite.scale.x = vel.x > 0 ? 1 : -1
		}
	}
}
