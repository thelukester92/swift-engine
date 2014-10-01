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
				var pos = LGVector(x: position.x, y: position.y)
				
				if tweenable.time < tweenable.duration
				{
					let delta = LGVector(x: tweenable.target!.x - tweenable.original.x, y: tweenable.target!.y - tweenable.original.y)
					
					switch tweenable.easing
					{
						case .Linear:
							pos.x += delta.x / tweenable.duration
							pos.y += delta.y / tweenable.duration
						
						case .EaseIn:
							let value	= tweenable.time / tweenable.duration
							pos.x		= tweenable.original.x + delta.x * value * value * value
							pos.y		= tweenable.original.y + delta.y * value * value * value
						
						case .EaseOut:
							let value	= tweenable.time / tweenable.duration - 1
							pos.x		= tweenable.original.x + delta.x * (value * value * value + 1)
							pos.y		= tweenable.original.y + delta.y * (value * value * value + 1)
						
						case .EaseInOut:
							var value = 2 * tweenable.time / tweenable.duration
							if value < 1
							{
								pos.x = tweenable.original.x + delta.x / 2 * value * value * value
								pos.y = tweenable.original.y + delta.y / 2 * value * value * value
							}
							else
							{
								value -= 2
								pos.x = tweenable.original.x + delta.x / 2 * (value * value * value + 2)
								pos.y = tweenable.original.y + delta.y / 2 * (value * value * value + 2)
							}
					}
					
					tweenable.time++
				}
				else
				{
					pos.x = tweenable.target!.x
					pos.y = tweenable.target!.y
				}
				
				if tweenable.axis == LGAxis.X || tweenable.axis == LGAxis.Both
				{
					position.x = pos.x
				}
				
				if tweenable.axis == LGAxis.Y || tweenable.axis == LGAxis.Both
				{
					position.y = pos.y
				}
			}
		}
	}
}
