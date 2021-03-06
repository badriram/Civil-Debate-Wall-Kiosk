/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.wallsaver.sequences {

	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.wallsaver.elements.ArrowBanner;
	import com.civildebatewall.wallsaver.sequences.ISequence;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class CallToActionSequence extends Sprite implements ISequence {
	
		private const arrowWidth:int = 296;
		private const arrowHeight:int = 1674;		
		
		private var joinBanner1:ArrowBanner;
		private var touchBanner1:ArrowBanner;
		private var joinBanner2:ArrowBanner;
		private var touchBanner2:ArrowBanner;
		
		public function CallToActionSequence() {
			super();
			
			var yOffset:Number = 123;
			
			// build the banners and their masks. Skip the first screen.
			
			// extra few pixels of width fights anti aliasing
			joinBanner1 = new ArrowBanner(1080, arrowWidth, arrowHeight, Assets.COLOR_YES_LIGHT, ArrowBanner.RIGHT);
			joinBanner1.addChild(Assets.getJoinTheDebateText());
			GeomUtil.centerWithin(joinBanner1.getChildAt(0));
			
			var screen2Mask:Shape = GraphicsUtil.shapeFromRect(CivilDebateWall.flashSpan.settings.screens[1]);
			
			addChild(joinBanner1);
			addChild(screen2Mask);
			joinBanner1.mask = screen2Mask;
			joinBanner1.y = yOffset;
			
			touchBanner1 = new ArrowBanner(1080, arrowWidth, arrowHeight, Assets.COLOR_NO_LIGHT, ArrowBanner.RIGHT);
			touchBanner1.addChild(Assets.getTouchToBeginText());
			GeomUtil.centerWithin(touchBanner1.getChildAt(0));			

			var screen3Mask:Shape = GraphicsUtil.shapeFromRect(CivilDebateWall.flashSpan.settings.screens[2]);
			
			addChild(touchBanner1);
			addChild(screen3Mask);
			touchBanner1.mask = screen3Mask;
			touchBanner1.y = yOffset;			
			
			joinBanner2 = new ArrowBanner(1080, arrowWidth, arrowHeight, Assets.COLOR_YES_LIGHT, ArrowBanner.RIGHT);
			joinBanner2.addChild(Assets.getJoinTheDebateText());
			GeomUtil.centerWithin(joinBanner2.getChildAt(0));
			var screen4Mask:Shape = GraphicsUtil.shapeFromRect(CivilDebateWall.flashSpan.settings.screens[3]);
			
			addChild(joinBanner2);
			addChild(screen4Mask);
			joinBanner2.mask = screen4Mask;
			joinBanner2.y = yOffset;	
			
			touchBanner2 = new ArrowBanner(1080, arrowWidth, arrowHeight, Assets.COLOR_NO_LIGHT, ArrowBanner.RIGHT);
			touchBanner2.addChild(Assets.getTouchToBeginText());
			GeomUtil.centerWithin(touchBanner2.getChildAt(0));						
			var screen5Mask:Shape = GraphicsUtil.shapeFromRect(CivilDebateWall.flashSpan.settings.screens[4]);
			
			addChild(touchBanner2);
			addChild(screen5Mask);
			touchBanner2.mask = screen5Mask;			
			touchBanner2.y = yOffset;
		}
		
		public function getTimelineIn():TimelineMax	{
			return null;
		}
		
		public function getTimelineOut():TimelineMax {
			return null;
		}
		
		public function getTimeline():TimelineMax	{
			var timeline:TimelineMax = new TimelineMax({useFrames: true});
			
			// join banners in
			timeline.appendMultiple([				
				TweenMax.fromTo(joinBanner1, 100, {x: CivilDebateWall.flashSpan.settings.screens[1].x - joinBanner1.width}, {x: CivilDebateWall.flashSpan.settings.screens[1].x - arrowWidth, ease: Quart.easeOut, roundProps: ["x"]}),
				TweenMax.fromTo(joinBanner2, 100, {x: CivilDebateWall.flashSpan.settings.screens[3].x - joinBanner2.width}, {x: CivilDebateWall.flashSpan.settings.screens[3].x - arrowWidth, ease: Quart.easeOut, roundProps: ["x"]})
			], 50, TweenAlign.START, 0);
			
			
			// join banners out, touch banners in
			timeline.appendMultiple([
				TweenMax.to(joinBanner1, 100, {x: CivilDebateWall.flashSpan.settings.screens[1].x + CivilDebateWall.flashSpan.settings.screens[1].width, ease: Quart.easeInOut, roundProps: ["x"]}),
				TweenMax.fromTo(touchBanner1, 100, {x: CivilDebateWall.flashSpan.settings.screens[2].x - touchBanner1.width}, {x: CivilDebateWall.flashSpan.settings.screens[2].x - arrowWidth, ease: Quart.easeInOut, roundProps: ["x"]}),				
				TweenMax.to(joinBanner2, 100, {x: CivilDebateWall.flashSpan.settings.screens[3].x + CivilDebateWall.flashSpan.settings.screens[3].width, ease: Quart.easeInOut, roundProps: ["x"]}),
				TweenMax.fromTo(touchBanner2, 100, {x: CivilDebateWall.flashSpan.settings.screens[4].x - touchBanner1.width}, {x: CivilDebateWall.flashSpan.settings.screens[4].x - arrowWidth, ease: Quart.easeInOut, roundProps: ["x"]})
			], 150, TweenAlign.START, 0);			
			
			
			// touch banners out
			timeline.appendMultiple([
				TweenMax.to(touchBanner1, 100, {x: CivilDebateWall.flashSpan.settings.screens[2].x + CivilDebateWall.flashSpan.settings.screens[2].width, ease: Quart.easeIn, roundProps: ["x"]}),
				TweenMax.to(touchBanner2, 100, {x: CivilDebateWall.flashSpan.settings.screens[4].x + CivilDebateWall.flashSpan.settings.screens[4].width, ease: Quart.easeIn, roundProps: ["x"]}),
			], 150, TweenAlign.START, 0);
			
			return timeline;
		}
		
	}
}
