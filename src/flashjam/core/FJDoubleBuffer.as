package flashjam.core {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flashjam.interfaces.IDisposable;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJDoubleBuffer implements IDisposable {
		
		private var _frontBuffer:BitmapData;
		private var _backBuffer:BitmapData;
		public var bitmap:Bitmap;
		
		public function FJDoubleBuffer(pBitmap:Bitmap, pWidth:int, pHeight:int, pTransparent:Boolean=true) {
			bitmap = pBitmap;
			
			_frontBuffer = createBMP(pWidth, pHeight, pTransparent);
			_backBuffer = createBMP(pWidth, pHeight, pTransparent, true);
			
			bitmap.bitmapData = _frontBuffer;
		}
		
		private function createBMP(pWidth:int, pHeight:int, pTransparent:Boolean, pLock:Boolean=false):BitmapData {
			var bmp:BitmapData = new BitmapData(pWidth, pHeight, pTransparent, 0xffffffff);
			pLock && bmp.lock();
			return bmp;
		}
		
		public function getBackBuffer():BitmapData { return _backBuffer; }
		
		public function swap():void {
			bitmap.bitmapData = _backBuffer;
			
			//Draw to the screen:
			_backBuffer.unlock();
			_frontBuffer.lock();
			
			var temp:BitmapData = _backBuffer;
			_backBuffer = _frontBuffer;
			_frontBuffer = temp;
		}
		
		public function dispose():void {
			if (!bitmap ) return;
			bitmap.bitmapData = null;
			bitmap = null;
			
			_frontBuffer.dispose();
			_backBuffer.dispose();
			_frontBuffer = null;
			_backBuffer = null;
		}
	}
}