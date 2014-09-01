package flashjam.utils 
{	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import flashjam.FJ;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class KeyboardUtils 
	{
		private static var _INSTANCE:KeyboardUtils;
		public static var STAGE:Stage;
		
		private var _stage:Stage;
		private var _keyTime:int = 1;
		private var _keysDown:Dictionary;
		private var _keysCallback:Dictionary;
		
		public var frameDelayCompensation:int = 0;
		
		public function KeyboardUtils(pStage:Stage, pAutoUpdates:Boolean=true) {
			_stage = pStage;
			_keysDown = new Dictionary();
			_keysCallback = new Dictionary();
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			if(pAutoUpdates) {
				_stage.addEventListener(Event.ENTER_FRAME, advanceTime, false, -1);
			}
		}
		
		public function dispose():void {
			if (_INSTANCE == this) {
				_INSTANCE = null;
			}
			
			_keysDown = null;
			_keysCallback = null;
			_stage = null;
		}
		
		public function dispatchKey( pKey:uint, pOnDown:Boolean, pCTRL:Boolean=false, pALT:Boolean=false, pSHIFT:Boolean=false ):Boolean {
			if (!_stage) return false;
			var type:String = pOnDown ? KeyboardEvent.KEY_DOWN : KeyboardEvent.KEY_UP;
			var kEvent:KeyboardEvent = new KeyboardEvent(type, true, false, 0, pKey, 0, pCTRL, pALT, pSHIFT);
			_stage.dispatchEvent( kEvent );
			return true;
		}
		
		public static function get INSTANCE():KeyboardUtils {
			if (!_INSTANCE) {
				if(!STAGE) {
					throw new Error("static var STAGE is not set yet.");
				}
				_INSTANCE = new KeyboardUtils( STAGE );
				
			}
			
			Log.__INFO("Using KeyboardUtils global instance somewhere...");
			
			return _INSTANCE;
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			var prevKeyTime:int = _keysDown[e.keyCode];
			if (prevKeyTime > 0) return;
			
			_keysDown[e.keyCode] = _keyTime + frameDelayCompensation;
			
			var callback:Function = _keysCallback[e.keyCode];
			if (callback!=null) callback();
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			_keysDown[e.keyCode] = -(_keyTime+frameDelayCompensation);
		}
		
		public function advanceTime(e:Event = null):void {
			_keyTime++;
		}
		
		public function bindKey( pCode:uint, pCallback:Function ):void {
			_keysCallback[pCode] = pCallback;
		}
		
		public function isPressed( pCode:uint ):Boolean {
			var lastPress:int = _keysDown[pCode];
			return lastPress>0 && lastPress >= _keyTime;
		}
		
		public function isReleased( pCode:uint ):Boolean {
			var lastPress:int = _keysDown[pCode];
			return lastPress<0 && lastPress <= -_keyTime;
		}
		
		public function isDown( pCode:uint ):Boolean {
			var lastPress:int = _keysDown[pCode];
			return lastPress>0;
		}
		
		public function anyDown( ... args ):Boolean {
			for (var k:int = args.length; --k >= 0; ) {
				if (isDown(args[k])) return true;
			}
			
			return false;
		}
		
		public function anyPressed( ... args ):Boolean {
			for (var k:int = args.length; --k >= 0; ) {
				if (isPressed(args[k])) return true;
			}
			
			return false;
		}
		
		public function anyReleased( ... args ):Boolean {
			for (var k:int = args.length; --k >= 0; ) {
				if (isReleased(args[k])) return true;
			}
			
			return false;
		}
		
		public function clear():void {
			_keysDown = new Dictionary();
		}
		
	}

}