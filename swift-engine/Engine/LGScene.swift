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
	var touchObservers	= [LGTouchObserver]()
	
	var rootNode: SKNode
	
	init(size: CGSize)
	{
		rootNode = SKNode()
		
		super.init(size: size)
		super.addChild(rootNode)
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
		if removed.count > 0
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
