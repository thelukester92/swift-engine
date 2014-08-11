//
//  LGCameraSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/1/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import UIKit

public final class LGCameraSystem: LGSystem
{
	var scene: LGScene
	
	var cameraPosition: LGPosition!
	var camera: LGCamera!
	
	public init(scene: LGScene)
	{
		self.scene = scene
		
		super.init()
		self.updatePhase = .Render
	}
	
	override public func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGPosition) && entity.has(LGCamera)
	}
	
	override public func add(entity: LGEntity)
	{
		cameraPosition	= entity.get(LGPosition)
		camera			= entity.get(LGCamera)
	}
	
	override public func update()
	{
		scene.rootNode.position = CGPoint(x: -CGFloat(cameraPosition.x + camera.offset.x), y: -CGFloat(cameraPosition.y + camera.offset.y))
	}
}
