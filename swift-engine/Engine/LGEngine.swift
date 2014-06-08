//
//  LGEngine.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/5/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import UIKit
import SpriteKit

class LGEngine: UIViewController
{
	override func viewDidLoad()
	{
		let spriteView				= self.view as SKView
		spriteView.showsDrawCount	= true
		spriteView.showsNodeCount	= true
		spriteView.showsFPS			= true
	}
	
	override func viewWillAppear(animated: Bool)
	{
		/*
		let scene		= MainScene()
		let spriteView	= self.view as SKView
		spriteView.presentScene(scene)
		*/
	}
}