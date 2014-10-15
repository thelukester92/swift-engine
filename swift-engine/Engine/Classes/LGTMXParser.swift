//
//  LGTMXParser.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/24/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

import UIKit

public class LGTMXParser: NSObject
{
	let firstBackgroundLayer	= -100
	let firstForegroundLayer	= 100
	
	// Setup variables
	var collisionLayerName	= "collision"
	var foregroundLayerName	= "foreground"
	
	// Variables that may be retrieved after parsing
	public var map: LGTileMap!
	public var collisionLayer: LGTileLayer!
	public var objects = [LGTMXObject]()
	
	// Variables for parsing
	var currentLayer: LGTileLayer!
	var currentObject: LGTMXObject!
	
	var currentRenderLayer: Int
	
	var currentElement		= ""
	var currentData			= ""
	var currentEncoding		= ""
	var currentCompression	= ""
	var currentPropName		= ""
	
	public override init()
	{
		currentRenderLayer = firstBackgroundLayer
	}
	
	public convenience init(filename: String, filetype: String = "tmx")
	{
		self.init()
		parseFile(filename, filetype: filetype)
	}
	
	public func addMapToTileSystem(system: LGTileSystem)
	{
		if map != nil
		{
			system.map = map
		}
	}
	
	public func addCollisionLayerToPhysicsSystem(system: LGPhysicsSystem)
	{
		if collisionLayer != nil
		{
			system.collisionLayer = collisionLayer
		}
	}
	
	public func addObjectsToScene(scene: LGScene)
	{
		for object in objects
		{
			if let entity = LGEntity.EntityFromTemplate(object.type)
			{
				entity.put(component: LGPosition(x: Double(object.x), y: Double(map.height * map.tileHeight) - Double(object.y + object.height)))
				
				// Properties unique to the entity
				for (type, serialized) in object.properties
				{
					if let component = LGDeserializer.deserialize(serialized, withType: type)
					{
						entity.put(component: component)
					}
					else
					{
						println("WARNING: Failed to deserialize a component of type '\(type)'")
					}
				}
				
				// Trigger, if not already a physics object
				if !entity.has(LGPhysicsBody) && object.width > 0 && object.height > 0
				{
					let body = LGPhysicsBody(width: Double(object.width), height: Double(object.height), dynamic: false)
					body.trigger = true
					
					entity.put(component: body)
				}
				
				scene.addEntity(entity, named: object.name)
			}
		}
	}
	
	public func parseFile(filename: String, filetype: String = "tmx")
	{
		let parser = NSXMLParser(contentsOfURL: NSBundle.mainBundle().URLForResource(filename, withExtension: filetype))
		parser.delegate = self
		parser.parse()
	}
	
	private func parseString(string: String, encoding: String, compression: String) -> [[LGTile]]
	{
		assert(encoding == "csv" || encoding == "base64",	"Encoding must be csv or base64!")
		assert(encoding != "csv" || compression == "",		"csv-encoded strings cannot be compressed!")
		assert(compression == "",							"Compression is not yet supported!")
		
		// TODO: add support for compression (probably zlib)
		
		if encoding == "csv"
		{
			// uncompressed csv
			
			let arr = string.componentsSeparatedByString(",")
			assert(arr.count == map.width * map.height)
			
			return parseArray(arr)
		}
		/* else if compression == "zlib"
		{
			// zlib compressed base64
			
			var uncompressedBuffer = [UInt8](count: Int(width * height * 4), repeatedValue: 0)
			var uncompressedLength: Int!
			
			let data = NSData(base64EncodedString: string, options: .Encoding64CharacterLineLength)
			let result = uncompress(&uncompressedBuffer, &uncompressedLength, data.bytes, data.length)
			
			assert(result == Z_OK)
			assert(uncompressedLength == width * height * 4)
			
			return parseData(uncompressedBuffer)
		} */
		else
		{
			// uncompressed base64
			
			let data = NSData(base64EncodedString: string, options: .IgnoreUnknownCharacters)
			assert(data.length == map.width * map.height * 4)
			
			var bytes = [UInt8](count: data.length, repeatedValue: 0)
			data.getBytes(&bytes, length: data.length)
			
			return parseData(bytes)
		}
	}
	
