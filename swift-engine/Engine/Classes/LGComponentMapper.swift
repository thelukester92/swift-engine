//
//  LGComponentMapper.swift
//  swift-engine
//
//  Created by Luke Godfrey on 10/17/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public class LGComponentMapper<T: LGComponent>: LGMapper<T>
{
	public override init()
	{
		// Calling an internal initializer
		super.init()
	}
	
	// MARK: LGEntityObserver methods
	
	public override func added(manager: LGEntityManager, id: Int)
	{
		data.append(manager.entities[id].get(T)!)
	}
}

public class LGOptionalComponentMapper<T: LGComponent>: LGMapper<T?>
{
	public override init()
	{
		// Calling an internal initializer
		super.init()
	}
	
	// MARK: LGEntityObserver methods
	
	public override func added(manager: LGEntityManager, id: Int)
	{
		data.append(manager.entities[id].get(T))
	}
	
	public override func changed(manager: LGEntityManager, id: Int)
	{
		data[id] = manager.entities[id].get(T)
	}
}
