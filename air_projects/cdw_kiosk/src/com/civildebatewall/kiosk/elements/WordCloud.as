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

package com.civildebatewall.kiosk.elements {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.kiosk.buttons.WordButton;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class WordCloud extends BlockBase {
		
		public static const EVENT_WORD_SELECTED:String = "eventWordSelected";
		public static const EVENT_WORD_DESELECTED:String = "eventWordDeselected";		
		
		public var activeWord:WordButton;
		private var row1:Array;
		private var row2:Array;
		private var row3:Array;
		private var row4:Array;		
		private var wordButtons:Array = [];
		
		public function WordCloud()	{
			super();
			
			setParams({
				width: 1022,
				height: 299,
				backgroundColor: Assets.COLOR_GRAY_5
			});

			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataChange);
		}
		
		private function onDataChange(e:Event):void {
			setWords(CivilDebateWall.data.stats.frequentWords);			
		}
		
		public function setWords(source:Array):void {
			row1 = [];
			row2 = [];
			row3 = [];
			row4 = [];					
			
			// remove existing
			GraphicsUtil.removeChildren(this);

			var wordLimit:uint = 30; // too high?

			// sort the source words by frequency
			source.sortOn("total", Array.DESCENDING | Array.NUMERIC);
			
			// turn words into buttons
			wordButtons = [];
			
			for(var j:int = 0; j < Math.min(wordLimit, source.length); j++) {
				wordButtons.push(new WordButton(source[j]));			
			}
			
			// Now sort the shorter list of difference
			var wordButton:WordButton;
			var difference:Number;
			
			for (var i:int = 0; i < Math.min(wordLimit, wordButtons.length); i++) {
				wordButton = wordButtons[i];
				
				// raw yes - no difference, will get normalized later
				difference = wordButton.yesCases - wordButton.noCases; // higher number is more "yes", more left
				wordButton.difference = difference;				
			}
			
			// sort them by difference
			wordButtons = wordButtons.sortOn("difference", Array.DESCENDING | Array.NUMERIC);
			
			// do the fitting
			for (var k:int = 0; k < wordButtons.length - 4; k += 4) {
				row1.push(wordButtons[k]);
				row2.push(wordButtons[k + 1]);
				row3.push(wordButtons[k + 2]);
				row4.push(wordButtons[k + 3]);				
			}
			
			positionRow(row1, 1);
			positionRow(row2, 2);
			positionRow(row3, 3);
			positionRow(row4, 4);			
			
			// get the buttons that survived
			wordButtons = [];
			
			for (var p:int = 0; p < numChildren; p++) {
				wordButtons.push(getChildAt(p));
			}

			// NOW we have the final list of words, normalize
			// recalculate color based on new max and min
			// find limits	
			var maxDifference:Number = ArrayUtil.maxInObjectArray(wordButtons, "difference");
			var minDifference:Number = ArrayUtil.minInObjectArray(wordButtons, "difference");
			
			for each (wordButton in wordButtons) {
				// set the new difference and add listeners
				wordButton.normalDifference = Math2.map(wordButton.difference, minDifference, maxDifference, 0, 1);
				wordButton.updateColor();
				
				// also add listeners
				wordButton.onButtonDown.push(onDown);
			}			

			// Add gray boxes
			addGrayBoxes(row1);
			addGrayBoxes(row2);
			addGrayBoxes(row3);
			addGrayBoxes(row4);
			
			activeWord = null;
			
			// TODO some kind of weighting system to find out which row combinations make the most sense
			//words.push(new WordButton(wordInfo["word"], 
		}
		
		private function addGrayBoxes(row:Array):void {
			if (row.length > 0) {
				// leading box
				if (row[0].x > 15) {
					var grayBox:Shape = new Shape();
					grayBox.graphics.beginFill(Assets.COLOR_GRAY_20);
					grayBox.graphics.drawRect(0, row[0].y, row[0].x - 15, row[0].height);
					grayBox.graphics.endFill();
					addChild(grayBox);
				}
				
				// trailing box
				var lastIndex:int = row.length - 1;
				if ((row[lastIndex].x + row[lastIndex].width) < (this.width - 15)) {
					var grayBoxTrailing:Shape = new Shape();					
					grayBoxTrailing.graphics.beginFill(Assets.COLOR_GRAY_20);
					grayBoxTrailing.graphics.drawRect(row[lastIndex].x + row[lastIndex].width + 15, row[lastIndex].y, this.width - (row[lastIndex].x + row[lastIndex].width) - 15, row[lastIndex].height);
					grayBoxTrailing.graphics.endFill();
					addChild(grayBoxTrailing);
				}			
			}
		}
		
		private function onDown(e:MouseEvent):void {
			//fade everything else
			var selectedWord:WordButton = e.currentTarget as WordButton;
			
			// TODO dragable reselections
			if (selectedWord == activeWord) {
				// un-toggle
				deselect();
				this.dispatchEvent(new Event(EVENT_WORD_DESELECTED, true, true));			
			}			
			else {
				activeWord = selectedWord;
				
				for (var m:int = 0; m < wordButtons.length; m++) {
					if (wordButtons[m] != activeWord) {
						wordButtons[m].tween(0.5, {colorTransform: {tint: 0xffffff, tintAmount: 0.85}});
					}
					else {
						wordButtons[m].tween(0, {colorTransform: {tint: 0xffffff, tintAmount: 0}});						
					}
				}
				this.dispatchEvent(new Event(EVENT_WORD_SELECTED, true, true));				
			}
			
		}
		
		public function deselect():void {
			for (var n:int = 0; n < wordButtons.length; n++) {
				wordButtons[n].tween(0.5, {colorTransform: {tint: 0xffffff, tintAmount: 0}});
			}
			activeWord = null;
		}
		
		private function positionRow(row:Array, rowNumber:int):void {
			if (row.length > 0) {
				rowNumber--; // zero it
				var xAccumulator:Number = 0;
				
				for (var i:int = 0; i < row.length; i++) {
					if (!this.contains(row[i])) addChild(row[i]);				
					
					row[i].x = xAccumulator;
					xAccumulator += row[i].width + 15;
					row[i].y = (row[i].height + 15) * (rowNumber) + 15;
					row[i].visible = true;
				}

				if ((row[row.length - 1].x + row[row.length - 1].width) > (1022 - 30)) {
					removeChild(row.pop());
					positionRow(row, ++rowNumber);
				}
				else {
					// center it, we're done
					var xOffset:Number = (1022 - (row[row.length - 1].x + row[row.length - 1].width)) / 2;
					for (var j:int = 0; j < row.length; j++) {
						row[j].x += xOffset;
					}				
				}
			}
		}
		
	}
}
