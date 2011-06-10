/**
 * Basic keyboard button
 */
package org.velluminous.keyboard
{	
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	public class KeyButton extends Sprite
	{
		/**
		 * character  
		 */
		private var letter:String;

		/**
		 * textfield
		 */
		private var label:TextField;

		/**
		 * touchable surface
		 */
		private var surface:Sprite;

		/**
		 * width
		 */
		private var w:Number;

		/**
		 * height
		 */
		private var h:Number;
		
		/**
		 * constructor
		 */
		public function KeyButton( letter:String, w:Number, h:Number )
		{
			super();
			this.letter = letter;
			this.w = w;
			this.h = h;
			createChildren();
		}
		
		/**
		 * create children
		 */
		private function createChildren():void
		{
			this.surface = new Sprite();
			this.render( false );
			
			this.addChild( surface );
			this.surface.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp );
			this.surface.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );
			this.surface.addEventListener( MouseEvent.MOUSE_OUT, handleMouseUpOutside );
			this.surface.addEventListener( MouseEvent.MOUSE_OVER, handleMouseDragOver );
			drawText();
		}
		
		/**
		 * draw the key surface
		 */
		public function render( on:Boolean ):void
		{
			this.surface.graphics.clear();
			if ( on )
			{
				this.surface.graphics.lineStyle( 2, 0xffffff );
				this.surface.graphics.beginFill( 0xffffff, 0.8 );
			}
			else
			{
				this.surface.graphics.lineStyle( 2, 0xffffff );
				this.surface.graphics.beginFill( 0x000000, 0.25 );
			}	
			
			this.surface.graphics.drawRect( 0, 0, w, h );
			this.surface.graphics.endFill(); 
		}
		
		/**
		 * draw the text
		 */
		private function drawText():void
		{
		
			 var format2:TextFormat	      = new TextFormat();
    //      	format2.font		      = Constants.FONT_FAMILY;
          	format2.color                = 0x000000;
          	format2.size                 = 18;//this.w * 0.275;
			format2.align = TextFormatAlign.CENTER;
//			format2.letterSpacing = Constants.FONT_LETTERSPACING; 
          	label  = new TextField();
			label.embedFonts = true;
			label.wordWrap = true;
			label.antiAliasType         = AntiAliasType.ADVANCED;
          	label.width = w
          	label.autoSize = TextFieldAutoSize.CENTER;
          	label.defaultTextFormat     = format2;
			label.text = this.letter;  
		    label.selectable = false;
			label.textColor = 0xffffff;
			surface.addChild(label);
			label.x = (w-label.width)/2;
			label.y = (h - label.height )/2;	
		}
		
		/**
		 * handle touch input
		 */
		private function handleMouseDown( e:MouseEvent ):void
		{
			//SoundManager.getInstance().playsound( SoundManager.KEYBOARD_PRESS );
			this.render( true );
			this.dispatchEvent( new KeyButtonEvent( KeyButtonEvent.PRESS, this.letter ) );
		}

		/**
		 * handle touch input
		 */
		private function handleMouseUp( e:MouseEvent ):void
		{
			this.render( false );
			this.dispatchEvent( new KeyButtonEvent( KeyButtonEvent.RELEASE, this.letter ) );
		}
		
		/**
		 * handle touch input
		 */
		private function handleMouseUpOutside( e:MouseEvent ):void
		{
			this.render( false );
		}
		
		/**
		 * 
		 */
		private function handleMouseDragOver( e:MouseEvent ):void
		{
			if ( e.buttonDown )
				this.render( true );
		}
	}
}