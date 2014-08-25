package flashjam.core {
	import flashjam.objects.FJDirtyFlags;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJWorld extends FJGroup {
		private var _dirty:FJDirtyFlags;
		
		private var _compsUpdate:Vector.<FJComponent>;
		private var _compsDraw:Vector.<FJComponent>;
		
		private var _childrenListHead:FJChild;
		private var _childrenListTail:FJChild;
		private var _entitiesListHead:FJEntity;
		private var _entitiesListTail:FJEntity;
		
		private var _componentListHead:FJComponent;
		private var _componentListTail:FJComponent;
		
		private var _childrenTotal:int = 0;
		private var _entitiesTotal:int = 0;
		private var _componentsTotal:int = 0;
		
		
		public function FJWorld() {
			super();
			
			_dirty = FJDirtyFlags.INSTANCE;
			
			_compsUpdate = new Vector.<FJComponent>();
			_compsDraw = new Vector.<FJComponent>();
		}
		
		public function onWorldBegin():void {
			
		}
		
		public function onWorldEnd():void {
			
		}
		
		public function dispose():void {
			if (!_dirty) return;
			
			_compsUpdate.length = 0;
			_compsDraw.length = 0;
			
			_dirty = null;
			_compsUpdate = null;
			_compsDraw = null;
			_childrenListHead = null;
			_childrenListTail = null;
			
			_entitiesListHead = null;
			_entitiesListTail = null;
			
			_componentListHead = null;
			_componentListTail = null;
		}
		
		public function invalidate():void {
			if (_dirty.dirtyDisplayList) {
				_dirty.dirtyDisplayList = false;
				
				//The rest needs to be invalidated:
				_dirty.dirtyComponentList = true;
				_dirty.dirtyDraws = true;
				_dirty.dirtyUpdates = true;
				
				//Alright, start with the display-list invalidation:
				_childrenListHead = this;
				_childrenListTail = this;
				_childrenTotal = 1;
				
				_entitiesListHead = null;
				_entitiesListTail = null;
				_entitiesTotal = 0;
				
				recursiveBuildDisplayList( this );
			}
			
			var child:FJChild;
			var entity:FJEntity;
			var theComponents:Vector.<FJComponent>;
			var theComp:FJComponent;
			
			if (_dirty.dirtyComponentList) {
				_dirty.dirtyComponentList = false;
				
				//The rest needs to be invalidated:
				_dirty.dirtyDraws = true;
				_dirty.dirtyUpdates = true;
				
				_componentListHead = null;
				_componentListTail = null;
				_componentsTotal = 0;
				
				_compsDraw.length = 0;
				_compsUpdate.length = 0;
				
				entity = _entitiesListHead;
				while (entity) {
					theComponents = entity._components;
					for (var i:int=0, iLen:int=theComponents.length; i<iLen; i++) {
						theComp = theComponents[i];
						if (!theComp._isActive) {
							theComp._fjComponentListNext = null;
							theComp._fjComponentIndex = -1;
							continue;
						}
						
						if (_componentListHead == null) {
							_componentListHead = _componentListTail = theComp;
						} else {
							_componentListTail._fjComponentListNext = theComp;
							_componentListTail = theComp;
						}
						
						_compsDraw[_compsDraw.length] = theComp;
						_compsUpdate[_compsUpdate.length] = theComp;
					}
					
					entity = entity._fjEntityListNext;
				}
			}
			
			if (_dirty.dirtyDraws) {
				_compsDraw.sort( sortByDraws );
			}
			
			if (_dirty.dirtyUpdates) {
				_compsUpdate.sort( sortByUpdates );
			}
		}
		
		
		
		public function update( pTime:FJTime ):void {
			for (var i:int=0, iLen:int=_compsDraw.length; i<iLen; i++) {
				var theComp:FJComponent = _compsDraw[i];
				theComp.onUpdate(pTime);
			}
		}
		
		public function draw( pTime:FJTime, pDraw:FJDraw ):void {
			trace(pTime + " : " + pDraw);
			
			for (var i:int=0, iLen:int=_compsDraw.length; i<iLen; i++) {
				var theComp:FJComponent = _compsDraw[i];
				theComp.onDraw(pTime, pDraw);
			}
		}
		
		private function sortByDraws(pA:FJComponent, pB:FJComponent):int {
			if (pA._fjDrawOrder < pB._fjDrawOrder) return -1;
			if (pA._fjDrawOrder > pB._fjDrawOrder) return 1;
			if (pA._fjComponentIndex < pB._fjComponentIndex) return -1;
			if (pA._fjComponentIndex > pB._fjComponentIndex) return 1;
			return 0;
		}
		
		private function sortByUpdates(pA:FJComponent, pB:FJComponent):int {
			if (pA._fjUpdateOrder < pB._fjUpdateOrder) return -1;
			if (pA._fjUpdateOrder > pB._fjUpdateOrder) return 1;
			if (pA._fjComponentIndex < pB._fjComponentIndex) return -1;
			if (pA._fjComponentIndex > pB._fjComponentIndex) return 1;
			return 0;
		}
		
		private function recursiveBuildDisplayList( pGroup:FJGroup ):void {
			var theChildren:Vector.<FJChild> = pGroup._children;
			
			for (var i:int=0, iLen:int=theChildren.length; i<iLen; i++) {
				var child:FJChild = theChildren[i];
				if (!child.isActive) {
					child._fjDisplayListNext = null;
					continue;
				}
				
				_childrenListTail._fjDisplayListNext = child;
				_childrenListTail = child;
				_childrenTotal++;
				
				if (child is FJEntity) {
					var entity:FJEntity = child as FJEntity;
					if (_entitiesListHead == null) {
						_entitiesListHead = _entitiesListTail = entity;
					} else {
						_entitiesListTail._fjEntityListNext = entity;
						_entitiesListTail = entity;
					}
				}
				
				var theGroup:FJGroup = child as FJGroup;
				if (theGroup != null) {
					recursiveBuildDisplayList(theGroup);
				}
			}
		}
		
		public function getComponentsUpdate():Vector.<FJComponent> { return _compsUpdate; }
		public function getComponentsDraw():Vector.<FJComponent> { return _compsDraw; }
		
		public function get childrenTotal():int { return _childrenTotal; }
		public function get entitiesTotal():int { return _entitiesTotal; }
		public function get componentsTotal():int { return _componentsTotal; }
	}
}