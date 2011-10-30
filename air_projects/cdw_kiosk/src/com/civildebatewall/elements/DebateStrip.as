package com.civildebatewall.elements {
	import com.civildebatewall.*;
	import com.civildebatewall.blocks.BlockBase;
	import com.civildebatewall.ui.*;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	
	public class DebateStrip extends BlockBase {
		
		private var scrollField:InertialScrollField;
		private var activeThumbnail:ThumbnailButton;
		private var targetThumbnail:ThumbnailButton;		
		
		private var leftButton:Sprite;
		private var rightButton:Sprite;		
		
		public function DebateStrip()	{
			super();
			
			// overdraw for a more friendly hit-zone
			scrollField = new InertialScrollField(980, 140, InertialScrollField.SCROLL_X);
			scrollField.x = 50;
			
			
			scrollField.setBackgroundColor(0xff0000, 0.0);
			scrollField.addEventListener(InertialScrollField.EVENT_NOT_CLICK, onNotClick);
			
			// background strip
			scrollField.graphics.beginFill(0xffffff, 1.0);			
			scrollField.graphics.drawRect(0, 0, 980, 140);
			scrollField.graphics.endFill();
			
			// min and max get updated in update			
			addChild(scrollField);
			
			// buttons
			leftButton = new Sprite();
			leftButton.graphics.beginFill(0xffffff);
			leftButton.graphics.drawRect(0,0, 50, 140);
			leftButton.graphics.endFill();
			var leftCarat:Bitmap = Assets.getLeftCarat();
			leftButton.addChild(leftCarat);
			GeomUtil.centerWithin(leftCarat, leftButton);
			addChild(leftButton);
			
			rightButton = new Sprite();
			rightButton.graphics.beginFill(0xffffff);
			rightButton.graphics.drawRect(0,0, 50, 140);
			rightButton.graphics.endFill();
			var rightCarat:Bitmap = Assets.getRightCarat();
			rightButton.addChild(rightCarat);
			GeomUtil.centerWithin(rightCarat, rightButton);
			rightButton.x = 50 + 980;
			addChild(rightButton);			
			
		}
		
		public function update():void {
			// reads the state and builds the strip
			
			// Clean up the kids, could do a diff instead...
			GraphicsUtil.removeChildren(scrollField.scrollSheet);
			
			for (var i:uint = 0; i < CDW.data.threads.length; i++) {
				var threadThumbnail:ThumbnailButton = new ThumbnailButton(CDW.data.threads[i]);

				threadThumbnail.x = (threadThumbnail.width - 6) * i; // compensate for dots
				threadThumbnail.y = 0;
				
				threadThumbnail.addEventListener(MouseEvent.MOUSE_DOWN, onThumbnailMouseDown);
				threadThumbnail.addEventListener(MouseEvent.MOUSE_UP, onThumbnailMouseUp);				
				
				// remove the left dot from the first one
				if (i == 0) threadThumbnail.removeChild(threadThumbnail.leftDot);
				
				// remove the right dot from the last one				
				if (i == CDW.data.threads.length - 1) threadThumbnail.removeChild(threadThumbnail.rightDot);
				
				threadThumbnail.update();
				
				scrollField.scrollSheet.addChild(threadThumbnail);
			}
			
			// update the scroll field limits to acommodate the growing strip...
			scrollField.xMin = -scrollField.scrollSheet.width + scrollField.width;
			scrollField.xMax = 0; 	
		}
		
		
		public function setActiveThumbnail(id:String):void {
			
			for (var i:int = 0; i < scrollField.scrollSheet.numChildren; i++) {
				
				if (scrollField.scrollSheet.getChildAt(i) is ThumbnailButton) {
				
					var tempThumb:ThumbnailButton = scrollField.scrollSheet.getChildAt(i) as ThumbnailButton;
					
					// TODO use whole object?
					if (tempThumb.thread.id == id) {
						
						// deactivate the old on
						if (activeThumbnail != null) {			
							activeThumbnail.selected = false;
							activeThumbnail.setBackgroundColor(0xffffff);
							trace("deselecting: " + activeThumbnail);
						}
						
						// select the new one
						activeThumbnail = tempThumb;
						activeThumbnail.setBackgroundColor(activeThumbnail.downBackgroundColor);
						scrollField.scrollSheet.setChildIndex(activeThumbnail, scrollField.scrollSheet.numChildren - 1); // make sure the colored dots are on top
						activeThumbnail.selected = true;		
					
						break;
					}
					
				}			
			}
			
			scrollToActive();			
		}
		
		public function scrollToActive():void {
			var activeThumbnailX:Number = -activeThumbnail.x + ((1080 - activeThumbnail.width) / 2);
			
			// handle literal edge cases (don't scroll past bounds)
			activeThumbnailX = Math2.clamp(activeThumbnailX, scrollField.xMin, scrollField.xMax); 
			
			scrollField.scrollTo(activeThumbnailX, 0);
		}
		

		private function onThumbnailMouseDown(e:MouseEvent):void {
			targetThumbnail = e.currentTarget as ThumbnailButton;			
			targetThumbnail.setBackgroundColor(targetThumbnail.downBackgroundColor, true);
		}
		
		private var before:Boolean;
		
		private function onThumbnailMouseUp(e:MouseEvent):void {
			targetThumbnail = e.currentTarget as ThumbnailButton;

			if (scrollField.isClick) {
				trace("click");
				// go to opinion
				
				if (activeThumbnail != targetThumbnail) {
					//setActiveThumbnail(targetThumbnail.debateID);
					
					// is it to the left, or the right?
					before = targetThumbnail.x < activeThumbnail.x;
					
					if (CDW.state.threadOverlayOpen) {
						// go home, then transition
						CDW.view.homeView();
						TweenMax.delayedCall(1, finishTransition);
					}
					else {
						// get right to it
						finishTransition();
					}

				}
			}
			else {
				trace("not a click");
			}

			// Like nothing happened (unless it's active!)
			if (activeThumbnail != targetThumbnail) targetThumbnail.setBackgroundColor(0xffffff);			
		}
		
		private function finishTransition():void {
			// transition to it
			if (before) {
				CDW.state.setActiveDebate(CDW.state.activeThread, targetThumbnail.thread, CDW.state.nextThread);
				CDW.view.previousDebate();						
			}
			else {						
				CDW.state.setActiveDebate(CDW.state.activeThread, CDW.state.previousThread, targetThumbnail.thread);
				CDW.view.nextDebate();
			}			
		}
		
		
		private function onNotClick(e:Event):void {
			if (targetThumbnail != null) targetThumbnail.setBackgroundColor(0xffffff);			
		}		
		
	}
	
}