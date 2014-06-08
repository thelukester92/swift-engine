//
//  LGUpdatePhase.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

enum LGUpdatePhase
{
	case First			// Default, in SKScene.update
	case AfterActions	// In SKScene.didEvaluateActions
	case AfterPhysics	// In SKScene.didSimulatePhysics
	case Last			// In SKScene.didSimulatePhysics (immediately before rendering)
	case None			// Passive delegate
}