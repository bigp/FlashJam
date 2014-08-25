package flashjam.core {
	import flashjam.core.geom.FJRect;
	import flashjam.objects.FJDirtyFlags;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJGroup extends FJChild {
		internal var _children:Vector.<FJChild>;
		
		public function FJGroup(pX:Number = 0, pY:Number = 0) {
			super(pX, pY);
			
			
			_children = new Vector.<FJChild>();
		}
		
		public function addChild( pChild:FJChild ):FJChild {
			pChild.removeFromParent();
			
			_children[_children.length] = pChild;
			pChild._parent = this;
			
			FJDirtyFlags.INSTANCE.dirtyDisplayList = true;
			return pChild;
		}
		
		public function removeChild(pChild:FJChild):FJChild {
			if (pChild._parent != this) {
				throw Log.__CRASH("Child is not parented by this object.");
			}
			
			var id:int = _children.indexOf(pChild);
			_children.splice(id, 1);
			
			pChild._parent = null;
			FJDirtyFlags.INSTANCE.dirtyDisplayList = true;
			
			return pChild;
		}
		
		public function removeChildren():int {
			var total:int = _children.length;
			if (total == 0) return 0;
			
			for (var c:int = total; --c >= 0; ) {
				var child:FJChild = _children[c];
				child._parent = null;
			}
			
			_children.length = 0;
			FJDirtyFlags.INSTANCE.dirtyDisplayList = true;
			
			return total;
		}
		
		public function addChildAt(pChild:FJChild, pIndex:int):FJChild {
			if(pChild._parent) {
				pChild.removeFromParent();
			}
			
			_children.splice(pIndex, 0, pChild);
			//_children[_children.length] = pChild;
			pChild._parent = this;
			
			FJDirtyFlags.INSTANCE.dirtyDisplayList = true;
			return pChild;
		}
		
		///////////////////////////////////////////// GETTERS-SETTERS
		
		public function get numChildren():int { return _children == null ? -1 : _children.length; }
	}
}