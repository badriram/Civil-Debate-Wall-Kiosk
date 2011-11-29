package com.kitschpatrol.flashspan {
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	public class Settings extends Object {
		// This file modified significantly for CivilDebateWall
		
		// A collection of settings. These can be set manually or are loaded from an XML file
		public static const SERVER_AUTO:String = "auto";
		public static const SYNC_FRAMES:String = "frame";
		public static const SYNC_TIME:String = "time";
		
		public var totalWidth:int;
		public var totalHeight:int;
		public var server:String;
		public var syncMode:String;
		public var physicalScreenWidth:int;
		
		public var screenWidth:int; // from xml
		public var screenHeight:int; // from xml
		public var screenCount:int; // from xml
		public var bezelWidth:int; // from xml
		
		public var screens:Vector.<NetworkedScreen>;
		public var bezels:Vector.<Rectangle>;
		
		public var thisScreen:NetworkedScreen; // reference...		
		
		public function Settings() {
			// Constructor
		}
		
		
		public function load(filePath:String):void {
			// load text file
			trace(filePath);
			var file:File = new File(filePath);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			
			var fileContents:String = fileStream.readUTFBytes(fileStream.bytesAvailable); // Read the contens of the 
			fileStream.close(); // Clean up and close the file stream			
			
			// parse the xml
			var xml:XML = new XML(fileContents);	
			
			// Global Settings
			for each (var setting:XML in xml.children()) {
				var key:String = setting.localName();
				var value:Object = setting.valueOf();
				
				if ((key != "networkMap") && this.hasOwnProperty(key)) {
					this[key] = value;
				}
			}
			
			
						
			
			screenCount = xml.networkMap.children().length();
			
			screens = new Vector.<NetworkedScreen>(screenCount);			
			for each (var screenSettings:XML in xml.networkMap.children()) {
				// NetworkedScreen constructor parses xml
				screens[screenSettings.id] = new NetworkedScreen(screenSettings);
			}
			
			// fill in other variables
			
			totalWidth = (screenWidth * screenCount) + (bezelWidth * 2 * (screenCount - 1));
			totalHeight = screenHeight;
			physicalScreenWidth = screenWidth + (bezelWidth * 2);			

			
			// then populate with calculated variables
			for (var i:int = 0; i < screenCount; i++) {
				screens[i].x = (i * screenWidth) + (i * 2 * bezelWidth);
				screens[i].y = 0;
				screens[i].width = screenWidth;
				screens[i].height = screenHeight;			
			}			
			

			// generate bezels			
			bezels = new Vector.<Rectangle>;
			
			for (var j:int = 0; j < screenCount; j++) {
				trace(j);
				if (j > 0) {
					bezels.push(new Rectangle(screens[j].x - bezelWidth, 0, bezelWidth, screenHeight)); // Left bezel
				}
				
				if (j < (screens.length - 1)) {
					bezels.push(new Rectangle(screens[j].x + screens[j].width, 0, bezelWidth, screenHeight)); // Right bezel
				}
			}			
			
			
			MonsterDebugger.trace(this, this);
		}
		
		public function setMyID(id:int):void {
			thisScreen = screens[id];
		}
		
		// find a networked screen that matches certain network values
		public function getScreenByIP(ip:String, port:int):NetworkedScreen {
			for (var i:int = 0; i < screens.length; i++) {
				if ((screens[i].ip == ip) && (screens[i].port == port)) {
					return screens[i];
				}
			}
			return null;			
		}
	}
}