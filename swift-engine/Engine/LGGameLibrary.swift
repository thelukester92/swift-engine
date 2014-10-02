//
//  LGGameLibrary.swift
//  swift-engine
//
//  Created by Luke Godfrey on 10/1/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

@objc public final class LGGameLibrary
{
	struct Static
	{
		static var scene: LGScene?
	}
	
	public class var scene: LGScene?
	{
		get { return Static.scene }
		set { Static.scene = newValue }
	}
	
	// MARK: Objective-C to Swift
	
	public class func getProp(prop: String, entity: Int, component: String) -> LGJSON?
	{
		if scene != nil
		{
			if let deserializable = scene!.entityById(entity)?.getByTypeName(component) as? LGDeserializable
			{
				return deserializable.valueForKey(prop)
			}
		}
		
		return nil
	}
	
	public class func setProp(prop: String, entity: Int, component: String, value: LGJSON)
	{
		if scene != nil
		{
			if let deserializable = scene!.entityById(entity)?.getByTypeName(component) as? LGDeserializable
			{
				deserializable.setValue(value, forKey: prop)
			}
		}
	}
	
	public class func getEntityId(name: String) -> NSNumber?
	{
		if scene != nil
		{
			if let entity = scene!.entityNamed(name)
			{
				return NSNumber(integer: entity.globalId)
			}
		}
		
		return nil
	}
	
	// MARK: Swift to Objective-C
	
	public class func runScript(script: String)
	{
		LGLuaBridge.sharedBridge().runScript(script)
	}
	
	public class func runScript(var script: String, withParams param: AnyObject, _ params: AnyObject ...)
	{
		let allParams = [param] + params
		for i in 0 ..< allParams.count
		{
			script = script.stringByReplacingOccurrencesOfString("$\(i)", withString: "\(allParams[i])")
		}
		runScript(script)
	}
}
