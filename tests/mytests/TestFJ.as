package mytests {
	import bigp.tdd.TDNode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.getTimer;
	import flashjam.core.FJDoubleBuffer;
	import flashjam.core.FJTime;
	import flashjam.core.geom.FJRect;
	import flashjam.FJ;
	import flashjam.objects.FJDirtyFlags;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestFJ extends TDNode {
		public static var COVERAGE:Array = [FJ, FJDoubleBuffer, FJTime];
		
		private var fj:FJ;
		
		public function TestFJ() {
			super();
			
		}
		
		public function testFJ():void {
			fj = new FJ(this, null, onReady);
		}
		
		private function onReady():void {
			ASSERT_IS_NOT_NULL(fj, "Check FJ");
			ASSERT_IS_NOT_NULL(fj.stage, "Check stage");
			ASSERT_IS_NOT_NULL(fj.view, "Check viewRect");
			ASSERT_IS_NOT_NULL(fj.whenUpdating, "Check whenUpdating");
			ASSERT_IS_NOT_NULL(fj.whenDrawing, "Check whenDrawing");
			ASSERT_EQUAL(fj.whenUpdating.numListeners, 0, "whenUpdating total");
			ASSERT_EQUAL(fj.whenDrawing.numListeners, 0, "whenDrawing total");
			ASSERT_EQUAL(fj.view.width, stage.stageWidth);
			
			ASSERT_IS_NOT_NULL(fj.doubleBuffer, "Check doubleBuffer");
			ASSERT_IS_NOT_NULL(fj.doubleBuffer.bitmap, "Check bitmap");
		}
		
		public function testDoubleBuffer():void {
			var bmp:Bitmap = new Bitmap();
			var dbl:FJDoubleBuffer = new FJDoubleBuffer(100, 100, bmp, false);
			
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
			
			var dbl:FJDoubleBuffer = new FJDoubleBuffer(128, 128, bmp, false);
			
			dbl.drawRect( new FJRect(4, 4, 10, 20), 0xffff0000 );
			ASSERT_NOT_EQUAL( bmp.bitmapData.getPixel(10, 10).toString(16), int(0xff0000).toString(16) );
			
			dbl.swap();
			ASSERT_EQUAL( bmp.bitmapData.getPixel(10, 10).toString(16), int(0xff0000).toString(16) );
			
			bmp.bitmapData.dispose();
			stage.removeChild(bmp);
		}
		
		public function testTime():void {
			var time:FJTime = new FJTime(getTimer());
			
			ASSERT_EQUAL(time.timeNow, time.timePrev);
			ASSERT_EQUAL(time.timeDiff, time.timeDiffMS * 0.001);
		}
	}
}