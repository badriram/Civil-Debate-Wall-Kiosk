package com.civildebatewall {
	import com.civildebatewall.data.Post;
	import com.civildebatewall.data.TextMessage;
	import com.civildebatewall.data.Thread;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class State extends Object {
		
		public var activeView:Function;
		public var lastView:Function;
		
		public var lastThread:Thread = null;		
		public var activeThread:Thread = null;
		public var activePost:Post = null;		
		public var nextThread:Thread = null;
		public var previousThread:Thread = null;		
		public var threadOverlayOpen:Boolean = false;
		
		// for reloading
		public var activeThreadID:String = '';
		public var activePostID:String = '';		
		
		// scratch user... TODO wrap this up in the object?
		public var userStance:String = 'yes';
		public var userName:String = '';
		public var userOpinion:String = '';
		public var userPhoneNumber:String = '#########';
		public var userID:String = '';
		public var userImage:Bitmap = new Bitmap(new BitmapData(1080, 1920));
		public var userImageFull:Bitmap = null;		
		public var lastTextMessageTime:Date;
		public var textMessage:TextMessage; // the message we're working with
		public var userStanceText:String = ''; // add exclamation point		
		public var userRespondingTo:Post; // which post we're debating
		
		public var highlightWord:String = null;
		
		// color state
		public var userStanceColorLight:uint;
		public var userStanceColorMedium:uint;
		public var userStanceColorDark:uint;
		public var userStanceColorOverlay:uint;
		public var userStanceColorDisabled:uint;		
		
		public var activeComment:String = null;
		public var userIsResponding:Boolean = false; // true if we're entering a debate through the "let's debate" button
		
		public var questionTextColor:uint = 0xff0000;

 
		public function clearUser():void {
			userID = '';
			userName = '';
			userImage = new Bitmap(new BitmapData(1920, 1080));
			userPhoneNumber = '';
			userOpinion = '';
			userIsResponding = false;
			userImageFull = null;
			userRespondingTo = null;
			textMessage = null;
			lastTextMessageTime = null;
			//highlightWord = null;
		}
		
		public function setStance(s:String):void {
			userStance = s;
			
			userStanceText = userStance.toUpperCase() + '!';	
			
			if (userStance == 'yes') {
				userStanceColorLight = Assets.COLOR_YES_LIGHT;
				userStanceColorMedium = Assets.COLOR_YES_MEDIUM;
				userStanceColorDark = Assets.COLOR_YES_DARK;
				userStanceColorOverlay = Assets.COLOR_YES_OVERLAY;
				userStanceColorDisabled = Assets.COLOR_YES_DISABLED;
			}
			else {
				userStanceColorLight = Assets.COLOR_NO_LIGHT;
				userStanceColorMedium = Assets.COLOR_NO_MEDIUM;
				userStanceColorDark = Assets.COLOR_NO_DARK;
				userStanceColorOverlay = Assets.COLOR_NO_OVERLAY;
				userStanceColorDisabled = Assets.COLOR_NO_DISABLED;				
			}
		}
		
		
		public function setActiveDebate(thread:Thread, overridePrevious:Thread = null, overrideNext:Thread = null):void {
			lastThread = activeThread;
			activeThread = thread;
			
			// logs backwards... ugh
			
			
			CDW.dashboard.log('---------------------------------');			
			
			
			
			for (var i:uint = activeThread.posts.length - 1; i > 0; i--) {
				trace(i);
				CDW.dashboard.log(activeThread.posts[i].id);
			}
			CDW.dashboard.log(activeThread.posts[0].id);
			
			CDW.dashboard.log('Posts:');			
			CDW.dashboard.log("Active thread:\n\t" + activeThread.id);			
			
			CDW.dashboard.log('---------------------------------');			
			
			// funky overrides for big-jump transitions
			if (overridePrevious != null) {
				previousThread = overridePrevious; 
			}
			else {
				previousThread = CDW.data.getPreviousThread();
			}					
			
			if (overrideNext != null) {
				nextThread =overrideNext; 
			}
			else {
				nextThread = CDW.data.getNextThread();
			}

			trace("Prev: " + previousThread);
			trace("Active: " + activeThread);
			trace("Next: " + nextThread);
		}
		
		
		
		public function State()	{
		
		}
	}
}