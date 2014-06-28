Swift Engine
===

This project is a game engine designed for the iPhone platform. It is built in Apple's brand-new [Swift programming language](https://developer.apple.com/swift/), and uses the Entity-Component-System architecture. The project was originally written in Objective-C (see the [old project](https://github.com/thelukester92/ecs-engine-for-iphone/)).

**This is a work-in-progress!** This engine is in early alpha, which is why there are no instructions as to how it works yet. Once all of the core functionality is implemented, some basic instructions will be found here.

For more information, go to [the devblog for this engine.](http://devblog.lukesterwebdesign.com/)

***

# Current Features

* Entity-component-system framework
* Various systems decomposing the SKNode/SKSpriteNode so that the engine can be ECS and use SpriteKit
* Sprite system for displaying textures and sprites with animated "states"

The engine right now can render textures, simulate gravity and collisions, and accept single-tap input to test out different sprite states (jumping and idling).

***

# Todo

* Convert LGTileMap from Objective-C to Swift
* Create a camera system
* Reimplement tile system.
* Reimplement player input system.
* Reimplement Lua support.
* Figure out a way to access LGSprite.node before LGNodeSystem has connected the node
* Stop sprites from fetching a new texture every frame if the texture isn't changing
* Get the correct sprite from row and col
* Engine interface should be agnostic of the underlying framework, i.e. it should not be so tightly coupled to SpriteKit; we should remove the node system and explicit passing of SK classes.
* Sprites may not always need states (i.e. tiles only have one frame always)
* LGTileLayer.data should be LGTile[][]