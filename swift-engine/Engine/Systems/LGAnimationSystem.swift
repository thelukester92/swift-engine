//
//  LGAnimationSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/8/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGAnimationSystem: LGSystem
{
	public enum Event: String
	{
		case AnimationEnd = "animationEnd"
	}
	
	var sprites		= [LGSprite]()
	var animatables	= [LGAnimatable]()
	var animations	= [LGAnimation?]()
	
	public override init() {}
	
	override public func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGSprite) && entity.has(LGAnimatable)
	}
	
	override public func add(entity: LGEntity)
	{
		super.add(entity)
		
		let sprite		= entity.get(LGSprite)!
		let animatable	= entity.get(LGAnimatable)!
		
		sprites.append(sprite)
		animatables.append(animatable)
		animations.append(nil)
	}
	
	override public func remove(index: Int)
	{
		super.remove(index)
		
		sprites.removeAtIndex(index)
		animatables.removeAtIndex(index)
		animations.removeAtIndex(index)
	}
	
	override public func update()
	{
		for id in 0 ..< entities.count
		{
			let sprite		= sprites[id]
			let animatable	= animatables[id]
			
			if let animation = animatable.currentAnimation
			{
				if animations[id] == nil || animations[id]! != animation
				{
					animations[id] = animation
					sprite.frame = animation.start
					animatable.counter = 0
				}
				
				if animation.end > animation.start
				{
					if ++animatable.counter > animation.ticksPerFrame
					{
						animatable.counter = 0
						
						if ++sprite.frame > animation.end
						{
							if animation.loops
							{
								sprite.frame = animation.start
							}
							else
							{
								sprite.frame = animation.end
							}
							
							if let scriptable = entities[id].get(LGScriptable)
							{
								scriptable.events.append(LGScriptable.Event(name: Event.AnimationEnd.toRaw()))
							}
						}
					}
				}
			}
		}
	}
}
