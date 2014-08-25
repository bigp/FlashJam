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
			fj = new FJ(this);
			fj.whenDrawing.add(onDraw);
		}
		
		private function onDraw():void {
			fj.doubleBuffer.drawRect(new FJRect(Math.random() * 40, Math.random() * 40, 20, 20), 0xffff0000);
			fj.doubleBuffer.drawRect4( Math.random() * 10, Math.random() * 30, Math.random() * 100, Math.random() * 100, 0xff0000ff);
		}
	}
}