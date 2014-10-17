//
//  LGEntity.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGEntity
{
	public let INVALID = -1
	public var id: Int
	
	var components: [String: LGComponent] = [:]
	weak var scene: LGScene?
	
	public class func EntityFromTemplate(template: String?) -> LGEntity?
	{
		if template != nil
		{
			if let json = LGJSON.JSONFromFile(template!)
			{
				let entity = LGEntity()
				
				for (type, value) in json
				{
					if let serialized = value.stringValue
					{
						if let component = LGDeserializer.deserialize(serialized, withType: type)
						{
							entity.put(component: component)
							continue
						}
						else
						{
							println("WARNING: Failed to deserialize a component of type '\(type)'")
						}
					}
					
					return nil
				}
				
				return entity
			}
		}
		
		return nil
	}
	
	public init()
	{
		id = INVALID
	}
	
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
	
	public func getByTypeName(typeName: String) -> LGComponent?
	{
		return components[typeName]
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

extension LGEntity: Hashable
	{
	public var hashValue: Int
		{
		return id
	}
}

public func == (left: LGEntity, right: LGEntity) -> Bool
{
	return left.hashValue == right.hashValue
}
