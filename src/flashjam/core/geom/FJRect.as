package flashjam.core.geom {
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJRect extends FJPoint {
		
		public var width:Number = 1;
		public var height:Number = 1;
		
		public function FJRect(pX:Number=0, pY:Number=0, pW:Number=1, pH:Number=1) {
			super(pX, pY);
			
			width = pW;
			height = pH;
		}
		
		public function copyToRect( pRect:Rectangle ):void {
			pRect.x = x;
			pRect.y = y;
			pRect.width = width;
			pRect.height = height;
		}
		
		public function get right():Number { return width + x; }
		public function get bottom():Number { return height + y; }
	}
}