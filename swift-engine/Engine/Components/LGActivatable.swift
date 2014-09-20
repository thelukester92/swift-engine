//
//  LGActivatable.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/19/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public class LGActivatable: LGComponent
{
	public class func type() -> String
	{
		return "LGActivatable"
	}
	
	public func type() -> String
	{
		return LGActivatable.type()
	}
	
	public var activate: (() -> ())?
	public var deactivate: (() -> ())?
	
	public init(activate: (() -> ())? = nil, deactivate: (() -> ())? = nil)
	{
		self.activate	= activate
		self.deactivate	= deactivate
	}
}
