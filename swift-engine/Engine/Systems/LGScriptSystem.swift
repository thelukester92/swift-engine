//
//  LGScriptSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/29/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGScriptSystem: LGSystem
{
	override public func initialize()
	{
		LGGameLibrary.runScript("LGLuaBridge.lua", withScene: scene)
	}
}
