package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flashjam.FJ;
	import flashjam.core.geom.FJRect;
	
	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Main extends Sprite {
		private var fj:FJ;
		
		public function Main():void {
			fj = new FJ(this, onReady);
		}
		
		private function onReady():void {
			fj.drawer.drawRect(new FJRect(0, 0, 20, 20), 0xffff0000);
		}
	}
}