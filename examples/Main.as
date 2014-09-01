package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flashjam.basic.components.FJPhysics;
	import flashjam.basic.FJSprite;
	import flashjam.FJ;
	import flashjam.core.geom.FJRect;
	import flashjam.utils.Scaffold;
	import net.hires.debug.Stats;
	
	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Main extends Sprite {
		private var fj:FJ;
		private var spr:FJSprite;
		
		public var rHit:int = 0;
		public var spaceHit:int = 0;
		public var originaFPS:int;
		
		public function Main():void {
			fj = new FJ(this, null, onReady);
			fj.whenWorldUpdated.add( onUpdate );
		}
		
		private function onReady():void {
			spr = new FJSprite();
			spr.transform.setXY( 10, 10 );
			spr.hitbox.setSize( 50, 80, true );
			fj.world.addChild( spr );
			
			addChild( new Stats() );
			originaFPS = stage.frameRate;
		}
		
		private function onUpdate():void {
			var thePhysics:FJPhysics = spr.physics;
			
			Scaffold.keysArrowsToPhysics( spr.physics );
			
			if (fj.keys.isReleased(Keyboard.SPACE)) {
				stage.frameRate = 10;
				trace("SPACE " + (++spaceHit));
			} else if(fj.keys.isPressed(Keyboard.R)){
				stage.frameRate = originaFPS;
				trace("R " +  (++rHit));
			}
		}
	}
}