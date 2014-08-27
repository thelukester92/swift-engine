//
//  LGSoundSystem.swift
//  swift-engine
//
//  Created by Luke Godfrey on 8/27/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import AVFoundation

public final class LGSoundSystem: LGSystem
{
	// TODO: Allow the same sound to play twice at the same time... not sure what currently happens
	
	var sounds = [LGSound]()
	var players = [String:AVAudioPlayer]()
	
	override public func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGSound)
	}
	
	override public func add(entity: LGEntity)
	{
		super.add(entity)
		
		let sound = entity.get(LGSound)!
		sounds.append(sound)
		
		if players[sound.name] == nil
		{
			let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(sound.name, ofType: nil)!)
			let player = AVAudioPlayer(contentsOfURL: url, error: nil)
			player.prepareToPlay()
			players[sound.name] = player
		}
	}
	
	override public func remove(index: Int)
	{
		super.remove(index)
		sounds.removeAtIndex(index)
	}
	
	override public func update()
	{
		for i in 0 ..< entities.count
		{
			if sounds[i].complete
			{
				scene.removeEntity(entities[i])
			}
			else if !sounds[i].active
			{
				players[sounds[i].name]!.play()
				sounds[i].active = true
			}
		}
	}
}
