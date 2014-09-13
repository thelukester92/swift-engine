//
//  MenuScene.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/13/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import LGSwiftEngine

class MenuScene: LGScene
{
	override func initialize()
	{
		addSystems(
			LGRenderingSystem(),
			MenuInputSystem()
		)
	}
}
