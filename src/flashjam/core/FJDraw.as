package flashjam.core {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flashjam.core.geom.FJRect;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJDraw {
		private var _helperFillRect:Rectangle;
		private var _bitmapData:BitmapData;
		
		public function FJDraw() {
			_helperFillRect = new Rectangle();
		}
		
		public function setCurrentBitmap( pBMP:BitmapData ):void {
			_bitmapData = pBMP;
		}
		
		public function drawRect( pRect:FJRect, pColor:uint ):void {
			pRect.copyToRect( _helperFillRect );
			_bitmapData.fillRect( _helperFillRect, pColor );
		}
		
		public function dispose():void {
			_helperFillRect = null;
			_bitmapData = null;
		}
	}
}