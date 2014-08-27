package mytests {
	import bigp.tdd.TDNode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flashjam.basic.components.FJGraphic;
	import flashjam.basic.components.FJPhysics;
	import flashjam.basic.FJSprite;
	import flashjam.core.FJDoubleBuffer;
	import flashjam.core.geom.FJTransform;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestSprite extends TDNode {
		public static var COVERAGE:Array = [FJSprite, FJGraphic, FJPhysics];
		
		public function TestSprite() {
			super();
		}
		
		public function testSprite():void {
			var spr:FJSprite = new FJSprite();
			
			ASSERT_IS_NOT_NULL(spr);
			ASSERT_IS_NOT_NULL(spr.physics);
			ASSERT_IS_NOT_NULL(spr.transform);
			ASSERT_IS_NOT_NULL(spr.graphic);
			
			if (FJGraphic.IS_TEXTURES_AUTOCREATED) {
				ASSERT_IS_NOT_NULL(spr.graphic.texture);
			} else {
				ASSERT_IS_NULL(spr.graphic.texture);
			}
		}
		
		public function testGraphic():void {
			
			var dbl:FJDoubleBuffer = new FJDoubleBuffer(128, 128)
			stage.addChild(dbl.bitmap);
			
			ASSERT_IS_NOT_NULL(dbl);
			ASSERT_IS_NOT_NULL(dbl.bitmap);
			ASSERT_EQUAL(dbl.bitmap.width, 128);
			ASSERT_EQUAL(dbl.bitmap.height, 128);
			
			var g:FJGraphic = new FJGraphic();
			ASSERT_IS_NOT_NULL(g);
			
			if (FJGraphic.IS_TEXTURES_AUTOCREATED) {
				ASSERT_IS_NOT_NULL(g.texture);
			} else {
				ASSERT_IS_NULL(g.texture);
			}
			
			g.texture = new BitmapData(16, 16, true, 0xff00ff00);
			ASSERT_IS_NOT_NULL(g.texture);
			g.onDraw(null, dbl, new FJTransform(2, 2, 5, 5));
			
			dbl.swap();
		}
		
		public function testPhysics():void {
			
		}
	}
}