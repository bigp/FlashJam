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
	import flashjam.utils.KeyboardUtils;
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
		private var _onReady:Function;
		private var _worldNext:FJWorld;
		private var _world:FJWorld;
		private var _isPaused:Boolean = false;
		private var _pauseAfterRender:Boolean = false;
		
		public var doubleBuffer:FJDoubleBuffer;
		public var view:Rectangle;
		public var time:FJTime;
		public var keys:KeyboardUtils;
		
		public var whenWorldDrawn:Signal;
		public var whenWorldUpdated:Signal;
		public var whenWorldDisposed:Signal;
		public var whenWorldBegan:Signal;
		public var whenWorldEnded:Signal;
		
		
		public function FJ(pRoot:DisplayObjectContainer, pWorldStart:FJWorld=null, pOnReady:Function = null, pViewRect:Rectangle = null) {
			_INSTANCE = this;
			
			whenWorldDrawn = new Signal();
			whenWorldUpdated = new Signal();
			whenWorldDisposed = new Signal();
			whenWorldBegan = new Signal();
			whenWorldEnded = new Signal();
			
			_root = pRoot;
			view = pViewRect;
			_onReady = pOnReady;
			_dirty = new FJDirtyFlags();
			_worldNext = pWorldStart;
			_root.addEventListener(Event.ENTER_FRAME, checkForStage);
		}
		
		public function dispose():void {
			if (!doubleBuffer) return;
			
			whenWorldDrawn.removeAll();
			whenWorldUpdated.removeAll();
			whenWorldDisposed.removeAll();
			whenWorldBegan.removeAll();
			whenWorldEnded.removeAll();
			
			doubleBuffer.dispose();
			
			if (_world) {
				_world.dispose();
				_world = null;
			}
			
			_worldNext = null;
			_onReady = null;
			
			whenWorldDrawn = null;
			whenWorldUpdated = null;
			whenWorldDisposed = null;
			whenWorldBegan = null;
			whenWorldEnded = null;
			
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
			
			doubleBuffer = new FJDoubleBuffer(view.width, view.height);
			_root.addChild(doubleBuffer.bitmap);
			
			time = new FJTime(getTimer());
			keys = new KeyboardUtils(_stage, false);
			//keys.frameDelayCompensation = 1;
			
			if (!_worldNext && !_world) {
				_worldNext = new FJWorld();
				checkWorlds();
			}
			
			_root.addEventListener(Event.ENTER_FRAME, onUpdate);
			
			//Call the custom ON_READY callback:
			if (_onReady != null) {
				_onReady();
				_onReady = null;
			}
		}
		
		private function onUpdate(e:Event):void {
			if (_isPaused) return;
			
			checkWorlds();
			
			//Capture the time (diffs, etc.):
			time.update();
			
			if (_world) {
				_world.invalidate();
				
				_world.update( time );
				whenWorldUpdated.dispatch();
				
				_world.draw( time, doubleBuffer );
				whenWorldDrawn.dispatch();
			}
			
			keys.advanceTime();
			
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
				whenWorldEnded.dispatch();
				
				_world.dispose();
				_world = null;
				
				whenWorldDisposed.dispatch();
			}
			
			_world = _worldNext;
			_world.onWorldBegin();
			_worldNext = null;
			
			whenWorldBegan.dispatch();
		}
		
		
		///////////////////////////////////////////// GETTERS-SETTERS
		
		public function get stage():Stage { return _stage; }
		
		public static function get stage():Stage { return !_INSTANCE ? null : INSTANCE._stage; }
		public static function get width():Number { return !_INSTANCE ? -1 : stage.stageWidth; }
		public static function get height():Number { return !_INSTANCE ? -1 : stage.stageHeight; }
		
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