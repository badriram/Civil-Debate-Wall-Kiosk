package com.civildebatewall.staging.elements
{
	import com.civildebatewall.Assets;
	import com.civildebatewall.BitmapPlus;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Post;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	public class BalloonButton extends BlockBase {
		
		private var underlay:Bitmap;
		private var label:Bitmap;
		private var _targetPost:Post;
		
		public function BalloonButton(params:Object = null)	{
			super({width: 101, height: 109, backgroundAlpha: 0, buttonMode: true});
			
			underlay = Assets.getBalloonButtonBackground();
			addChild(underlay);
			
			label = Assets.getBalloonButtonText();
			label.x = 21;
			label.y = 32;
			addChild(label);
			
			setParams(params);
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
			onButtonCancel.push(onCancel);			
		}
		
		public function get targetPost():Post {
			return _targetPost;
		}
		
		public function set targetPost(post:Post):void {
			_targetPost = post;
			TweenMax.to(underlay, 0, {colorMatrixFilter:{colorize: _targetPost.stanceColorDark, amount: 1}});
		}
		
		public function onDown(e:MouseEvent):void {
			TweenMax.to(underlay, 0, {colorMatrixFilter:{colorize: _targetPost.stanceColorLight, amount: 1}});
		}
		
		public function onUp(e:MouseEvent):void {
			TweenMax.to(underlay, 0.5, {colorMatrixFilter:{colorize: _targetPost.stanceColorDark, amount: 1}});
			
			CivilDebateWall.state.userRespondingTo = _targetPost;
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.debateTypePickerView);
		}
		
		public function onCancel(e:MouseEvent):void {
			if (_targetPost != null) {
				TweenMax.to(underlay, 0.5, {colorMatrixFilter:{colorize: _targetPost.stanceColorDark, amount: 1}});
			}
		}

		
	}
}