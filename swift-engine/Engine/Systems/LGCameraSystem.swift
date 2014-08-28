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
	var cameraPosition: LGPosition!
	var cameraBody: LGPhysicsBody!
	var camera: LGCamera!
	
	override public func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGCamera) && entity.has(LGPosition) && entity.has(LGPhysicsBody)
	}
	
	override public func add(entity: LGEntity)
	{
		cameraPosition	= entity.get(LGPosition)
		cameraBody		= entity.get(LGPhysicsBody)
		camera			= entity.get(LGCamera)
	}
	
	override public func update()
	{
		if cameraPosition != nil && camera != nil
		{
			if let boundary = camera.boundary
			{
				cameraPosition.x = min(max(cameraPosition.x, boundary.x), boundary.extremeX - cameraBody.width)
				cameraPosition.y = min(max(cameraPosition.y, boundary.y), boundary.extremeY - cameraBody.height)
			}
			
			scene.rootNode.position = CGPoint(x: -CGFloat(cameraPosition.x), y: -CGFloat(cameraPosition.y))
		}
	}
}
