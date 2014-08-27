package flashjam.basic.components {
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
		public static var DEBUG_DRAW:Boolean = true;
		public var x:int = 0;
		public var y:int = 0;
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
			width = pWidth;
			height = pHeight;
			isDynamic = false;
		}
		
		/* INTERFACE flashjam.interfaces.ICompDraw */
		
		public function onDraw(pTime:FJTime, pBuffer:FJDoubleBuffer, pTrans:FJTransform):void {
			if (!graphic()) return;
			
			if (isDynamic) {
				width = _graphic.texture.width;
				height = _graphic.texture.height;
			}
			
			pBuffer.drawRect4(pTrans.x + x, pTrans.y + y, width, height, debugColor);
		}
		
		public function get canDraw():Boolean { return _graphic!=null; }
		
		public function graphic():FJGraphic {
			if (!_graphic) _graphic = entity.getComponent(FJGraphic);
			return _graphic;
		}
	}
}