//
//  LGTMXParser.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/24/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import UIKit

class LGTMXParser: NSObject
{
	var map: LGTileMap!
	
	var collisionLayerName	= "collision"
	var foregroundLayerName	= "foreground"
	
	var collisionLayer: LGTileLayer!
	var currentLayer: LGTileLayer!
	var currentRenderLayer	= LGRenderLayer.Background
	var currentElement		= ""
	var currentData			= ""
	var currentEncoding		= ""
	var currentCompression	= ""
	
	var tileWidth	= 0
	var tileHeight	= 0
	var width		= 0
	var height		= 0
	
	init()
	{
		super.init()
	}
	
	func parseFile(filename: String, filetype: String = "tmx") -> LGTileMap
	{
		let parser = NSXMLParser(contentsOfURL: NSBundle.mainBundle().URLForResource(filename, withExtension: filetype))
		parser.delegate = self
		parser.parse()
		return map
	}
	
	
	func parseString(string: String, encoding: String, compression: String) -> [[LGTile]]
	{
		assert(encoding == "csv" || encoding == "base64",	"Encoding must be csv or base64!")
		assert(encoding != "csv" || compression == "",		"csv-encoded strings cannot be compressed!")
		assert(compression == "",							"Compression is not yet supported!")
		
		// TODO: add support for compression (probably zlib)
		
		if encoding == "csv"
		{
			// uncompressed csv
			
			let arr = string.componentsSeparatedByString(",")
			assert(arr.count == width * height)
			
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
			assert(data.length == width * height * 4)
			
			var bytes = [UInt8](count: data.length, repeatedValue: 0)
			data.getBytes(&bytes, length: data.length)
			
			return parseData(bytes)
		}
	}
	
	func parseArray(data: [String]) -> [[LGTile]]
	{
		var output = [[LGTile]]()
		
		for i in 0 ..< height
		{
			output += [LGTile]()
			
			for j in 0 ..< width
			{
				let globalId = UInt32(data[i * width + j].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).toInt()!)
				output[i] += LGTile(gid: globalId)
			}
		}
		
		return output
	}
	
	func parseData(data: [UInt8]) -> [[LGTile]]
	{
		var output = [[LGTile]]()
		var byteIndex = 0
		
		for i in 0 ..< height
		{
			output += [LGTile]()
			
			for _ in 0 ..< width
			{
				let globalId = UInt32(data[byteIndex++] | data[byteIndex++] << 8 | data[byteIndex++] << 16 | data[byteIndex++] << 24)
				output[i] += LGTile(gid: globalId)
			}
		}
		
		return output
	}
}

extension LGTMXParser: NSXMLParserDelegate
{
	func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName: String!, attributes: NSDictionary!)
	{
		currentElement = elementName.lowercaseString
		
		switch currentElement
		{
			case "map":
				tileWidth	= attributes["tilewidth"].integerValue
				tileHeight	= attributes["tileheight"].integerValue
				width		= attributes["width"].integerValue
				height		= attributes["height"].integerValue
				
				map = LGTileMap(width: width, height: height, tileWidth: tileWidth, tileHeight: tileHeight)
			
			case "image":
				// TODO: Allow multiple tilesets in a single map
				map.spriteSheet = LGSpriteSheet(textureName: attributes["source"] as String, frameWidth: tileWidth, frameHeight: tileHeight)
			
			case "layer":
				currentLayer = LGTileLayer(tileWidth: tileWidth, tileHeight: tileHeight)
				
				if let value = attributes["opacity"].doubleValue
				{
					currentLayer.opacity = value
				}
				
				if let value = attributes["visible"].boolValue
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
					currentRenderLayer = .Foreground
				}
				
				currentLayer.renderLayer = currentRenderLayer
			
			case "data":
				if let value = attributes["encoding"] as? String
				{
					currentEncoding = value
				}
				
				if let value = attributes["compression"] as? String
				{
					currentCompression = value
				}
			
			default:
				break
		}
	}
	
	func parser(parser: NSXMLParser!, foundCharacters string: String!)
	{
		if currentElement == "data"
		{
			currentData += string
		}
	}
	
	func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName: String!)
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
			
			default:
				break
		}
	}
}
