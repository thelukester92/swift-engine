//
//  LGTouchObserver.swift
//  swift-engine
//
//  Created by Luke Godfrey on 7/28/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import UIKit

// TODO: Remove @objc ; it is only here so we can check for conformance
@objc protocol LGTouchObserver
{
	func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
	func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
	func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)
}
