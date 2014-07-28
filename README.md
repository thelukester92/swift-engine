Swift Engine
===

This project is a game engine designed for the iPhone platform. It is built in Apple's new [Swift programming language](https://developer.apple.com/swift/), and uses the Entity-Component-System architecture. The project was originally written in Objective-C (see the [old project](https://github.com/thelukester92/ecs-engine-for-iphone/)).

The purpose of this project is to provide the functionality required to create simple 2D games. In addition to the basic ECS framework, the project will implement common systems required by most games, such as physics and rendering, so that game developers can jump right into the design and implementation of their games. Abstracting away those common functions will facilitate rapid game development.

**This is a work-in-progress!** This engine is in early alpha, which is why there are no instructions as to how it works yet. Once all of the core functionality is implemented, some basic instructions will be found here.

For more information, go to [the devblog for this engine.](http://devblog.lukesterwebdesign.com/)

***

# Current Features

* Entity-component-system framework
* Rendering system that uses SpriteKit by mapping the position component to a SKSpriteNode position
* Sprite system for displaying textures and sprites with animated states
* Tile system for creating entities for tilemaps
* Physics system for basic platformer physics

The engine right now can render textures, simulate gravity and collisions, and accept single-tap input to test out different sprite states (jumping and idling).

***

# Todo

* [x] Reimplement tile system.
* [ ] Reimplement .tmx file format support.
* [ ] Fix first frame so that it doesn't display nonpositioned entities.
* [ ] Create a camera system.
* [ ] Reimplement player input system.
* [ ] Reimplement Lua support.
* [ ] Stop sprites from fetching a new texture every frame if the texture isn't changing.
* [ ] Don't force sprites to have states (when only a single frame is needed).