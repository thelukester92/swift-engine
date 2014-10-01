//
//  LGGameLibrary.swift
//  swift-engine
//
//  Created by Luke Godfrey on 10/1/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

@objc final class LGGameLibrary
{
	struct Static
	{
		static var scene: LGScene?
	}
	
	class var scene: LGScene?
	{
		get { return Static.scene }
		set { Static.scene = newValue }
	}
	
	// MARK: Objective-C to Swift
	
	class func getProp(prop: String, entity: String, component: String) -> LGJSON?
	{
		if scene != nil
		{
			if let deserializable = scene!.entityNamed(entity)?.getByTypeName(component) as? LGDeserializable
			{
				return deserializable.valueForKey(prop)
			}
		}
		
		return nil
	}
	
	// MARK: Swift to Objective-C
	
	class func runScript(script: String, withScene scene: LGScene? = nil)
	{
		self.scene = scene
		LGLuaBridge.sharedBridge().runScript(script)
		self.scene = nil
	}
}
