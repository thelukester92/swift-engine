//
//  LGEntityObserver.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/21/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public protocol LGEntityObserver
{
	func added(manager: LGEntityManager, id: Int)
	func removed(manager: LGEntityManager, id: Int)
	func changed(manager: LGEntityManager, id: Int)
}
