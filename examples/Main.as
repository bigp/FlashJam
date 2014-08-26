package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flashjam.basic.components.FJPhysics;
	import flashjam.basic.FJSprite;
	import flashjam.FJ;
	import flashjam.core.geom.FJRect;
	import flashjam.utils.Scaffold;
	
	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Main extends Sprite {
		private var fj:FJ;
		private var spr:FJSprite;
		
		public function Main():void {
			fj = new FJ(this, null, onReady);
			fj.whenWorldUpdated.add( onUpdate );
		}
		
		private function onReady():void {
			spr = new FJSprite();
			spr.transform.setXY( 10, 10 );
			fj.world.addChild( spr );
		}
		
		private function onUpdate():void {
			var thePhysics:FJPhysics = spr.physics;
			
			Scaffold.keysArrowsToPhysics( spr.physics );
		}
	}
}