	private func parseArray(data: [String]) -> [[LGTile]]
	{
		var output = [[LGTile]]()
		
		for i in 0 ..< map.height
		{
			output.append([LGTile]())
			
			for j in 0 ..< map.width
			{
				let globalIdString = data[i * map.width + j].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
				let globalId: UInt32 = NSNumberFormatter().numberFromString(globalIdString)!.unsignedIntValue
				output[i].append(LGTile(gid: globalId))
			}
		}
		
		return output
	}
	
	private func parseData(data: [UInt8]) -> [[LGTile]]
	{
		var output = [[LGTile]]()
		var byteIndex = 0
		
		for i in 0 ..< map.height
		{
			output.append([LGTile]())
			
			for _ in 0 ..< map.width
			{
				let globalId = UInt32(data[byteIndex++] | data[byteIndex++] << 8 | data[byteIndex++] << 16 | data[byteIndex++] << 24)
				output[i].append(LGTile(gid: globalId))
			}
		}
		
		return output
	}
}

extension LGTMXParser: NSXMLParserDelegate
{
	public func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName: String!, attributes: NSDictionary!)
	{
		switch elementName.lowercaseString
		{
			case "map":
				map = LGTileMap(width: attributes["width"]!.integerValue, height: attributes["height"]!.integerValue, tileWidth: attributes["tilewidth"]!.integerValue, tileHeight: attributes["tileheight"]!.integerValue)
			
			case "image":
				// TODO: Allow multiple tilesets in a single map
				map.spriteSheet = LGSpriteSheet(textureName: attributes["source"] as String, frameWidth: map.tileWidth, frameHeight: map.tileHeight)
			
			case "layer":
				currentLayer = LGTileLayer(tileWidth: map.tileWidth, tileHeight: map.tileHeight)
				
				if let value = attributes["opacity"]?.doubleValue
				{
					currentLayer.opacity = value
				}
				
				if let value = attributes["visible"]?.boolValue
				{
					currentLayer.isVisible = value
				}
				
				if attributes["name"] as String == collisionLayerName
				{
					currentLayer.isCollision = true
					currentLayer.isVisible = false
					collisionLayer = currentLayer
				}
				
				if attributes["name"] as String == foregroundLayerName
				{
					currentRenderLayer = firstForegroundLayer
				}
				
				currentLayer.renderLayer = currentRenderLayer++
			
			case "data":
				if let value = attributes["encoding"] as? String
				{
					currentEncoding = value
				}
				
				if let value = attributes["compression"] as? String
				{
					currentCompression = value
				}
			
			case "object":
				currentObject = LGTMXObject(x: attributes["x"]!.integerValue, y: attributes["y"]!.integerValue)
				
				if let value = attributes["name"] as? String
				{
					currentObject.name = value
				}
				
				if let value = attributes["type"] as? String
				{
					currentObject.type = value
				}
				
				if let value = attributes["width"]?.integerValue
				{
					currentObject.width = value
				}
				
				if let value = attributes["height"]?.integerValue
				{
					currentObject.height = value
				}
			
			case "property":
				// TODO: allow custom properties in map, tile, and layer
				if currentObject != nil
				{
					let name = attributes["name"] as String
					
					if let value = attributes["value"] as? String
					{
						currentObject.properties[name] = value
					}
					
					currentPropName = name
				}
			
			// TODO: add case "objectgroup" if multiple object layers are desired
			default:
				break
		}
		
		// Save the current element for the parser(: foundCharacters:) method
		currentElement = elementName.lowercaseString
	}
	
	public func parser(parser: NSXMLParser!, foundCharacters string: String!)
	{
		if currentElement == "data"
		{
			currentData += string
		}
		
		if currentElement == "property"
		{
			currentData += string
		}
	}
	
	public func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName: String!)
	{
		switch elementName.lowercaseString
		{
			case "layer":
				map.add(currentLayer)
				currentLayer = nil
			
			case "data":
				// Reverse the rows for the right-handed coordinate system
				currentLayer.data	= parseString(currentData, encoding: currentEncoding, compression: currentCompression).reverse()
				currentData			= ""
				currentEncoding		= ""
				currentCompression	= ""
			
			case "object":
				objects.append(currentObject)
				currentObject = nil
			
			case "property":
				currentObject.properties[currentPropName] = currentData
				currentData = ""
				currentPropName = ""
			
			default:
				break
		}
	}
}
