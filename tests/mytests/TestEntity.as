package mytests {
	import bigp.tdd.TDNode;
	import flashjam.core.FJEntity;
	import flashjam.objects.FJDirtyFlags;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestEntity extends TDNode {
		public static var COVERAGE:Class = FJEntity;
		
		public function TestEntity() {
			super();
			
		}
		
		public function testEntity():void {
			new FJDirtyFlags();
			
			var entity:FJEntity = new FJEntity();
			
			ASSERT_IS_NOT_NULL(entity.transform);
			ASSERT_EQUAL(entity.transform.x, 0);
			ASSERT_EQUAL(entity.transform.y, 0);
			ASSERT_EQUAL(entity.transform.width, 1);
			ASSERT_EQUAL(entity.transform.height, 1);
			
			ASSERT_IS_NULL(entity.parent);
		}
	}
}