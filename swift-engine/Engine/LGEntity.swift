//
//  LGEntity.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGEntity
{
	var components: [String: LGComponent] = [:]
	weak var scene: LGScene?
	
	public init() {}
	
	public convenience init(_ firstComponent: LGComponent, _ components: LGComponent...)
	{
		self.init()
		put(component: firstComponent)
		put(components)
	}
	
	public func get<T: LGComponent>(type: T.Type) -> T?
	{
		return components[type.type()] as? T
	}
	
	public func has(type: String) -> Bool
	{
		return components[type] != nil
	}
	
	public func has<T: LGComponent>(type: T.Type) -> Bool
	{
		return has(type.type())
	}
	
	public func put(#component: LGComponent)
	{
		components[component.type()] = component
		scene?.changed(self)
	}
	
	public func put(componentsToPut: [LGComponent])
	{
		for component in componentsToPut
		{
			put(component: component)
		}
	}
	
	public func put(componentsToPut: LGComponent...)
	{
		put(componentsToPut)
	}
	
	public func remove<T: LGComponent>(type: T.Type)
	{
		components[type.type()] = nil
		scene?.changed(self)
	}
}
