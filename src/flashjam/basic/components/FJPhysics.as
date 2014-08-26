package flashjam.basic.components {
	import flashjam.core.FJComponent;
	import flashjam.core.FJTime;
	import flashjam.interfaces.ICompUpdate;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJPhysics extends FJComponent implements ICompUpdate {
		public static const EPSILON:Number = 0.00001;
		
		public var speedX:Number = 0;
		public var speedY:Number = 0;
		public var maxSpeedX:Number = 10;
		public var maxSpeedY:Number = 10;
		public var frictionX:Number = 0.95;
		public var frictionY:Number = 0.95;
		public var accelerationX:Number = 0.5;
		public var accelerationY:Number = 0.5;
		public var restX:Number = EPSILON;
		public var restY:Number = EPSILON;
		public var directionX:int = 0;
		public var directionY:int = 0;
		
		public function FJPhysics() {
			super();
		}
		
		/* INTERFACE flashjam.interfaces.ICompUpdate */
		
		public function onUpdate(pTime:FJTime):void {
			var absX:Number, absY:Number;
			
			if (directionX == 0) {
				speedX *= frictionX;
				absX = speedX < 0 ? -speedX : speedX;
				if (absX < restX) speedX = 0;
			} else {
				speedX += accelerationX * directionX;
				absX = speedX < 0 ? -speedX : speedX;
				if (absX > maxSpeedX) speedX = maxSpeedX * directionX;
			}
			
			if (directionY == 0) {
				speedY *= frictionY;
				absY = speedY < 0 ? -speedY : speedY;
				if (absY < restY) speedY = 0;
			} else {
				speedY += accelerationY * directionY;
				absY = speedY < 0 ? -speedY : speedY;
				if (absY > maxSpeedY) speedY = maxSpeedY * directionY;
			}
			
			if(speedX!=0) transform.x += speedX;
			if(speedY!=0) transform.y += speedY;
		}
	}
}