package com.civildebatewall.blocks {
	import com.adobe.utils.StringUtil;
	import com.bit101.components.Text;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.text.*;
	
	import flashx.textLayout.elements.BreakElement;
	
	import com.civildebatewall.*;
	
	import sekati.layout.Arrange;
	
	// multi-line block text
	public class BlockParagraph extends BlockBase {
		
		protected var _textWidth:Number;
		protected var _text:String;
		protected var _textSize:Number;
		protected var _backgroundColor:uint;
		protected var _font:String;
		
		
		public var textField:TextField;
		protected var paddingTop:Number;
		protected var paddingRight:Number;
		protected var paddingBottom:Number;
		protected var paddingLeft:Number;	
		

		protected var _leading:Number;
		public var background:Shape;
		protected var highlightLayer:Shape;

		
		public function BlockParagraph(textWidth:Number, backgroundColor:uint, text:String, textSize:Number, textColor:uint = 0xffffff, textFont:String = null, leading:Number = 3) {
			if (textFont == null) {
				_font = Assets.FONT_REGULAR;
			}
			else {
				_font = textFont;
			}
			
			_leading = leading;			
			paddingTop = 17;
			paddingRight = 30;
			paddingBottom = 20;
			paddingLeft = 30;			
			
			_textWidth = textWidth - (paddingLeft + paddingRight);
			_text = text;
			_textSize = textSize;
			_backgroundColor = backgroundColor;

			
			
			init();
			
			
			
		}
		
		
		
		
		protected var highlightedString:String = '';
		private var _highlightColor:uint = 0x000000;
		
		protected var highlightPaddingTop:Number = 0;
		protected var highlightPaddingBottom:Number = 5;
		protected var highlightPaddingLeft:Number = 7;
		protected var highlightPaddingRight:Number = 8;
		
		
		private function highlightPosition(start:int, end:int):void {
			// add space to end
			var existingText:String = textField.text;
			var highlightArea:Rectangle = new Rectangle();
			
			// left bounds, string up to the highlighted word
			var onLine:int = textField.getLineIndexOfChar(start);
			var theLineText:String = textField.getLineText(onLine);
			var lineLeftIndex:int = textField.getLineOffset(onLine);
			
			var leftStringExclusive:String = theLineText.substring(0, start - lineLeftIndex);
			
			trace("leftStringExclusive: " + leftStringExclusive);
			
			textField.text = leftStringExclusive;
			
			var leftExclusiveMetrics:TextLineMetrics = textField.getLineMetrics(0);			

				highlightArea.x = leftExclusiveMetrics.x + leftExclusiveMetrics.width + paddingLeft;
				highlightArea.y = (leftExclusiveMetrics.height * onLine) + paddingTop;				

			
			// right bounds, string up to and including the highlighted word
			var leftStringInclusive:String = theLineText.substring(0, end - lineLeftIndex);
			
			trace("leftStringInclusive: " + leftStringInclusive);
			
			textField.text = leftStringInclusive;
			var leftInclusiveMetrics:TextLineMetrics = textField.getLineMetrics(0);
			highlightArea.width = (leftInclusiveMetrics.x + leftInclusiveMetrics.width + paddingLeft) - highlightArea.x;
			highlightArea.height = leftInclusiveMetrics.height;						
			
			trace("existingText: " + existingText);
			setText(existingText, true);
			
			trace("highlightArea", highlightArea);

			// apply padding
			highlightArea.y -= highlightPaddingTop;			
			highlightArea.x -= highlightPaddingLeft;
			highlightArea.width += highlightPaddingLeft + highlightPaddingRight;
			highlightArea.height += highlightPaddingTop + highlightPaddingBottom;
			
			// draw the hilite
			
			highlightLayer.graphics.beginFill(_highlightColor);
			highlightLayer.graphics.drawRect(highlightArea.x, highlightArea.y, highlightArea.width, highlightArea.height);
			highlightLayer.graphics.endFill();
		}
		
		public function setHighlightColor(c:uint):void {
			_highlightColor = c;
			setHighlight(highlightedString);
		}
		
		public function setHighlight(s:String):void {
			if (s.length > 0) {
				
				highlightedString = s;
				
				highlightLayer.graphics.clear();
				
				var locations:Array = Utilities.searchString(s, textField.text);
				
				// highlight each one...
				for (var i:int = 0; i < locations.length; i++) {
					highlightPosition(locations[i][0], locations[i][1]);
				}
			}
			else {
				clearHighlight();
			}
		}
		
		public function clearHighlight():void {
			highlightLayer.graphics.clear();
			highlightedString = '';
		}
		
		
		
		private function init():void {
			// set up the text format
			var textFormat:TextFormat = new TextFormat();			
			textFormat.font =  _font;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.size = _textSize;
			textFormat.leading = _leading;
			textFormat.letterSpacing = 0;
			
			// this is just to make sure line breaks are calculated reasonably
			// since Flash doesn't have line height control (just leading), there's no way
			// to center text vertically on its background. To get around this, we place the text on manually
			// drawn background shapes
			
      textField = new TextField();
			textField.defaultTextFormat = textFormat;
			textField.embedFonts = true;
			textField.selectable = false;
			textField.multiline = true;
			textField.cacheAsBitmap = false;
			textField.mouseEnabled = false;
			textField.gridFitType = GridFitType.NONE;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.textColor = 0xffffff;
			textField.width = _textWidth;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.wordWrap = true;
			textField.text = _text;
			
			//draw the background
			background = new Shape();
			
			drawBackground();
			
			highlightLayer = new Shape();
			
			addChild(background);
			addChild(highlightLayer);
			addChild(textField);			
			

			this.cacheAsBitmap = true;
		}
		
		public function setPadding(top:Number, right:Number, bottom:Number, left:Number):void {
			paddingTop = top;
			paddingRight = right;
			paddingBottom = bottom;
			paddingLeft = left;
			drawBackground();
		}		
		
		protected function drawBackground():void {
			background.graphics.clear();
			
			var yPos:Number = 0;			
			for (var i:int = 0; i < textField.numLines; i++) {
				var metrics:TextLineMetrics = textField.getLineMetrics(i);				
				
				
				background.graphics.beginFill(0xffffff); // white fill for manipulation by tweenmax			
				
				if (i == 0 || i == textField.numLines - 1) {
					// first or last line
					background.graphics.drawRect(0 - paddingLeft, yPos - paddingTop, Math.round(metrics.width) + paddingLeft + paddingRight, Math.round(metrics.height) + paddingTop + paddingBottom);
				}
				else {
					// middle line
					background.graphics.drawRect(0 - paddingLeft, yPos - paddingTop + 4, Math.round(metrics.width) + paddingLeft + paddingRight, Math.round(metrics.height) + paddingTop - 4 + paddingBottom);					
				}
				
				
				background.graphics.endFill();
				
				// actual color is set by tweenmax
				TweenMax.to(background, 0, {ease: Quart.easeInOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
				
				yPos += metrics.height;				
			}
			
			
			//background
			background.x = paddingLeft;
			background.y = paddingTop;
			
			textField.x =  paddingLeft;
			textField.y =  paddingTop;			
			
			background.cacheAsBitmap = true;
		}
		
		override public function setText(s:String, instant:Boolean = false):void {
			textField.text = s + ' '; // trailing space balances background
			drawBackground();
		}
		
		override public function setBackgroundColor(c:uint, instant:Boolean = false):void {
			_backgroundColor = c;
			TweenMax.to(background, 0, {ease: Quart.easeInOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});			
		}

	}
}