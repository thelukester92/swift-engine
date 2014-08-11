//
//  LGScene.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

final class LGScene: LGUpdatable
{
	var systems			= [LGSystem]()
	var systemsByPhase	= [LGUpdatePhase: [LGSystem]]()
	
	var entities		= [LGEntity]()
	var removed			= [LGEntity]()
	
	var entitiesByName	= [String:LGEntity]()
	
	var scene: LGSpriteKitScene
	var rootNode: SKNode
	
	var view: SKView
	{
		return scene.view
	}
	
	init(size: CGSize)
	{
		rootNode	= SKNode()
		scene		= LGSpriteKitScene(size: size)
		
		scene.updateObservers.append(self)
		scene.addChild(rootNode)
	}
	
	func addEntity(entity: LGEntity, named name: String? = nil)
	{
		entity.scene = self
		
		if let n = name
		{
			entitiesByName[n] = entity
		}
		
		for system in systems
		{
			system.added(entity)
		}
		
		entities.append(entity)
	}
	
	func addEntities(entitiesToAdd: LGEntity...)
	{
		for entity in entitiesToAdd
		{
			addEntity(entity)
		}
	}
	
	func entityNamed(name: String) -> LGEntity?
	{
		return entitiesByName[name]
	}
	
	func removeEntity(entity: LGEntity)
	{
		removed.append(entity)
	}
	
	func processRemovedEntities()
	{
		if removed.count > 0
		{
			for entity in removed
			{
				// Alert systems that entity has been removed
				
				for system in systems
				{
					system.removed(entity)
				}
				
				// Remove named entity
				
				for (name, other) in entitiesByName
				{
					if other === entity
					{
						entitiesByName[name] = nil
						break
					}
				}
				
				// Remove entity from entities array
				
				for i in 0 ..< entities.count
				{
					if entities[i] === entity
					{
						entities.removeAtIndex(i)
						break
					}
				}
			}
			
			removed = []
		}
	}
	
	func changed(entity: LGEntity)
	{
		for system in systems
		{
			system.changed(entity)
		}
	}
	
	func addSystem(system: LGSystem)
	{
		systems.append(system)
		
		if var phase = systemsByPhase[system.updatePhase]
		{
			phase.append(system)
			systemsByPhase[system.updatePhase] = phase
		}
		else
		{
			systemsByPhase[system.updatePhase] = [system]
		}
		
		if let touchObserver = system as? LGTouchObserver
		{
			scene.touchObservers.append(touchObserver)
		}
		
		for entity in entities
		{
			if system.accepts(entity)
			{
				system.added(entity)
			}
		}
	}
	
	func addSystems(systemsToAdd: LGSystem...)
	{
		for system in systemsToAdd
		{
			addSystem(system)
		}
	}
	
	func removeSystem(system: LGSystem)
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
	
	// MARK: SKScene Overrides
	
	func addChild(node: SKNode!)
	{
		rootNode.addChild(node)
	}
	
	func update()
	{
		updateSystemsByPhase(.Input)
		updateSystemsByPhase(.Physics)
		updateSystemsByPhase(.Main)
		updateSystemsByPhase(.Render)
		processRemovedEntities()
	}
}
