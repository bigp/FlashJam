package flashjam.core {
	import flashjam.core.geom.FJRect;
	import flashjam.objects.FJDirtyFlags;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJEntity extends FJGroup {
		
		internal var _components:Vector.<FJComponent>;
		internal var _fjEntityListNext:FJEntity;
		
		public function FJEntity() {
			super();
			
			_components = new Vector.<FJComponent>();
		}
		
		public function addComponent(pComp:FJComponent, pLookupCls:Class=null):FJComponent {
			if (!pComp) return null;
			if (pComp._entity && pComp._compIndex > -1) {
				throw Log.__CRASH("Component already added to this entity?");
			}
			
			pComp._compIndex = _components.length;
			pComp._entity = this;
			_components[pComp._compIndex] = pComp;
			
			if (pLookupCls) pComp._lookupCls = pLookupCls;
			
			pComp.onAdded();
			
			FJDirtyFlags.INSTANCE.dirtyComponentList = true;
			
			return pComp;
		}
		
		public function addComponents( ... comps ):void {
			for (var i:int=0, iLen:int=comps.length; i<iLen; i++) {
				var comp:FJComponent = FJComponent(comps[i]);
				addComponent(comp);
			}
		}
		
		public function removeComponent( pComp:FJComponent ):FJComponent {
			if (pComp._entity != this) {
				throw Log.__CRASH("Removing a component that was never added.");
			}
			
			_components.splice(pComp._compIndex, 1);
			pComp._compIndex = -1;
			pComp._entity = null;
			pComp._lookupCls = null;
			
			pComp.onRemoved();
			
			FJDirtyFlags.INSTANCE.dirtyComponentList = true;
			
			return pComp;
		}
		
		public function removeComponents():int {
			var total:int = _components.length;
			
			for (var i:int=_components.length; --i>=0;) {
				var comp:FJComponent = _components[i];
				comp._compIndex = -1;
				comp._entity = null;
				comp._lookupCls = null;
				
				comp.onRemoved();
			}
			
			_components.length = 0;
			
			FJDirtyFlags.INSTANCE.dirtyComponentList = true;
			
			return total;
		}
		
		public function hasComponent(pCompClass:Class):Boolean {
			return getComponent(pCompClass) != null;
		}
		
		public function getComponent(pCompClass:Class):* {
			var comp:FJComponent;
			
			for (var i:int=0, iLen:int=_components.length; i<iLen; i++) {
				comp = _components[i];
				if (comp is pCompClass || comp._lookupCls===pCompClass) {
					return comp;
				}
			}
			
			return null;
		}
	}
}