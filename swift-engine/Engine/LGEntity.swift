//
//  LGEntity.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

@final class LGEntity
{
	var components = Dictionary<String, LGComponent>()
	
	convenience init(components: LGComponent...)
	{
		self.init()
		put(components)
	}
	
	func has(types: String...) -> Bool
	{
		for type in types
		{
			if !components[type]
			{
				return false
			}
		}
		return true
	}
	
	func get(type: String) -> LGComponent?
	{
		return components[type]
	}
	
	func put(componentsToPut: LGComponent[])
	{
		for component in componentsToPut
		{
			 components[component.type()] = component
		}
	}
	
	func put(componentsToPut: LGComponent...)
	{
		put(componentsToPut)
	}
}