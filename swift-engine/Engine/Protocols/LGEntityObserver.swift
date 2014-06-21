//
//  LGEntityObserver.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/21/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

protocol LGEntityObserver
{
	func added(entity: LGEntity)
	func removed(entity: LGEntity)
	func changed(entity: LGEntity)
}