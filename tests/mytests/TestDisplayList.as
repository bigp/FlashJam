package mytests {
	import bigp.tdd.TDNode;
	import flashjam.core.FJChild;
	import flashjam.core.FJGroup;
	import flashjam.objects.FJDirtyFlags;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestDisplayList extends TDNode{
		public static var COVERAGE:Array = [FJChild, FJGroup];
		
		public function TestDisplayList() {
			
		}
		
		public function testChild():void {
			new FJDirtyFlags();
			
			var child:FJChild = new FJChild();
			
			ASSERT_IS_NOT_NULL(child.transform);
			ASSERT_EQUAL(child.transform.x, 0);
			ASSERT_EQUAL(child.transform.y, 0);
			ASSERT_EQUAL(child.transform.width , 1);
			ASSERT_EQUAL(child.transform.height, 1);
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