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
	
	override func remove(index: Int)
	{
		super.remove(index)
		
		removeSprite(sprites[index])
		
		positions.removeAtIndex(index)
		sprites.removeAtIndex(index)
		posForId[index] = nil
	}
	
	override func update()
	{
		// TODO: Determine whether it would be more efficient to only process entities that have definitely moved or changed
		
		for id in 0 ..< entities.count
		{
			let sprite = sprites[id]
			let position = positions[id]
			
			if sprite.isVisible
			{
				updateSpriteFrame(sprite, id: id)
				
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
		// Initialize a SKSpriteNode for this sprite
		
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
		
		// Initialize texture -- the correct frame will be selected later
		
		if let texture = sprite.spriteSheet?.textureAtPosition(1)
		{
			texture.filteringMode = .Nearest
			
			sprite.node.texture = texture
			sprite.node.size = texture.size()
		}
	}
	
	func removeSprite(sprite: LGSprite)
	{
		// Remove the SKSpriteNode for this sprite
		sprite.node.removeFromParent()
	}
	
	func updateSpriteFrame(sprite: LGSprite, id: Int)
	{
		// Use the sprite's state, if it has one
		
		if let state = sprite.currentState
		{
			// Animated animatable sprites
			
			if state.isAnimated && ++state.counter > state.duration
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
			
			// Store the updated position in the sprite
			
			sprite.position = state.position
			
			// Remove non-animated states so that the optional binding is only executed once per state
			// TODO: make sure this is safe -- will anyone ever need to check the current state?
			
			if !state.isAnimated
			{
				sprite.currentState = nil
			}
		}
		
		// Update sprite texture if the position changed
		
		if !posForId[id] || posForId[id] != sprite.position
		{
			sprite.node.texture = sprite.spriteSheet?.textureAtPosition(sprite.position)
			posForId[id] = sprite.position
		}
	}
}
