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
	var sounds = [LGSound]()
	
	var players			= [String:AVAudioPlayer]()
	var soundsByPlayer	= [AVAudioPlayer:LGSound]()
	
	var delegate: LGAudioPlayerDelegate!
	
	override public init()
	{
		super.init()
		self.updatePhase = .None
		
		delegate = LGAudioPlayerDelegate(system: self)
	}
	
	override public func accepts(entity: LGEntity) -> Bool
	{
		return entity.has(LGSound)
	}
	
	override public func add(entity: LGEntity)
	{
		super.add(entity)
		
		let sound = entity.get(LGSound)!
		sounds.append(sound)
		
		var player: AVAudioPlayer! = players[sound.name]
		
		if player == nil || soundsByPlayer[player] != nil
		{
			let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(sound.name, ofType: nil)!)
			
			player = AVAudioPlayer(contentsOfURL: url, error: nil)
			player.delegate = delegate
			player.prepareToPlay()
			
			if players[sound.name] == nil
			{
				players[sound.name] = player
			}
		}
		
		soundsByPlayer[player] = sound
		player.play()
	}
	
	override public func remove(index: Int)
	{
		super.remove(index)
		sounds.removeAtIndex(index)
	}
	
	class LGAudioPlayerDelegate: NSObject, AVAudioPlayerDelegate
	{
		var system: LGSoundSystem
		
		init(system: LGSoundSystem)
		{
			self.system = system
		}
		
		func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Boolean)
		{
			if let sound = system.soundsByPlayer[player]
			{
				system.soundsByPlayer[player] = nil
				for entity in system.entities
				{
					if entity.get(LGSound) === sound
					{
						entity.remove(LGSound)
						break
					}
				}
			}
		}
	}
}
