//
//  LGScene.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

public final class LGScene
{
	var systems			= [LGSystem]()
	var systemsByPhase	= [LGUpdatePhase: [LGSystem]]()
	
	var entities		= [LGEntity]()
	var removed			= [LGEntity]()
	
	var entitiesByName	= [String:LGEntity]()
	
	var scene: LGSpriteKitScene
	var rootNode: SKNode
	
	public var view: SKView
	{
		return scene.view
	}
	
	public init(size: CGSize)
	{
		rootNode	= SKNode()
		scene		= LGSpriteKitScene(size: size)
		
		scene.updateObservers.append(self)
		scene.addChild(rootNode)
	}
	
	public func addEntity(entity: LGEntity, named name: String? = nil)
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
	
	public func addEntities(entitiesToAdd: LGEntity...)
	{
		for entity in entitiesToAdd
		{
			addEntity(entity)
		}
	}
	
	public func entityNamed(name: String) -> LGEntity?
	{
		return entitiesByName[name]
	}
	
	public func removeEntity(entity: LGEntity)
	{
		removed.append(entity)
	}
	
	private func processRemovedEntities()
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
	
	public func changed(entity: LGEntity)
	{
		for system in systems
		{
			system.changed(entity)
		}
	}
	
	public func addSystem(system: LGSystem)
	{
		system.scene = self
		systems.append(system)
		
		// Register for an update phase
		
		if system.updatePhase != .None
			{
			if var phase = systemsByPhase[system.updatePhase]
			{
				phase.append(system)
				systemsByPhase[system.updatePhase] = phase
			}
			else
			{
				systemsByPhase[system.updatePhase] = [system]
			}
		}
		
		// Register as a touch observer, if applicable
		
		if let touchObserver = system as? LGTouchObserver
		{
			scene.touchObservers.append(touchObserver)
		}
		
		// Notify the system of any entities that already exist
		
		for entity in entities
		{
			if system.accepts(entity)
			{
				system.added(entity)
			}
		}
	}
	
	public func addSystems(systemsToAdd: LGSystem...)
	{
		for system in systemsToAdd
		{
			addSystem(system)
		}
	}
	
	public func removeSystem(system: LGSystem)
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
	
	private func updateSystemsByPhase(phase: LGUpdatePhase)
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
	
	public func addChild(node: SKNode!)
	{
		rootNode.addChild(node)
	}
}

extension LGScene: LGUpdatable
{
	public func update()
	{
		updateSystemsByPhase(.Input)
		updateSystemsByPhase(.Physics)
		updateSystemsByPhase(.Main)
		updateSystemsByPhase(.Render)
		processRemovedEntities()
	}
}
