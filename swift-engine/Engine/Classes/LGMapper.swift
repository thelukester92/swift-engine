//
//  LGMapper.swift
//  swift-engine
//
//  Created by Luke Godfrey on 10/17/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//
//  Maps an entity id to some data (i.e. metadata)
//

public class LGMapper<T>: LGEntityObserver
{
	public final var data = [T]()
	private var create: (() -> T)?
	
	internal init() {}
	
	public init(_ create: () -> T)
	{
		self.create = create
	}
	
	public subscript(i: Int) -> T
	{
		get
		{
			return data[i]
		}
		set
		{
			data[i] = newValue
		}
	}
	
	// MARK: LGEntityObserver methods
	
	public func added(manager: LGEntityManager, id: Int)
	{
		data.append(create!())
	}
	
	public func removed(manager: LGEntityManager, id: Int)
	{
		data.removeAtIndex(id)
	}
	
	public func changed(manager: LGEntityManager, id: Int) {}
}
