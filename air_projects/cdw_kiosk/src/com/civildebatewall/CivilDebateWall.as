package com.civildebatewall {
	import com.adobe.crypto.SHA1;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.kiosk.buttons.*;
	import com.civildebatewall.kiosk.camera.*;
	import com.civildebatewall.kiosk.core.Kiosk;
	import com.civildebatewall.kiosk.elements.*;
	import com.civildebatewall.kiosk.keyboard.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.kitschpatrol.futil.tweenPlugins.BackgroundColorPlugin;
	import com.kitschpatrol.futil.tweenPlugins.FutilBlockPlugin;
	import com.kitschpatrol.futil.tweenPlugins.NamedXPlugin;
	import com.kitschpatrol.futil.tweenPlugins.NamedYPlugin;
	import com.kitschpatrol.futil.tweenPlugins.TextColorPlugin;
	import com.kitschpatrol.futil.utilitites.PlatformUtil;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.Mouse;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	// Main entry point for the app.
	// Manages display of Interactive Kiosk and Wallsaver modes.
	public class CivilDebateWall extends Sprite	{

		
		public static var data:Data;
		public static var state:State;
		public static var settings:Object;
		public static var self:CivilDebateWall;
		
		public static var kiosk:Kiosk;
		public static var dashboard:Dashboard;
		
		public static var inactivityTimer:InactivityTimer;		
		
		private var commandLineArgs:Array;
		
		public function CivilDebateWall(commandLineArgs:Array = null)	{
			self = this;
			this.commandLineArgs = commandLineArgs;
			
			// Greensock plugins
			TweenPlugin.activate([ThrowPropsPlugin]);			
			TweenPlugin.activate([CacheAsBitmapPlugin]);	
			TweenPlugin.activate([TransformAroundCenterPlugin]);
			TweenPlugin.activate([TransformAroundPointPlugin]);	

			// Futil plugins
			TweenPlugin.activate([FutilBlockPlugin]);
			
			// Work around for lack of mouse-down events
			// http://forums.adobe.com/message/2794098?tstart=0
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;			
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
			
			// load settings from a local JSON file			
			settings = Settings.load();
			
			// if we're running in local multi-screen debug mode, we will receive certain command line args
			// these can ovveride settings
			// TODO genereic command line settings override system?
			if (commandLineArgs.length > 0) {
				settings.kioskNumber = commandLineArgs[0];
				settings.localMultiScreenTest = true;
				settings.useSLR = false;
				settings.useWebcam = false;
			}
			
			// set up the stage
			stage.quality = StageQuality.BEST;

			
			// temporarily squish screen for laptop development (half size)
			if (settings.halfSize) {
				stage.scaleMode = StageScaleMode.EXACT_FIT;
				stage.nativeWindow.width = 540;
				stage.nativeWindow.height = 960;
			}
			else {
				// in this case, window dimensions are defined in app.xml
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP;
			}
			
			// make sure image folders exist
			if (PlatformUtil.isWindows) {
				Utilities.createFolderIfNecessary(settings.imagePath);
				Utilities.createFolderIfNecessary(settings.tempImagePath);				
			}
			else if (PlatformUtil.isMac) {
				Utilities.createFolderIfNecessary(settings.imagePath);
			}
			
			// fill the background
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			// set up gui overlay TODO move to window
			dashboard = new Dashboard();
			dashboard.visible = true;
			
			
			if (settings.halfSize) {
				dashboard.scaleX = 2;
				dashboard.scaleY = 2;
			}
			
			// Set the custom context menu
			contextMenu = Menu.getMenu();
			
			if (settings.startFullScreen)	toggleFullScreen();
			
			// inactivity timer
			inactivityTimer = new InactivityTimer(stage, settings.inactivityTimeout);
			inactivityTimer.addEventListener(InactivityEvent.INACTIVE, onInactive);			
			

			
			// load the wall data
			data = new Data();
			
			// create local state
			state = new State();
			
			kiosk = new Kiosk();
			addChild(kiosk);
			
			// TODO create wallsaver
			
			// Load the data, which fills up everything through binding callbacks
			data.load();			
			
			// dashboard goes on top... or add when active? 
			addChild(dashboard);
			
		}
		

	
		
		
		
		
		private function onInactive(e:InactivityEvent):void {
			trace("inactive!");
			//view.inactivityOverlayView();
		}		
		
		
		public function toggleFullScreen():void {		
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				Mouse.hide();
			}
			else {
				stage.displayState = StageDisplayState.NORMAL;
				Mouse.show();
			}		
		}
		
		
		
	}
}