//
//  LGCamera.swift
//  swift-engine
//
//  Created by Luke Godfrey on 7/31/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

class LGCamera: LGComponent
{
	class func type() -> String
	{
		return "LGCamera"
	}
	
	func type() -> String
	{
		return LGCamera.type()
	}
	
	var offset	= LGVector()
	var size	= LGVector()
}
