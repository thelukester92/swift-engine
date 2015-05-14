**I have discontinued this project indefinitely. Thank you for checking it out! I am leaving it up for educational purposes.**

# Swift Engine

The Swift engine is an [Entity-Component-System](http://en.wikipedia.org/wiki/Entity_component_system) game engine. Is is among the first game engines written in the [Swift programming language](https://developer.apple.com/swift/), and is specifically designed to facilitate the rapid development of iPhone and iPad games. The project is currently a complete alpha version. This project is licensed under the MIT License, which means you are free to use, modify, and distribute copies of the source code.

# Why Swift?

The Swift programming language was selected to place this project on a new frontier. Swift is currently a beta programming language that has only been publicly available since June 2014. It is constantly evolving and improving, and is the future of iOS development. By making use of this new technology, this project is on the cutting edge.

# What is the ECS architecture?

The Entity-Component-System architecture (ECS) is a pattern for decoupling data and logic, which makes it ideal for a game engine. Entities are game objects that are little more than lists of components. Components are groups of properties that have a specific purpose, such as a sprite component with the data required for rendering a sprite. Systems contain all of the game logic pertaining to entities with a specific combination of components, such as a rendering system that handles entities with a position component and a sprite component. By modularizing game objects into components, it is easy to add, change, and remove aspects of an entity. By modularizing game logic into systems, it is easy to add, change, and remove entire portions of the game while leaving the rest untouched.

# How can I get started using the engine?

To begin using the engine, clone the repository and include the source files in a new XCode project that uses SpriteKit. You can use the files in the Game folder of this project as an example of how to use the engine. There are two main things you need to do to use the engine: create a scene and start the engine.

## Create a scene

Subclass the base `LGScene` to create your scene. The recommended entry point is the `initialize` method. In that method, you can add systems and entities to the scene.

### Add systems

To add a system to a scene, call the scene's `addSystem` method and pass in an instance of the system you want to add. You can add multiple systems at once using the `addSystems` method. Most systems can be initialized without any parameters, but some may require parameters.

	addSystem( LGPhysicsSystem() )

### Add entities

To add an entity to a scene, create the entity as an aggregation of components and use the `addEntity` method of the scene. To add components to an entity, use the entity's `put` method and pass in one or more component instances. (More information on creating components to be added).

	let player = LGEntity()
	player.put( LGPosition(x: 50, y: 200) )
	
	let playerSprite = LGSprite(textureName: "Player", rows: 1, cols: 9)
	player.put(playerSprite)

## Create a game

Subclass the base `LGGame` to create a game. This is essentially the state machine that holds the scenes for later. You can override the `createScenes` method to get started. In `createScenes`, pass in the class name and a name for the scene so you can call it back later. The first added scene will be loaded by default.

	override func createScenes()
	{
		addScene(MenuScene.self, named: "menu")
		addScene(LevelScene.self, named: "level")
	}

### All together

Here's what the scene should look like all together:

	class MyGame: LGGame
	{
		override func createScenes()
		{
			addScene(MyScene.self, named: "myScene")
		}
	}

	class MyScene: LGScene
	{
		override func initialize()
		{
			// Create and add systems
			
			self.addSystems(
				LGRenderingSystem(),
				LGCameraSystem(),
				LGPhysicsSystem()
			)
			
			// Create and add entities
			
			let player = LGEntity()
			player.put(
				LGPosition(x: 50, y: 200),
				LGSprite(textureName: "Player", rows: 1, cols: 9),
				LGPhysicsBody(width: 20, height: 35)
			)
			
			self.addEntity(player, named: "player")
		}
	}

## Start the engine

To start the engine, create an instance of your game in your project's app delegate. In the `application: didFinishLaunchingWithOptions` method of the app delegate, add this code:

	let viewController = MyGame()
	
	window = UIWindow(frame: UIScreen.mainScreen().bounds)
	window.rootViewController = viewController
	window.makeKeyAndVisible()

# How can I contribute?

Fork this repository and check out the [issues](https://github.com/thelukester92/swift-engine/issues) for this repository to see what's on the TODO list. Help and suggestions are always welcome!

# Where can I get more information?

* [The devblog for this engine.](http://devblog.lukesterwebdesign.com/)
* [Todos and known issues.](https://github.com/thelukester92/swift-engine/issues)
* [Wiki documentation.](https://github.com/thelukester92/swift-engine/wiki)
