package com.civildebatewall.kiosk.ui {
	import com.civildebatewall.*;
	import com.civildebatewall.kiosk.blocks.BlockLabel;
	import com.civildebatewall.data.Word;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import fl.motion.Color;
	
	
	public class WordButton extends BlockLabel {
		public var difference:Number;		
		public var normalDifference:Number;
		private var _posts:Array;
		private var interpolatedColor:uint;
		public var word:Word; // keep the word reference
		public var yesCases:Number;
		public var noCases:Number;		
		
		public function WordButton(_word:Word, textSize:Number = 34, textColor:uint=0xffffff, backgroundColor:uint=0x000000, font:String=null, showBackground:Boolean=true)	{
			word = _word;
			normalDifference = word.normalDifference;
			_posts = word.posts;
			font = Assets.FONT_REGULAR;
			
			yesCases = word.yesCases;			
			noCases = word.noCases;			

			super(StringUtil.capitalize(word.word), textSize, textColor, backgroundColor, font, showBackground);
			
			// set background color

			this.setPadding(14, 15, 10, 15);
			
			updateColor();
		}
		
		public function updateColor():void {
			interpolatedColor = BitmapUtil.getPixelAtNormal(Assets.wordCloudGradient, normalDifference, 0);
			this.setBackgroundColor(interpolatedColor, true);			
		}
		
	}
}