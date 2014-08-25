package flashjam.core {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flashjam.objects.FJDirtyFlags;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJ {
		private static var _INSTANCE:FJ;
		
		private var _root:DisplayObject;
		private var _stage:Stage;
		private var _dirty:FJDirtyFlags;
		public var view:Rectangle;
		public var doubleBuffer:FJDoubleBuffer;
		public var drawer:FJDraw;
		public var time:FJTime;
		
		private var _onReady:Function;
		
		private var _worldNext:FJWorld;
		private var _world:FJWorld;
		
		public function FJ(pRoot:DisplayObject, pWorldStart:FJWorld=null, pOnReady:Function = null, pViewRect:Rectangle = null) {
			_INSTANCE = this;
			
			_root = pRoot;
			view = pViewRect;
			_onReady = pOnReady;
			_dirty = new FJDirtyFlags();
			_worldNext = pWorldStart;
			_root.addEventListener(Event.ENTER_FRAME, checkForStage);
		}
		
		public function dispose():void {
			if (!doubleBuffer) return;
			
			doubleBuffer.dispose();
			drawer.dispose();
			
			doubleBuffer = null;
			drawer = null;
			_root = null;
			_stage = null;
			_dirty = null;
			view = null;
			time = null;
		}
		
		private function checkForStage(e:Event):void {
			if (!_root.stage) return;
			_root.removeEventListener(Event.ENTER_FRAME, checkForStage);
			_stage = _root.stage;
			
			initialize();
		}
		
		private function initialize():void {
			if (!view) view = new Rectangle(0, 0, _stage.stageWidth, _stage.stageHeight)
			
			var bitmap:Bitmap = new Bitmap(null, PixelSnapping.NEVER, false);
			doubleBuffer = new FJDoubleBuffer(bitmap, view.width, view.height);
			
			drawer = new FJDraw();
			drawer.setCurrentBitmap( doubleBuffer.getBackBuffer() );
			
			time = new FJTime(getTimer());
			
			//Call the custom ON_READY callback:
			if (_onReady != null) {
				_onReady();
				_onReady = null;
			}
			
			_root.addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		private function onUpdate(e:Event):void {
			checkWorlds();
			
			//Capture the time (diffs, etc.):
			time.update();
			
			if (_world) {
				_world.invalidate();
				_world.update( time );
				_world.draw( time, drawer );
			}
			
			//Swap to present all changes to the screen:
			doubleBuffer.swap();
			
			//Set the current backbuffer for the next drawing executions:
			drawer.setCurrentBitmap(doubleBuffer.getBackBuffer());
		}
		
		private function checkWorlds():void {
			if (_worldNext == null) return;
			
			if (_world) {
				_world.onWorldEnd();
				_world.dispose();
				_world = null;
			}
			
			_world = _worldNext;
			_world.onWorldBegin();
			
			_worldNext = null;
		}
		
		public function get stage():Stage { return _stage; }
		
		public static function get stage():Stage { return INSTANCE._stage; }
		public static function get width():Number { return INSTANCE._stage.stageWidth; }
		public static function get height():Number { return INSTANCE._stage.stageHeight; }
		
		public static function disposeGlobal():void {
			_INSTANCE.dispose();
			_INSTANCE = null;
		}
		
		public static function get INSTANCE():FJ {
			if (!_INSTANCE) {
				throw Log.__CRASH("The instance of FJ seems missing.");
			}
			return _INSTANCE;
		}
	}
}