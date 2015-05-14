//
//  LGSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public class LGSystem: LGEntityManager
{
	public final var entities	= [LGEntity]()
	public final var observers	= [LGEntityObserver]()
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
		for observer in observers
		{
			observer.added(self, id: entities.count - 1)
		}
	}
	
	public func remove(entity: LGEntity)
	{
		for i in 0 ..< entities.count
		{
			if entities[i] == entity
			{
				remove(i)
				break
			}
		}
	}
	
	public func remove(index: Int)
	{
		entities.removeAtIndex(index)
		for observer in observers
		{
			observer.removed(self, id: index)
		}
	}
	
	public func change(entity: LGEntity)
	{
		for i in 0 ..< entities.count
		{
			if entities[i] == entity
			{
				change(i)
				break
			}
		}
	}
	
	public func change(index: Int)
	{
		for observer in observers
		{
			observer.changed(self, id: index)
		}
	}
	
	public func initialize() {}
	public func update() {}
}

extension LGSystem: LGEntityObserver
{
	public func added(manager: LGEntityManager, id: Int)
	{
		if accepts(manager.entities[id])
		{
			add(manager.entities[id])
		}
	}
	
	public func removed(manager: LGEntityManager, id: Int)
	{
		remove(manager.entities[id])
	}
	
	public func changed(manager: LGEntityManager, id: Int)
	{
		var contained = false
		
		for i in 0 ..< entities.count
		{
			if entities[i] == manager.entities[id]
			{
				contained = true
				
				if !accepts(manager.entities[id])
				{
					// No longer a valid entity in this system; remove it
					remove(i)
				}
				else
				{
					// Alert the system that this entity changed
					change(i)
				}
				
				break
			}
		}
		
		if !contained && accepts(manager.entities[id])
		{
			// Now a valid entity in this system; add it
			add(manager.entities[id])
		}
	}
}
