package mytests {
	import bigp.tdd.TDNode;
	import flashjam.core.geom.FJPoint;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestPoint extends TDNode {
		public static var COVERAGE:Class = FJPoint;
		
		public function TestPoint() {
			super();
			
		}
		
		public function testPoint():void {
			var fjp:FJPoint = new FJPoint(10, 20);
			
			ASSERT_EQUAL(fjp.x, 10);
			ASSERT_EQUAL(fjp.y, 20);
			ASSERT_EQUAL(fjp.distanceQuick(), 10 * 10 + 20 * 20);
			ASSERT_EQUAL(fjp.distance(), Math.sqrt( 10 * 10 + 20 * 20 ));
		}
	}
}