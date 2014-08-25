package flashjam.core {
	import flash.utils.getTimer;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJTime {
		
		public var timePrevMS:int;
		public var timeNowMS:int;
		public var timeDiffMS:int;
		
		public var timePrev:Number;
		public var timeNow:Number;
		public var timeDiff:Number;
		public var frames:int;
		
		public function FJTime(pNow:int) {
			timeNowMS = timePrevMS = pNow;
			timeNow = timePrev = pNow * 0.001;
			timeDiff = timeDiffMS = 0;
		}
		
		public function update():void {
			timePrevMS = timeNowMS;
			timeNowMS = getTimer();
			timeDiffMS = timeNowMS - timePrevMS;
			
			timePrev = timeNow;
			timeNow = timeNowMS * 0.001;
			timeDiff = timeNow - timePrev;
			
			frames++;
		}
	}
}