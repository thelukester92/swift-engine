//
//  LGTilemapParser.swift
//  swift-engine
//
//  Created by Luke Godfrey on 6/24/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

import UIKit

class LGTilemapParser: NSObject
{
	var map: LGTileMap!
	
	var collisionLayerName	= "collision"
	var foregroundLayerName	= "foreground"
	
	var currentLayer: LGTileLayer!
	var currentRenderLayer = LGRenderLayer.Background
	var currentElement = ""
	var currentData = ""
	
	var width = 0
	var height = 0
	
	init()
	{
		super.init()
	}
	
	func parseFile(filename: String) -> LGTileMap
	{
		let parser = NSXMLParser(contentsOfURL: NSURL(fileURLWithPath: filename))
		parser.delegate = self
		parser.parse()
		
		return map
	}
	
	func parseString(string: String) -> [[LGTile]]
	{
		// TODO: Support gzip or zlib for compression
		let data = NSData(base64EncodedString: string, options: .IgnoreUnknownCharacters)
		assert(data.length == width * height * 4)
		
		var bytes = [UInt8](count: data.length, repeatedValue: 0)
		data.getBytes(&bytes, length: data.length)
		
		return parseData(bytes)
	}
	
	/*
	commented until the bridging header includes zlib.h
	
	func parseString(string: String, encoding:String = "csv", compression: String = "") -> LGTile[][]()
	{
		assert(encoding == "csv" || encoding == "base64",	"Encoding must be csv or base64!")
		assert(encoding != "csv" || compression == "",		"csv-encoded strings cannot be compressed!")
		assert(compression == "" || compression == "zlib",	"Only zlib compression is supported!")
		
		if encoding == "csv"
		{
			let arr = string.componentsSeparatedByString(",")
			assert(arr.count == width * height)
			
			return parseArray(arr)
		}
		else if compression == "zlib"
		{
			// zlib compressed base64
			
			var uncompressedBuffer = UInt8[](count: Int(width * height * 4), repeatedValue: 0)
			var uncompressedLength: Int!
			
			let data = NSData(base64EncodedString: string, options: .Encoding64CharacterLineLength)
			let result = uncompress(&uncompressedBuffer, &uncompressedLength, data.bytes, data.length)
			
			assert(result == Z_OK)
			assert(uncompressedLength == width * height * 4)
			
			return parseData(uncompressedBuffer)
		}
		else
		{
			// uncompressed base64
			
			let data = NSData(base64EncodedString: string, options: .Encoding64CharacterLineLength)
			assert(data.length == width * height * 4)
			
			var bytes = UInt8[](count: data.length, repeatedValue: 0)
			data.getBytes(&bytes, length: data.length)
			
			return parseData(bytes)
		}
	}
	
	*/
	
	func parseArray(data: [String]) -> [[LGTile]]
	{
		var output = [[LGTile]]()
		
		for i in 0 ..< height
		{
			output += [LGTile]()
			
			for j in 0 ..< width
			{
				let globalId = UInt32(data[i * width + j].toInt()!)
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

extension LGTilemapParser: NSXMLParserDelegate
{
	func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName: String!, attributes: NSDictionary!)
	{
		currentElement = elementName.lowercaseString
		
		switch currentElement
		{
			case "map":
				var tileWidth = 0
				var tileHeight = 0
				
				if let value = attributes["width"] as? Int
				{
					width = value
				}
				
				if let value = attributes["height"] as? Int
				{
					height = value
				}
				
				if let value = attributes["tileWidth"] as? Int
				{
					tileWidth = value
				}
				
				if let value = attributes["tileheight"] as? Int
				{
					tileHeight = value
				}
				
				map = LGTileMap(width: width, height: height, tileWidth: tileWidth, tileHeight: tileHeight)
			
			case "image":
				// TODO: Allow multiple tilesets in a single map
				map.spriteSheet = LGSpriteSheet(textureName: attributes["source"] as String, rows: height, cols: width)
			
			case "layer":
				currentLayer = LGTileLayer()
				currentLayer.opacity = attributes["opacity"] as Double
				currentLayer.isVisible = attributes["visible"] as Bool
				
				if attributes["name"] as String == collisionLayerName
				{
					currentLayer.isCollision = true
					currentLayer.isVisible = false
				}
				
				if attributes["name"] as String == foregroundLayerName
				{
					currentRenderLayer = .Foreground
				}
				
				currentLayer.renderLayer = currentRenderLayer
			
			case "data":
				currentData = ""
			
			default:
				println() // can't have an empty default but must have a default... ugh
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
		switch currentElement
		{
			case "layer":
				map.add(currentLayer)
				currentLayer = nil
			
			case "data":
				currentLayer.data = parseString(currentData)
				currentData = ""
			
			default:
				println()
		}
	}
}