package mytests {
	import bigp.tdd.TDNode;
	import flashjam.core.FJComponent;
	import flashjam.core.FJEntity;
	import flashjam.objects.FJDirtyFlags;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestComponent extends TDNode {
		public static var COVERAGE:Class = FJComponent;
		
		public function TestComponent() {
			super();
			
		}
		
		public function testComponent():void {
			new FJDirtyFlags();
			
			var entity:FJEntity = new FJEntity();
			var comp:FJComponent = new FJComponent();
			
			
			ASSERT_IS_NOT_NULL(comp);
			ASSERT_IS_NULL(comp.entity);
			
			ASSERT_EQUALSTRICT(entity.addComponent( comp, TestComponent ), comp);
			
			ASSERT_IS_NOT_NULL(comp.entity);
			ASSERT_IS_NOT_NULL(comp.entity.transform);
			ASSERT_EQUAL(comp.entity.hasComponent(FJComponent), true);
			ASSERT_EQUAL(comp.entity.hasComponent(TestComponent), true);
			
			ASSERT_EQUALSTRICT(entity.getComponent(FJComponent), comp);
			ASSERT_EQUALSTRICT(entity.getComponent(TestComponent), comp);
			
			ASSERT_EQUALSTRICT(entity.removeComponent(comp), comp);
			
			entity.addComponent(comp);
			entity.addComponent(new FJComponent(), TDNode);
			
			ASSERT_EQUALSTRICT(entity.removeComponents(), 2);
			ASSERT_IS_NULL(entity.getComponent(TDNode));
			ASSERT_EQUAL(comp.isAttached, false);
			
			FJDirtyFlags.INSTANCE = null;
		}
	}
}