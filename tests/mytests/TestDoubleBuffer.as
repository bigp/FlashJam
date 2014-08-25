package mytests {
	import bigp.tdd.TDNode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flashjam.core.FJDoubleBuffer;
	import flashjam.core.geom.FJRect;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestDoubleBuffer extends TDNode {
		public static var COVERAGE:Class = FJDoubleBuffer;
		public function TestDoubleBuffer() {
			super();
			
			//TDNode.LOG_ONLY_IF_FAILED = false;
		}
		
		public function testDoubleBuffer():void {
			var bmp:Bitmap = new Bitmap();
			var dbl:FJDoubleBuffer = new FJDoubleBuffer(bmp, 100, 100, false);
			
			stage.addChild(dbl.bitmap);
			
			ASSERT_IS_NOT_NULL(dbl, "Check doubleBuffer");
			ASSERT_IS_NOT_NULL(dbl.bitmap.bitmapData, "Has a bitmapData");
			ASSERT_IS_NOT_NULL(dbl.getBackBuffer(), "Check backbuffer");
			
			dbl.swap();
			
			var testBMP:BitmapData = new BitmapData(24, 24, false, 0xffffffff);
			
			dbl.getBackBuffer().setPixel(10, 10, 0x220000);
			testBMP.draw(stage);
			ASSERT_NOT_EQUAL(testBMP.getPixel(10, 10), 0x220000);
			dbl.swap();
			testBMP.draw(stage);
			ASSERT_EQUAL(testBMP.getPixel(10, 10), 0x220000);
			dbl.getBackBuffer().setPixel(5, 5, 0x330000);
			testBMP.draw(stage);
			ASSERT_NOT_EQUAL(bmp.bitmapData.getPixel(5, 5), 0x330000);
			dbl.swap();
			ASSERT_EQUAL(bmp.bitmapData.getPixel(5, 5), 0x330000);
			
			testBMP.dispose();
			dbl.dispose();
			
			ASSERT_IS_NULL(dbl.bitmap);
			ASSERT_IS_NULL(dbl.getBackBuffer());
		}
		
		public function testDraw():void {
			var bmp:Bitmap = new Bitmap();
			stage.addChild(bmp);
			
			var dbl:FJDoubleBuffer = new FJDoubleBuffer(bmp, 128, 128, false);
			
			dbl.drawRect( new FJRect(4, 4, 10, 20), 0xffff0000 );
			ASSERT_NOT_EQUAL( bmp.bitmapData.getPixel(10, 10).toString(16), int(0xff0000).toString(16) );
			
			dbl.swap();
			ASSERT_EQUAL( bmp.bitmapData.getPixel(10, 10).toString(16), int(0xff0000).toString(16) );
			
			bmp.bitmapData.dispose();
			stage.removeChild(bmp);
		}
	}
}