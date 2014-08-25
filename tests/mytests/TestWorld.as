package mytests {
	import bigp.tdd.TDNode;
	import flashjam.core.FJChild;
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
			var child:FJChild = new FJChild();
			
			ASSERT_IS_NULL(theWorld.parent);
			ASSERT_IS_NOT_NULL(theWorld.transform);
			ASSERT_EQUAL(theWorld.transform.x, 0);
			ASSERT_EQUAL(theWorld.transform.y, 0);
			ASSERT_EQUAL(theWorld.transform.width, 1);
			ASSERT_EQUAL(theWorld.transform.height, 1);
			ASSERT_EQUAL(theWorld.numChildren, 0);
			
			theWorld.invalidate();
			ASSERT_EQUAL(theWorld.numChildren, 0);
			ASSERT_EQUAL(theWorld.childrenTotal, 1);
			
			theWorld.addChild(child);
			theWorld.invalidate();
			
			ASSERT_EQUAL(theWorld.numChildren, 1);
			ASSERT_EQUAL(theWorld.childrenTotal, 2);
		}
	}
}