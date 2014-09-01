package mytests {
	import bigp.tdd.TDNode;
	import flash.ui.Keyboard;
	import flashjam.utils.ClassUtils;
	import flashjam.utils.KeyboardUtils;
	import flashjam.utils.StringUtils;
	
	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestUtils extends TDNode {
		public static var COVERAGE:Array = [KeyboardUtils, StringUtils, ClassUtils];
		
		public function TestUtils() {
			
		}
		
		public function testKeyboardUtils():void {
			KeyboardUtils.STAGE = this.stage;
			KeyboardUtils.INSTANCE.advanceTime();
			KeyboardUtils.INSTANCE.dispatchKey(Keyboard.SPACE, true);
			KeyboardUtils.INSTANCE.advanceTime();
			ASSERT_EQUAL( KeyboardUtils.INSTANCE.isPressed(Keyboard.SPACE), true );
			
		}
		
		public function testStringUtils():void {
			
		}
		
		public function testClasseUtils():void {
			
		}
	}
}