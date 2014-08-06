Swift Engine
===

**Version: 0.1**

This project is a game engine designed for the iPhone platform. It is built in Apple's new [Swift programming language](https://developer.apple.com/swift/), and uses the Entity-Component-System architecture. The project was originally written in Objective-C (see the [old project](https://github.com/thelukester92/ecs-engine-for-iphone/)).

The purpose of this project is to provide the functionality required to create simple 2D games. In addition to the basic ECS framework, the project will implement common systems required by most games, such as physics and rendering, so that game developers can jump right into the design and implementation of their games. Abstracting away those common functions will facilitate rapid game development.

The Swift engine is currently in *alpha* status. It is complete, but still undergoing testing as I develop a game on top of it and add/change things as needed. This is a work-in-progress, and I welcome you to contribute! This project is licensed under the MIT License, so you are free to use and modify this code for use in your own projects.

For more information, see the below links. The documentation contains a brief description of how to get started using the engine.

* [The devblog for this engine.](http://devblog.lukesterwebdesign.com/)
* [Todos and known issues.](https://github.com/thelukester92/swift-engine/issues)
* [Wiki documentation.](https://github.com/thelukester92/swift-engine/wiki)

# Feature List

* Entity-component-system framework
* Rendering system maps the position component to a `SKSpriteNode` and displays textures and sprites with animated states
* Tile system that creates entities for tilemaps and has an object pool to reuse tile entities as the game world scrolls
* Physics system for basic platformer physics
