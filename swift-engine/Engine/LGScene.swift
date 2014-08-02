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
	
	var entityNames		= [String]()
	var entityNameIds	= [Int]()
	
	var touchObservers	= [LGTouchObserver]()
	
	var rootNode: SKNode
	
	init(size: CGSize)
	{
		rootNode = SKNode()
		
		super.init(size: size)
		super.addChild(rootNode)
	}
	
	func addEntity(entity: LGEntity, named name: String? = nil)
	{
		entity.scene = self
		
		if let n = name
		{
			entityNames += n
			entityNameIds += entities.count
		}
		
		for system in systems
		{
			system.added(entity)
		}
		
		entities += entity
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
		for i in 0 ..< entityNameIds.count
		{
			if entityNames[i] == name
			{
				return entities[entityNameIds[i]]
			}
		}
		
		return nil
	}
	
	func removeEntity(entity: LGEntity)
	{
		removed += entity
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
				
				for i in entityNameIds
				{
					if entities[i] === entity
					{
						entityNames.removeAtIndex(i)
						entityNameIds.removeAtIndex(i)
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
		
		if let touchObserver = system as? LGTouchObserver
		{
			touchObservers += touchObserver
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
	
	override func addChild(node: SKNode!)
	{
		rootNode.addChild(node)
	}
	
	override func update(currentTime: NSTimeInterval)
	{
		updateSystemsByPhase(.Input)
		updateSystemsByPhase(.Physics)
		updateSystemsByPhase(.Main)
		updateSystemsByPhase(.Render)
		processRemovedEntities()
	}
	
	override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
	{
		for touchObserver in touchObservers
		{
			touchObserver.touchesBegan(touches, withEvent: event)
		}
	}
	
	override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
	{
		for touchObserver in touchObservers
		{
			touchObserver.touchesMoved(touches, withEvent: event)
		}
	}
	
	override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)
	{
		for touchObserver in touchObservers
		{
			touchObserver.touchesEnded(touches, withEvent: event)
		}
	}
}
