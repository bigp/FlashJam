package flashjam.core {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flashjam.core.geom.FJRect;
	import flashjam.interfaces.IDisposable;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJDoubleBuffer implements IDisposable {
		
		private var _helperFillRect:Rectangle;
		private var _helperFillAll:Rectangle;
		private var _helperPoint:Point;
		private var _frontBuffer:BitmapData;
		private var _backBuffer:BitmapData;
		private var _scratchBuffer:BitmapData;
		private var _helperPointZero:Point;
		
		public var bitmap:Bitmap;
		
		public var clearEachFrame:Boolean = true;
		public var backgroundColor:uint = 0xff000000;
		
		public function FJDoubleBuffer(pWidth:int, pHeight:int, pBitmap:Bitmap=null, pTransparent:Boolean=true) {
			_helperFillRect = new Rectangle();
			_helperFillAll = new Rectangle(0, 0, pWidth, pHeight);
			_helperPointZero = new Point();
			_helperPoint = new Point();
			
			_frontBuffer = createBMP(pWidth, pHeight, pTransparent);
			_backBuffer = createBMP(pWidth, pHeight, pTransparent, true);
			_scratchBuffer = createBMP(pWidth, pHeight, true, true);
			
			bitmap = pBitmap || new Bitmap(null, PixelSnapping.NEVER, false);
			bitmap.bitmapData = _frontBuffer;
			
			_backBuffer.fillRect( _helperFillAll, backgroundColor);
		}
		
		private static function createBMP(pWidth:int, pHeight:int, pTransparent:Boolean, pLock:Boolean=false):BitmapData {
			var bmp:BitmapData = new BitmapData(pWidth, pHeight, pTransparent, 0xffffffff);
			pLock && bmp.lock();
			return bmp;
		}
		
		public function getBackBuffer():BitmapData { return _backBuffer; }
		
		public function swap():void {
			//Draw to the screen:
			_frontBuffer.copyPixels(_backBuffer, _helperFillAll, _helperPointZero );
			
			//Clear the back-buffer
			if(clearEachFrame) {
				_backBuffer.fillRect( _helperFillAll, backgroundColor);
			}
		}
		
		public function dispose():void {
			if (!bitmap ) return;
			
			bitmap.bitmapData = null;
			bitmap = null;
			
			_frontBuffer.dispose();
			_backBuffer.dispose();
			_scratchBuffer.dispose();
			_frontBuffer = null;
			_backBuffer = null;
			_scratchBuffer = null;
			_helperFillRect = null;
			_helperFillAll = null;
			_helperPoint = null;
			_helperPointZero = null;
		}
		
		/**
		 * Mostly used for testing purpose. Provide a rectangle / entity, and it'll draw a color of its' bounds.
		 * @param	pRect
		 * @param	pColor
		 */
		public function drawRect( pRect:FJRect, pColor:uint ):void {
			pRect.copyToRect( _helperFillRect );
			_backBuffer.fillRect( _helperFillRect, pColor );
		}
		
		public function drawRect4(pX:Number, pY:Number, pWidth:Number, pHeight:Number, pColor:uint):void {
			_helperFillRect.x = pX;
			_helperFillRect.y = pY;
			_helperFillRect.width = pWidth;
			_helperFillRect.height = pHeight;
			
			_helperPoint.x = pX;
			_helperPoint.y = pY;
			
			_scratchBuffer.fillRect( _helperFillRect, pColor );
			_backBuffer.copyPixels( _scratchBuffer, _helperFillRect, _helperPoint, null, null, true );
			_scratchBuffer.fillRect( _helperFillRect, 0x00000000 );
		}
	}
}