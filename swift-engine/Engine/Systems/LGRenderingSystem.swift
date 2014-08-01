//
//  LGRenderingSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 7/14/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import SpriteKit

class LGRenderingSystem: LGSystem
{
	var scene: LGScene
	final var positions	= [LGPosition]()
	final var sprites	= [LGSprite]()
	final var posForId	= [Int:Int]()
	
	init(scene: LGScene)
	{
		self.scene = scene
		
		super.init()
		self.updatePhase = .Render
	}
	
	override func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGPosition) && entity.has(LGSprite)
	}
	
	override func add(entity: LGEntity)
	{
		super.add(entity)
		
		let position	= entity.get(LGPosition)!
		let sprite		= entity.get(LGSprite)!
		
		prepareSprite(sprite)
		
		positions += position
		sprites += sprite
	}
	
	override func update()
	{
		// TODO: Don't render everything every time... only render moved/changed things
		for id in 0 ..< entities.count
		{
			let sprite = sprites[id]
			let position = positions[id]
			
			if sprite.isVisible
			{
				updateSpriteFrame(sprite)
				
				// Update sprite position, orientation, and other SKSpriteNode properties
				
				sprite.node.position.x	= CGFloat(position.x + sprite.offset.x + Double(sprite.node.size.width / 2))
				sprite.node.position.y	= CGFloat(position.y + sprite.offset.y + Double(sprite.node.size.height / 2))
				sprite.node.xScale		= CGFloat(sprite.scale.x)
				sprite.node.yScale		= CGFloat(sprite.scale.y)
				sprite.node.zRotation	= CGFloat(sprite.rotation)
				sprite.node.zPosition	= CGFloat(sprite.layer)
				sprite.node.alpha		= CGFloat(sprite.opacity)
				sprite.node.hidden		= false
			}
			else
			{
				sprite.node.hidden = true
			}
		}
	}
	
	func prepareSprite(sprite: LGSprite)
	{
		var pos = 1
		
		var node: SKSpriteNode!
		if let _ = sprite.node
		{
			node = sprite.node
		}
		else
		{
			node = SKSpriteNode()
			node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			sprite.node = node
		}
		scene.addChild(node)
		
		if let state = sprite.currentState
		{
			pos = state.position
		}
		
		if let texture = sprite.spriteSheet?.textureAtPosition(pos)
		{
			texture.filteringMode = .Nearest
			
			sprite.node.texture = texture
			sprite.node.size = texture.size()
		}
		else if let body = entity.get(LGPhysicsBody)
		{
			sprite.node.color = UIColor.whiteColor()
			sprite.node.size = CGSize(width: CGFloat(body.width), height: CGFloat(body.height))
		}
	}
	
	func updateSpriteFrame(sprite: LGSprite)
	{
		if let state = sprite.currentState
		{
			if !state.isAnimated || ++state.counter > state.duration
			{
				// Animated animatable sprites
				
				if state.isAnimated
				{
					// TODO: use a state.incrementor property (instead of position++), so some sprites can run faster/slower
					state.position++
					if state.position > state.end
					{
						if state.loops
						{
							state.position = state.start
						}
						else
						{
							state.position = state.end
						}
					}
					state.counter = 0
				}
				
				// Only pull a new texture if the position changed
				
				if !posForId[id] || posForId[id] != state.position
				{
					sprite.node.texture = sprite.spriteSheet?.textureAtPosition(state.position)
					posForId[id] = state.position
				}
			}
		}
	}
}
