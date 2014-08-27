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
		
		private var _keysDown:Dictionary;
		private var _keysCallback:Dictionary;
		private var _keyTime:int = 1;
		private var _stage:Stage;
		
		public var frameDelayCompensation:int = 0;
		
		public function KeyboardUtils(pStage:Stage, pAutoUpdates:Boolean=true) 
		{
			_stage = pStage;
			_keysDown = new Dictionary();
			_keysCallback = new Dictionary();
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			if(pAutoUpdates) {
				_stage.addEventListener(Event.ENTER_FRAME, advanceTime, false, -1);
			}
		}
		
		public static function get INSTANCE():KeyboardUtils {
			if (!_INSTANCE) {
				if(!FJ.stage) {
					throw new Error("Registry.STAGE is not ready yet.");
				}
				_INSTANCE = new KeyboardUtils( FJ.stage );
				
			}
			
			trace("Using KeyboardUtils global instance somewhere...");
			
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