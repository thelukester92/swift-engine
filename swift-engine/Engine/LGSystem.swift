//
//  LGSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

class LGSystem
{
	var entities	= LGEntity[]()
	var updatePhase	= LGUpdatePhase.First
	var priority	= 100
	
	func accepts(entity: LGEntity) -> Bool
	{
		return false
	}
	
	func add(entity: LGEntity)
	{
		entities += entity
	}
	
	func check(entity: LGEntity)
	{
		if accepts(entity)
		{
			add(entity)
		}
	}
	
	func remove(entity: LGEntity)
	{
		// TODO: implement more efficient remove
		
		for i in 0..entities.count
		{
			if entities[i] === entity
			{
				entities.removeAtIndex(i)
				break
			}
		}
	}
	
	func update() {}
}