package flashjam.basic.components {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flashjam.core.FJComponent;
	import flashjam.core.FJDoubleBuffer;
	import flashjam.core.FJTime;
	import flashjam.core.geom.FJTransform;
	import flashjam.interfaces.ICompDraw;
	import flashjam.objects.FJDirtyFlags;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJGraphic extends FJComponent implements ICompDraw {
		public static var IS_TEXTURES_AUTOCREATED:Boolean = true;
		
		private static var _HELPER_POINT:Point = new Point();
		
		private var _rect:Rectangle;
		private var _texture:BitmapData;
		
		public function FJGraphic(pTexture:BitmapData=null) {
			super();
			
			if(pTexture!=null) {
				texture = pTexture;
			} else if(IS_TEXTURES_AUTOCREATED) {
				var tex:BitmapData = new BitmapData(128, 128, true, 0xffff0000);
				tex.perlinNoise( 4, 4, 16, Math.random() * 100, true, true );
				texture = tex;
			}
		}
		
		/* INTERFACE flashjam.interfaces.ICompDraw */
		
		public function onDraw(pTime:FJTime, pBuffer:FJDoubleBuffer, pTrans:FJTransform):void {
			if (!_texture) return;
			
			var bmp:BitmapData = pBuffer.getBackBuffer();
			
			_HELPER_POINT.x = pTrans.x;
			_HELPER_POINT.y = pTrans.y;
			
			bmp.copyPixels( texture, _rect, _HELPER_POINT );
		}
		
		public function get texture():BitmapData { return _texture; }
		public function set texture(value:BitmapData):void {
			_texture = value;
			
			if(_texture) {
				_rect = new Rectangle(0, 0, _texture.width, _texture.height);
			}
			
			FJDirtyFlags.INSTANCE.dirtyDraws = true;
		}
		
		public function get canDraw():Boolean { return _texture != null; }
	}
}