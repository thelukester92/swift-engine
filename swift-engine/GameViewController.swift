//
//  GameViewController.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/3/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode
{
	class func unarchiveFromFile(file : NSString) -> SKNode?
	{
		let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
		
		var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
		
		var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
		archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
		
		let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
		archiver.finishDecoding()
		
		return scene
    }
}

class GameViewController: UIViewController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		let engine = LGEngine(view: self.view as SKView)
		let scene = GameScene(size: self.view.frame.size)
		
		engine.gotoScene(scene)
	}
	
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
