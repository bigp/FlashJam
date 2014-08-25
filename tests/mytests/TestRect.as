package mytests {
	import bigp.tdd.TDNode;
	import flashjam.core.geom.FJRect;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestRect extends TDNode {
		public static var COVERAGE:Class = FJRect;
		
		public function TestRect() {
			super();
			
		}
		
		public function testRect():void {
			var fjr:FJRect = new FJRect(10, 12, 20, 30);
			
			ASSERT_EQUAL(fjr.x, 10);
			ASSERT_EQUAL(fjr.y, 12);
			ASSERT_EQUAL(fjr.width, 20);
			ASSERT_EQUAL(fjr.height, 30);
		}
	}
}