//
//  LGBackgroundSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 9/18/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGBackgroundSystem: LGSystem
{
	let firstBackgroundLayer = -1000
	
	var backgrounds = [LGBackground]()
	var bgEntities	= [[LGEntity]]()
	var bgPositions	= [[LGPosition]]()
	var bgSprites	= [[LGSprite]]()
	var bgWidths	= [Double]()
	
	var initialized = false
	
	override public init()
	{
		super.init()
		updatePhase = .PreRender
	}
	
	override public func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGBackground)
	}
	
	override public func add(entity: LGEntity)
	{
		backgrounds.append(entity.get(LGBackground)!)
		bgEntities.append([LGEntity]())
		bgPositions.append([LGPosition]())
		bgSprites.append([LGSprite]())
		bgWidths.append(0)
		
		if initialized
		{
			initializeBackground(backgrounds.count - 1)
		}
	}
	
	override public func remove(index: Int)
	{
		backgrounds.removeAtIndex(index)
		
		for entity in bgEntities[index]
		{
			scene.removeEntity(entity)
		}
		
		bgEntities.removeAtIndex(index)
		bgPositions.removeAtIndex(index)
		bgSprites.removeAtIndex(index)
		bgWidths.removeAtIndex(index)
		
		super.remove(index)
	}
	
	override public func initialize()
	{
		for id in 0 ..< backgrounds.count
		{
			initializeBackground(id)
		}
		
		initialized = true
	}
	
	override public func update()
	{
		let sceneOffset = LGVector(x: Double(scene.rootNode.position.x), y: Double(scene.rootNode.position.y))
		
		for id in 0 ..< backgrounds.count
		{
			let width = bgSprites[id][0].size.x
			
			var baseX = -backgrounds[id].distance * sceneOffset.x
			baseX -= width * Double(Int((sceneOffset.x + baseX) / width))
			
			let baseY = -backgrounds[id].distance * sceneOffset.y
			
			for i in 0 ..< bgPositions[id].count
			{
				bgPositions[id][i].x = baseX + width * Double(i)
				bgPositions[id][i].y = baseY
			}
		}
	}
	
	func initializeBackground(id: Int)
	{
		while bgWidths[id] < Double(scene.view.frame.size.width)
		{
			addBackgroundSection(id)
		}
		
		// Add one for overlap (a transition piece)
		addBackgroundSection(id)
	}
	
	func addBackgroundSection(id: Int)
	{
		let position	= LGPosition()
		
		let sprite		= LGSprite(textureName: backgrounds[id].textureName)
		sprite.layer	= firstBackgroundLayer + backgrounds[id].layer
		
		let entity		= LGEntity( position, sprite )
		
		scene.addEntity(entity)
		
		bgEntities[id].append(entity)
		bgPositions[id].append(position)
		bgSprites[id].append(sprite)
		
		bgWidths[id] += sprite.size.x
	}
}
