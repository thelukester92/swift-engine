//
//  GameScene.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/3/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class GameScene: LGScene
{
	override func didMoveToView(view: SKView)
	{
		self.add(
			LGSpriteSystem(scene: self),
			LGPositionSystem()
		)
		
		let player = LGEntity()
		player.put(
			LGPosition(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)),
			LGSprite(spriteSheet: LGSpriteSheet(texture: SKTexture(imageNamed: "Player"), rows: 1, cols: 9)),
			LGNode(sknode: SKSpriteNode())
		)
		
		self.add(player)
	}
}
