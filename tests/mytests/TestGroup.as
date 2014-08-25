package mytests {
	import bigp.tdd.TDNode;
	import flashjam.core.FJGroup;
	import flashjam.objects.FJDirtyFlags;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestGroup extends TDNode {
		public static var COVERAGE:Class = FJGroup;
		
		public function TestGroup() {
			super();
			
		}
		
		public function testGroup():void {
			FJDirtyFlags.INSTANCE = null;
			
			new FJDirtyFlags();
			
			var group:FJGroup = new FJGroup();
			
			ASSERT_IS_NOT_NULL(group);
			ASSERT_IS_NOT_NULL(group.transform);
			ASSERT_EQUAL(group.transform.right, 1);
			ASSERT_EQUAL(group.transform.bottom, 1);
			
			
			FJDirtyFlags.INSTANCE = null;
		}
	}
}