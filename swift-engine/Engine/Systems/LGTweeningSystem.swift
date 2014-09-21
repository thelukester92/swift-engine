//
//  LGTweeningSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/20/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import Foundation

public final class LGTweeningSystem: LGSystem
{
	var positions	= [LGPosition]()
	var tweenables	= [LGTweenable]()
	
	public override func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGPosition) && entity.has(LGTweenable)
	}
	
	public override func add(entity: LGEntity)
	{
		super.add(entity)
		
		positions.append(entity.get(LGPosition)!)
		tweenables.append(entity.get(LGTweenable)!)
	}
	
	public override func remove(index: Int)
	{
		super.remove(index)
		
		positions.removeAtIndex(index)
		tweenables.removeAtIndex(index)
	}
	
	public override func update()
	{
		for id in 0 ..< entities.count
		{
			let position = positions[id]
			let tweenable = tweenables[id]
			
			if tweenable.isNew
			{
				tweenable.original = LGVector(x: position.x, y: position.y)
				tweenable.time = 0
				tweenable.isNew = false
			}
			
			if tweenable.target != nil
			{
				if tweenable.time < tweenable.duration
				{
					let delta = LGVector(x: tweenable.target!.x - tweenable.original.x, y: tweenable.target!.y - tweenable.original.y)
					
					switch tweenable.easing
					{
						case .Linear:
							position.x += delta.x / tweenable.duration
							position.y += delta.y / tweenable.duration
						
						case .EaseIn:
							let value	= tweenable.time / tweenable.duration
							position.x	= tweenable.original.x + delta.x * value * value * value
							position.y	= tweenable.original.y + delta.y * value * value * value
						
						case .EaseOut:
							let value	= tweenable.time / tweenable.duration - 1
							position.x	= tweenable.original.x + delta.x * (value * value * value + 1)
							position.y	= tweenable.original.y + delta.y * (value * value * value + 1)
						
						case .EaseInOut:
							var value = 2 * tweenable.time / tweenable.duration
							if value < 1
							{
								position.x = tweenable.original.x + delta.x / 2 * value * value * value
								position.y = tweenable.original.y + delta.y / 2 * value * value * value
							}
							else
							{
								value -= 2
								position.x = tweenable.original.x + delta.x / 2 * (value * value * value + 2)
								position.y = tweenable.original.y + delta.y / 2 * (value * value * value + 2)
							}
					}
					
					tweenable.time++
				}
				else
				{
					position.x = tweenable.target!.x
					position.y = tweenable.target!.y
				}
			}
		}
	}
}
