package flashjam.core {
	import flashjam.core.geom.FJRect;
	import flashjam.objects.FJDirtyFlags;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJChild {
		private var _transform:FJRect;
		internal var _parent:FJGroup;
		internal var _fjDisplayListNext:FJChild;
		private var _isActive:Boolean = true;
		
		public function FJChild(pX:Number=0, pY:Number=0) {
			_transform = new FJRect(pX, pY);
			
			if (!FJDirtyFlags.INSTANCE) {
				throw Log.__CRASH("Make sure the FJ engine is initialized, or make a mockup FJDirtyFlags object.");
			}
		}
		
		public function removeFromParent():void {
			if (!_parent) return;
			_parent.removeChild(this);
		}
		
		public function moveToTop():void {
			var theParent:FJGroup = this._parent;
			if (!theParent) {
				throw Log.__CRASH("There is no parent to move to the top.");
			}
			
			removeFromParent();
			theParent.addChild(this);
		}
		
		public function moveToBottom():void {
			var theParent:FJGroup = this._parent;
			if (!theParent) {
				throw Log.__CRASH("There is no parent to move to the bottom.");
			}
			
			removeFromParent();
			theParent.addChildAt(this, 0);
		}
		
		///////////////////////////////////////////// GETTERS-SETTERS
		
		public function get transform():FJRect { return _transform; }
		public function get parent():FJGroup { return _parent; }
		
		public function get isActive():Boolean { return _isActive; }
		public function set isActive(value:Boolean):void {
			_isActive = value;
			
			FJDirtyFlags.INSTANCE.dirtyDisplayList = true;
		}
	}
}