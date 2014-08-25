package mytests {
	import bigp.tdd.TDNode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flashjam.core.FJDraw;
	import flashjam.core.geom.FJRect;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestDraw extends TDNode {
		public static var COVERAGE:Class = FJDraw;
		
		public function TestDraw() {
			super();
			
		}
		
		public function testDraw():void {
			var bmp:Bitmap = new Bitmap(new BitmapData(128, 128, true, 0xff000000) );
			stage.addChild(bmp);
			
			var drawer:FJDraw = new FJDraw();
			drawer.setCurrentBitmap( bmp.bitmapData );
			drawer.drawRect( new FJRect(4, 4, 10, 20), 0xffff0000 );
			
			ASSERT_EQUAL( bmp.bitmapData.getPixel(10, 10), 0xff0000 );
			
			bmp.bitmapData.dispose();
			stage.removeChild(bmp);
		}
	}
}