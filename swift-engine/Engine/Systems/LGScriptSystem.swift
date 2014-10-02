//
//  LGScriptSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/29/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGScriptSystem: LGSystem
{
	var scriptables = [LGScriptable]()
	
	override public func initialize()
	{
		LGGameLibrary.scene = scene
		LGGameLibrary.runScript("LGLuaBridge.lua")
	}
	
	override public func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGScriptable)
	}
	
	override public func add(entity: LGEntity)
	{
		super.add(entity)
		scriptables.append(entity.get(LGScriptable)!)
	}
	
	override public func remove(index: Int)
	{
		super.remove(index)
		scriptables.removeAtIndex(index)
	}
	
	override public func update()
	{
		for scriptable in scriptables
		{
			for event in scriptable.events
			{
				if let script = scriptable.scripts[event]
				{
					LGGameLibrary.runScript(script)
				}
			}
			scriptable.events.removeAll(keepCapacity: false)
		}
	}
}
