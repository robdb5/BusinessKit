package com.flashsupport.video {

	import fl.video.FLVPlayback;
	import flash.geom.ColorTransform;
	import com.flashsupport.video.BackgroundBox;
	
	public class FLVPlaybackPro4 extends FLVPlayback {
		
		private var __background:BackgroundBox;
		private var __bgColor:uint;
		
		public function FLVPlaybackPro4(){
			super();
			background = true;
		}		
		
		public function set background(active:Boolean):void {
			if(active){
				var color:uint = !isNaN(backgroundColor) ? backgroundColor : 0x000000;
				__background = new BackgroundBox(this, color);
			} else {
				removeChild(__background);
			}			
		}
		
		public function get background():Boolean {
			return (__background != null);
		}
		
		public function set backgroundColor(color:uint):void {
			__bgColor = color;
			if(__background != null){
				var ct:ColorTransform = new ColorTransform();
				ct.color = color;
				__background.transform.colorTransform = ct;
			}
		}
		
		public function get backgroundColor():uint {
			return __bgColor;
		}
		
	}	
}