//
//  LGBackground.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/18/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGBackground: LGComponent
{
	public class func type() -> String
	{
		return "LGBackground"
	}
	
	public func type() -> String
	{
		return LGBackground.type()
	}
	
	var textureName: String
	var distance: Double
	var layer: Int
	
	public init(textureName: String, distance: Double = 0.5, layer: Int = 0)
	{
		self.textureName	= textureName
		self.distance		= distance
		self.layer			= layer
	}
}
