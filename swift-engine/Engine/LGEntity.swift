//
//  LGEntity.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

final class LGEntity
{
	var components: [String: LGComponent] = [:]
	weak var scene: LGScene?
	
	convenience init(_ firstComponent: LGComponent, _ components: LGComponent...)
	{
		self.init()
		put(component: firstComponent)
		put(components)
	}
	
	func get<T: LGComponent>(type: T.Type) -> T?
	{
		return components[type.type()] as? T
	}
	
	func has(type: String) -> Bool
	{
		return components[type] != nil
	}
	
	func has<T: LGComponent>(type: T.Type) -> Bool
	{
		return has(type.type())
	}
	
	func put(#component: LGComponent)
	{
		components[component.type()] = component
		scene?.changed(self)
	}
	
	func put(componentsToPut: [LGComponent])
	{
		for component in componentsToPut
		{
			put(component: component)
		}
	}
	
	func put(componentsToPut: LGComponent...)
	{
		put(componentsToPut)
	}
	
	func remove<T: LGComponent>(type: T.Type)
	{
		components[type.type()] = nil
		scene?.changed(self)
	}
}
