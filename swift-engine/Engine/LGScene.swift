//
//  LGScene.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import UIKit
import SpriteKit

class LGScene: SKScene
{
	var systems			= LGSystem[]()
	var systemsByPhase	= Dictionary<LGUpdatePhase, LGSystem[]>()
	var entities		= LGEntity[]()
	
	func add(entitiesToAdd: LGEntity...)
	{
		for entity in entitiesToAdd
		{
			entities += entity
			
			for system in systems
			{
				if system.accepts(entity)
				{
					system.add(entity)
				}
			}
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
		
		for system in systems
		{
			system.remove(entity)
		}
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
					system.add(entity)
				}
			}
		}
	}
	
	func remove(system: LGSystem)
	{
		// TODO: implement more efficient remove
		
		for i in 0..systems.count
		{
			if systems[i] === system
			{
				systems.removeAtIndex(i)
				break
			}
		}
		
		for i in 0..systemsByPhase[system.updatePhase]!.count
		{
			var phase: LGSystem[] = systemsByPhase[system.updatePhase]!

			if phase[i] === system
			{
				phase.removeAtIndex(i)
				systemsByPhase[system.updatePhase] = phase
				break
			}
		}
	}
	
	func updateSystems(systemsToUpdate: LGSystem[])
	{
		for system in systemsToUpdate
		{
			system.update()
		}
	}
	
	override func update(currentTime: NSTimeInterval)
	{
		if let systemsToUpdate = systemsByPhase[.First]
		{
			updateSystems(systemsToUpdate)
		}
	}
	
	override func didEvaluateActions()
	{
		if let systemsToUpdate = systemsByPhase[.AfterActions]
		{
			updateSystems(systemsToUpdate)
		}
	}
	
	override func didSimulatePhysics()
	{
		if let systemsToUpdate = systemsByPhase[.AfterPhysics]
		{
			updateSystems(systemsToUpdate)
		}
		
		if let systemsToUpdate = systemsByPhase[.Last]
		{
			updateSystems(systemsToUpdate)
		}
	}
}