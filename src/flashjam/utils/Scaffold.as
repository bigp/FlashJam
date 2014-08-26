package flashjam.utils {
	import flash.ui.Keyboard;
	import flashjam.basic.components.FJPhysics;
	import flashjam.FJ;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Scaffold {
		
		public static function keysArrowsToPhysics( pPhysics:FJPhysics, pKeys:KeyboardUtils = null ):void {
			if (pKeys == null) {
				pKeys = FJ.INSTANCE.keys || KeyboardUtils.INSTANCE;
			}
			
			pPhysics.directionX = pPhysics.directionY = 0;
			
			if (pKeys.isDown(Keyboard.UP)) --pPhysics.directionY;
			if (pKeys.isDown(Keyboard.DOWN)) ++pPhysics.directionY;
			if (pKeys.isDown(Keyboard.LEFT)) --pPhysics.directionX;
			if (pKeys.isDown(Keyboard.RIGHT)) ++pPhysics.directionX;
		}
	}
}