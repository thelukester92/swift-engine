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
		super.add(entity)
		
		player		= entity.get(Player)
		sprite		= entity.get(LGSprite)
		body		= entity.get(LGPhysicsBody)
		animatable	= entity.get(LGAnimatable)
	}
	
	override func update()
	{
		if body.velocity.y != 0
		{
			animatable.gotoAnimation("fall")
		}
		else if body.velocity.x != 0
		{
			animatable.gotoAnimation("walk")
		}
		else
		{
			animatable.gotoAnimation("idle")
		}
		
		if body.velocity.x != 0
		{
			sprite.scale.x = body.velocity.x > 0 ? 1 : -1
		}
	}
}
