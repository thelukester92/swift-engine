//
//  LGScene.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGScene: SKScene
{
	var systems			= [LGSystem]()
	var systemsByPhase	= [LGUpdatePhase: [LGSystem]]()
	var entities		= [LGEntity]()
	var removed			= [LGEntity]()
	
	init(size: CGSize)
	{
		super.init(size: size)
	}
	
	func add(entitiesToAdd: LGEntity...)
	{
		for entity in entitiesToAdd
		{
			entities += entity
			
			for system in systems
			{
				if system.accepts(entity)
				{
					system.added(entity)
				}
			}
		}
	}
	
	func remove(entity: LGEntity)
	{
		removed += entity
	}
	
	func processRemovedEntities()
	{
		for entity in removed
		{
			for i in 0 ..< entities.count
			{
				if entities[i] === entity
				{
					entities.removeAtIndex(i)
					break
				}
			}
			
			for system in systems
			{
				system.removed(entity)
			}
		}
		removed = []
	}
	
	func add(systemsToAdd: LGSystem...)
	{
		for system in systemsToAdd
		{
			systems += system
			
			if var phase = systemsByPhase[system.updatePhase]
			{
				phase.append(system)
				systemsByPhase[system.updatePhase] = phase
			}
			else
			{
				systemsByPhase[system.updatePhase] = [system]
			}
			
			for entity in entities
			{
				if system.accepts(entity)
				{
					system.added(entity)
				}
			}
		}
	}
	
	func remove(system: LGSystem)
	{
		for i in 0 ..< systems.count
		{
			if systems[i] === system
			{
				systems.removeAtIndex(i)
				break
			}
		}
		
		for i in 0 ..< systemsByPhase[system.updatePhase]!.count
		{
			var phase: [LGSystem] = systemsByPhase[system.updatePhase]!

			if phase[i] === system
			{
				phase.removeAtIndex(i)
				systemsByPhase[system.updatePhase] = phase
				break
			}
		}
	}
	
	func updateSystemsByPhase(phase: LGUpdatePhase)
	{
		if let systemsToUpdate = systemsByPhase[phase]
		{
			for system in systemsToUpdate
			{
				system.update()
			}
		}
	}
	
	override func update(currentTime: NSTimeInterval)
	{
		updateSystemsByPhase(.Input)
		updateSystemsByPhase(.Physics)
		updateSystemsByPhase(.Main)
		updateSystemsByPhase(.Render)
	}
}