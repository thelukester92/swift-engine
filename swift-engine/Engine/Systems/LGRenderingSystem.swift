//
//  LGRenderingSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 7/14/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import SpriteKit

public final class LGRenderingSystem: LGSystem
{
	var positions	= [LGPosition]()
	var sprites		= [LGSprite]()
	var nodes		= [SKSpriteNode]()
	var frames		= [Int]()
	
	var spriteSheets = [String:LGSpriteSheet]()
	
	override public init()
	{
		super.init()
		self.updatePhase = .Render
	}
	
	override public func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGPosition) && entity.has(LGSprite)
	}
	
	override public func add(entity: LGEntity)
	{
		super.add(entity)
		
		let position	= entity.get(LGPosition)!
		let sprite		= entity.get(LGSprite)!
		let node		= generateNodeForSprite(sprite)
		
		scene.addChild(node)
		
		positions.append(position)
		sprites.append(sprite)
		nodes.append(node)
		frames.append(-1)
	}
	
	override public func remove(index: Int)
	{
		super.remove(index)
		
		nodes[index].removeFromParent()
		
		positions.removeAtIndex(index)
		sprites.removeAtIndex(index)
		nodes.removeAtIndex(index)
		frames.removeAtIndex(index)
	}
	
	override public func update()
	{
		for id in 0 ..< entities.count
		{
			let sprite	= sprites[id]
			let node	= nodes[id]
			
			if sprite.isVisible
			{
				let position = positions[id]
				
				if frames[id] != sprite.frame
				{
					if let texture = sprite.texture
					{
						node.texture				= spriteSheets[texture.name]!.textureAtPosition(sprite.frame)
						node.texture?.filteringMode	= .Nearest
						frames[id]					= sprite.frame
					}
				}
				
				node.position.x	= CGFloat(position.x + sprite.offset.x + Double(sprite.size.x / 2))
				node.position.y	= CGFloat(position.y + sprite.offset.y + Double(sprite.size.y / 2))
				node.xScale		= CGFloat(sprite.scale.x)
				node.yScale		= CGFloat(sprite.scale.y)
				node.zRotation	= CGFloat(sprite.rotation)
				node.zPosition	= CGFloat(sprite.layer)
				node.alpha		= CGFloat(sprite.opacity)
				node.hidden		= false
			}
			else
			{
				node.hidden = true
			}
		}
	}
	
	private func generateNodeForSprite(sprite: LGSprite) -> SKSpriteNode
	{
		var node = SKSpriteNode()
		
		if sprite.texture == nil
		{
			// Non-textured sprite
			
			if let color = sprite.color
			{
				node.colorBlendFactor	= 1.0
				node.color				= UIColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(sprite.opacity))
			}
		}
		else
		{
			// Textured sprite
			
			let texture = sprite.texture!
			var spriteSheet = spriteSheets[texture.name]
			
			if spriteSheet == nil
			{
				spriteSheet = LGSpriteSheet(textureName: texture.name, rows: texture.rows, cols: texture.cols)
				spriteSheets[texture.name] = spriteSheet
			}
			
			sprite.size.x = Double(spriteSheet!.width)
			sprite.size.y = Double(spriteSheet!.height)
		}
		
		node.anchorPoint	= CGPoint(x: 0.5, y: 0.5)
		node.size			= CGSize(width: CGFloat(sprite.size.x), height: CGFloat(sprite.size.y))
		
		return node
	}
}
