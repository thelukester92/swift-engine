//
//  LGSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

class LGSystem
{
	final var entities	= [LGEntity]()
	var updatePhase		= LGUpdatePhase.Main
	
	func accepts(entity: LGEntity) -> Bool
	{
		return false
	}
	
	func add(entity: LGEntity)
	{
		entities += entity
	}
	
	func remove(entity: LGEntity)
	{
		for i in 0 ..< entities.count
		{
			if entities[i] === entity
			{
				remove(i)
				break
			}
		}
	}
	
	func remove(index: Int)
	{
		entities.removeAtIndex(index)
	}
	
	func update() {}
}

extension LGSystem: LGEntityObserver
{
	func added(entity: LGEntity)
	{
		if accepts(entity)
		{
			add(entity)
		}
	}
	
	func removed(entity: LGEntity)
	{
		remove(entity)
	}
	
	func changed(entity: LGEntity)
	{
		var contained = false
		
		for i in 0 ..< entities.count
		{
			if entities[i] === entity
			{
				contained = true
				
				if !accepts(entity)
				{
					// No longer a valid entity in this system; remove it
					remove(i)
				}
				
				break
			}
		}
		
		if !contained && accepts(entity)
		{
			// Now a valid entity in this system; add it
			add(entity)
		}
	}
}
