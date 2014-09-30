//
//  LGScriptable.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/29/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public protocol LGScriptable
{
	func setProp(prop: String, val: LGJSON) -> Bool
}
