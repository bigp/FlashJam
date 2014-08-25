package flashjam.core.geom {

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJPoint {
		
		public var x:Number = 0;
		public var y:Number = 0;
		
		public function FJPoint(pX:Number=0, pY:Number=0) {
			x = pX;
			y = pY;
		}
		
		[Inline]
		public function distanceQuick():Number {
			return x * x + y * y;
		}
		
		public function distance():Number {
			return Math.sqrt( distanceQuick() );
		}
	}
}