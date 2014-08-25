package flashjam {
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.PixelSnapping;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flashjam.core.FJDoubleBuffer;
	import flashjam.core.FJTime;
	import flashjam.core.FJWorld;
	import flashjam.objects.FJDirtyFlags;
	import org.osflash.signals.Signal;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJ {
		private static var _INSTANCE:FJ;
		
		private var _root:DisplayObjectContainer;
		private var _stage:Stage;
		private var _dirty:FJDirtyFlags;
		public var view:Rectangle;
		public var doubleBuffer:FJDoubleBuffer;
		public var time:FJTime;
		
		private var _onReady:Function;
		
		private var _worldNext:FJWorld;
		private var _world:FJWorld;
		
		private var _pauseAfterRender:Boolean = false;
		private var _isPaused:Boolean = false;
		
		public var whenDrawing:Signal;
		public var whenUpdating:Signal;
		
		public function FJ(pRoot:DisplayObjectContainer, pWorldStart:FJWorld=null, pOnReady:Function = null, pViewRect:Rectangle = null) {
			_INSTANCE = this;
			
			whenDrawing = new Signal();
			whenUpdating = new Signal();
			
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
			
			doubleBuffer = null;
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
			_root.addChild(bitmap);
			
			doubleBuffer = new FJDoubleBuffer(bitmap, view.width, view.height);
			
			time = new FJTime(getTimer());
			
			//Call the custom ON_READY callback:
			if (_onReady != null) {
				_onReady();
				_onReady = null;
			}
			
			if (!_worldNext && !_world) {
				_worldNext = new FJWorld();
			}
			
			_root.addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		private function onUpdate(e:Event):void {
			if (_isPaused) return;
			
			checkWorlds();
			
			//Capture the time (diffs, etc.):
			time.update();
			
			if (_world) {
				_world.invalidate();
				
				_world.update( time );
				whenUpdating.dispatch();
				
				_world.draw( time, doubleBuffer );
				whenDrawing.dispatch();
			}
			
			//Swap to present all changes to the screen:
			//Set the current backbuffer for the next drawing executions:
			doubleBuffer.swap();
			
			
			if (_pauseAfterRender) {
				_isPaused = true;
				_pauseAfterRender = false;
			}
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
		
		
		///////////////////////////////////////////// GETTERS-SETTERS
		
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
		
		public function get pauseAfterRender():Boolean { return _pauseAfterRender; }
		public function set pauseAfterRender(value:Boolean):void {
			_pauseAfterRender = value;
		}
		
		public function get isPaused():Boolean { return _isPaused; }
		public function set isPaused(value:Boolean):void {
			_isPaused = value;
		}
		
		public function get world():FJWorld { return _world; }
		public function set world(value:FJWorld):void {
			if (_world === value || value==null) return;
			
			_worldNext = value;
		}
	}
}