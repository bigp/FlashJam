package flashjam.basic.components {
	import flashjam.core.FJComponent;
	import flashjam.core.FJTime;
	import flashjam.interfaces.ICompUpdate;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJPhysics extends FJComponent implements ICompUpdate {
		
		public var speedX:Number = 0;
		public var speedY:Number = 0;
		public var maxSpeedX:Number = 10;
		public var maxSpeedY:Number = 10;
		public var accX:Number = 0.5;
		public var accY:Number = 0.5;
		public var frictionX:Number = 0.95;
		public var frictionY:Number = 0.95;
		
		public function FJPhysics() {
			super();
			
		}
		
		/* INTERFACE flashjam.interfaces.ICompUpdate */
		
		public function onUpdate(pTime:FJTime):void {
			transform.x++;
		}
	}
}