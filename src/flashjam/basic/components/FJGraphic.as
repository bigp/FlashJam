package flashjam.basic.components {
	import flashjam.core.FJComponent;
	import flashjam.core.FJDoubleBuffer;
	import flashjam.core.FJTime;
	import flashjam.interfaces.ICompDraw;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJGraphic extends FJComponent implements ICompDraw {
		
		public function FJGraphic() {
			super();
			
		}
		
		/* INTERFACE flashjam.interfaces.ICompDraw */
		
		public function onDraw(pTime:FJTime, pBuffer:FJDoubleBuffer):void {
			
		}
	}
}