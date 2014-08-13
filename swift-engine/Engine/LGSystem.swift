//
//  LGSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public class LGSystem
{
	public final var entities	= [LGEntity]()
	public var updatePhase		= LGUpdatePhase.Main
	
	public var scene: LGScene!
	
	public init() {}
	
	public func accepts(entity: LGEntity) -> Bool
	{
		return false
	}
	
	public func add(entity: LGEntity)
	{
		entities.append(entity)
	}
	
	public func remove(entity: LGEntity)
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
	
	public func remove(index: Int)
	{
		entities.removeAtIndex(index)
	}
	
	public func initialize() {}
	public func update() {}
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
