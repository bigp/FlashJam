package flashjam.basic.components {
	import flash.geom.Rectangle;
	import flashjam.core.geom.FJTransform;
	import flashjam.core.FJComponent;
	import flashjam.core.FJDoubleBuffer;
	import flashjam.core.FJTime;
	import flashjam.interfaces.ICompDraw;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJHitBox extends FJComponent implements ICompDraw {
		private static var _DEBUG_DRAW_RECT:Rectangle = new Rectangle();
		public static var DEBUG_DRAW:Boolean = false;
		
		public var offsetX:int = 0;
		public var offsetY:int = 0;
		public var width:int = -1;
		public var height:int = -1;
		public var isDynamic:Boolean = true;
		public var debugColor:uint = 0xccff0000;
		
		private var _graphic:FJGraphic;
		
		public function FJHitBox() {
			super();
			
		}
		
		public override function onAdded():void {
			super.onAdded();
			
			graphic();
			
		}
		
		public function setSize(pWidth:int, pHeight:int):void {
			width = pWidth<0 ? _graphic.texture.width + pWidth : pWidth;
			height = pHeight<0 ? _graphic.texture.height + height : pHeight;
			isDynamic = false;
		}
		
		/* INTERFACE flashjam.interfaces.ICompDraw */
		
		public function onDraw(pTime:FJTime, pBuffer:FJDoubleBuffer, pTrans:FJTransform):void {
			if (!graphic() || !_graphic.texture) return;
			
			if (isDynamic) {
				width = _graphic.texture.width;
				height = _graphic.texture.height;
			}
			
			_DEBUG_DRAW_RECT.x = pTrans.x + offsetX;
			_DEBUG_DRAW_RECT.y = pTrans.y + offsetY;
			_DEBUG_DRAW_RECT.width = this.width;
			_DEBUG_DRAW_RECT.height = this.height;
			
			pBuffer.drawRect(_DEBUG_DRAW_RECT, debugColor);
		}
		
		public function get canDraw():Boolean { return _graphic!=null; }
		
		public function graphic():FJGraphic {
			if (!_graphic) _graphic = entity.getComponent(FJGraphic);
			return _graphic;
		}
	}
}