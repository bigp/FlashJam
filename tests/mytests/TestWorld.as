package mytests {
	import bigp.tdd.TDNode;
	import flash.display.BitmapData;
	import flash.utils.getTimer;
	import flashjam.core.FJChild;
	import flashjam.core.FJComponent;
	import flashjam.core.FJDraw;
	import flashjam.core.FJEntity;
	import flashjam.core.FJTime;
	import flashjam.core.FJWorld;
	import flashjam.objects.FJDirtyFlags;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestWorld extends TDNode {
		public static var COVERAGE:Class = FJWorld;
		
		public function TestWorld() {
			super();
			
		}
		
		public function testWorld():void {
			new FJDirtyFlags();
			
			var theWorld:FJWorld = new FJWorld();
			var child:FJEntity = new FJEntity();
			var time:FJTime = new FJTime(getTimer());
			var draw:FJDraw = new FJDraw();
			draw.setCurrentBitmap(new BitmapData(128, 128, true, 0xff888888));
			
			ASSERT_IS_NULL(theWorld.parent);
			ASSERT_IS_NOT_NULL(theWorld.transform);
			ASSERT_EQUAL(theWorld.transform.x, 0);
			ASSERT_EQUAL(theWorld.transform.y, 0);
			ASSERT_EQUAL(theWorld.transform.width, 1);
			ASSERT_EQUAL(theWorld.transform.height, 1);
			ASSERT_EQUAL(theWorld.numChildren, 0);
			
			theWorld.invalidate();
			ASSERT_EQUAL(theWorld.numChildren, 0);
			ASSERT_EQUAL(theWorld.totalChildren, 1);
			
			theWorld.addChild(child);
			theWorld.invalidate();
			
			ASSERT_EQUAL(theWorld.numChildren, 1);
			ASSERT_EQUAL(theWorld.totalChildren, 2);
			
			ASSERT_EQUAL(theWorld.update(time), 0);
			ASSERT_EQUAL(theWorld.draw(time, draw), 0);
			
			child.addComponent( new FJComponent(), TestWorld );
			
			ASSERT_EQUAL(theWorld.update(time), 0);
			theWorld.invalidate();
			
			ASSERT_EQUAL(theWorld.update(time), 1);
			ASSERT_EQUAL(theWorld.draw(time, draw), 1);
			
		}
	}
}