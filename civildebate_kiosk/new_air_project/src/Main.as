package {
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import com.civildebatewall.*;
	import com.civildebatewall.blocks.*;
	import com.civildebatewall.camera.*;
	import com.civildebatewall.elements.*;
	import com.civildebatewall.keyboard.*;
	import com.civildebatewall.ui.*;
	
	
	//import com.demonsters.debugger.MonsterDebugger;	
	
	[SWF(width="1080", height="1920", frameRate="60")]
	public class Main extends Sprite	{
		
		public function Main() {
			
			//MonsterDebugger.initialize(this);
			//MonsterDebugger.trace(this, "Hello World!");			
			
			var civilDebateWall:CDW = new CDW();
			addChild(civilDebateWall);
		}
	}
}
