package mytests {
	import bigp.tdd.TDNode;
	import flash.utils.getTimer;
	import flashjam.core.FJTime;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestTime extends TDNode {
		public static var COVERAGE:Class = FJTime;
		
		public function TestTime() {
			super();
			
		}
		
		public function testTime():void {
			var time:FJTime = new FJTime(getTimer());
			
			ASSERT_EQUAL(time.timeNow, time.timePrev);
			ASSERT_EQUAL(time.timeDiff, time.timeDiffMS * 0.001);
		}
	}
}