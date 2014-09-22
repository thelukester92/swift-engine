//
//  LGScene.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

public class LGScene
{
	final var systems			= [LGSystem]()
	final var systemsByPhase	= [LGUpdatePhase: [LGSystem]]()
	
	final var entities			= [LGEntity]()
	final var removed			= [LGEntity]()
	
	final var entitiesByName	= [String:LGEntity]()
	
	var initialized				= false
	public var paused			= false
	
	public var game: LGGame
	var scene: LGSpriteKitScene
	var rootNode: SKNode
	
	public var view: SKView
	{
		return scene.view!
	}
	
	public var backgroundColor: SKColor
	{
		get
		{
			return scene.backgroundColor
		}
		
		set
		{
			scene.backgroundColor = newValue
		}
	}
	
	required public init(game: LGGame)
	{
		self.game	= game
		rootNode	= SKNode()
		scene		= LGSpriteKitScene(size: game.view.frame.size)
		
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
	
	public func addChild(node: SKNode!)
	{
		rootNode.addChild(node)
	}
	
	public func initialize() {}
	
	// MARK: Private Methods
	
	private final func updateSystemsByPhase(phase: LGUpdatePhase)
	{
		if let systemsToUpdate = systemsByPhase[phase]
		{
			for system in systemsToUpdate
			{
				system.update()
			}
		}
	}
	
	private final func initializeSystems()
	{
		for system in systems
		{
			system.initialize()
		}
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
}

extension LGScene: LGUpdatable
{
	public final func update()
	{
		if !paused
		{
			if !initialized
			{
				initializeSystems()
				initialized = true
			}
			
			updateSystemsByPhase(.Input)
			updateSystemsByPhase(.Physics)
			updateSystemsByPhase(.Main)
			updateSystemsByPhase(.PreRender)
			updateSystemsByPhase(.Render)
			
			processRemovedEntities()
		}
	}
}
