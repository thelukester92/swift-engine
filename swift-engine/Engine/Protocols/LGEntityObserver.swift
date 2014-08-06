//
//  LGEntityObserver.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/21/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

protocol LGEntityObserver
{
	func added(entity: LGEntity)
	func removed(entity: LGEntity)
	func changed(entity: LGEntity)
}
