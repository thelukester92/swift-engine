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
				return NSNumber(integer: entity.id)
			}
		}
		
		return nil
	}
	
	// MARK: Swift to Objective-C
	
	public class func loadScript(inout script: String)
	{
		if(script.pathExtension == "lua")
		{
			// Check for framework scripts first
			var scriptFile = NSBundle(forClass: LGGameLibrary.self).pathForResource(script, ofType: nil)
			
			// Check for user scripts (game side)
			if(scriptFile == nil)
			{
				scriptFile = NSBundle.mainBundle().pathForResource(script, ofType: nil)
			}
			
			if(scriptFile != nil)
			{
				script = NSString(contentsOfFile: scriptFile!, encoding: NSUTF8StringEncoding, error: nil)!
			}
			else
			{
				println("Error! Nonexistant Lua script: \(script)");
			}
		}
	}
	
	public class func runScript(var script: String)
	{
		loadScript(&script)
		LGLuaBridge.sharedBridge().runScript(script)
	}
	
	public class func runScript(var script: String, withParams params: [AnyObject])
	{
		loadScript(&script)
		for i in 0 ..< params.count
		{
			script = script.stringByReplacingOccurrencesOfString("$\(i)", withString: "\(params[i])")
		}
		LGLuaBridge.sharedBridge().runScript(script)
	}
}
