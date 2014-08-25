package mytests {
	import bigp.tdd.TDNode;
	import flashjam.core.geom.FJPoint;
	import flashjam.core.geom.FJRect;
	import flashjam.core.geom.FJTransform;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestGeom extends TDNode {
		public static var COVERAGE:Array = [FJPoint, FJRect, FJTransform];
		
		public function TestGeom() {
			super();
			
		}
		
		public function testPoint():void {
			var point:FJPoint = new FJPoint(10, 20);
			
			ASSERT_EQUAL(point.x, 10);
			ASSERT_EQUAL(point.y, 20);
			ASSERT_EQUAL(point.distanceQuick(), 10 * 10 + 20 * 20);
			ASSERT_EQUAL(point.distance(), Math.sqrt( 10 * 10 + 20 * 20 ));
		}
		
		public function testRect():void {
			var rect:FJRect = new FJRect(10, 12, 20, 30);
			
			ASSERT_EQUAL(rect.x, 10);
			ASSERT_EQUAL(rect.y, 12);
			ASSERT_EQUAL(rect.width, 20);
			ASSERT_EQUAL(rect.height, 30);
		}
		
		public function testTransform():void {
			var trans:FJTransform = new FJTransform(10, 12, 20, 30);
			
			ASSERT_EQUAL(trans.x, 10);
			ASSERT_EQUAL(trans.y, 12);
			ASSERT_EQUAL(trans.width, 20);
			ASSERT_EQUAL(trans.height, 30);
		}
	}
}