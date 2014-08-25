package mytests {
	import bigp.tdd.TDNode;
	import flashjam.core.FJChild;
	import flashjam.objects.FJDirtyFlags;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestChild extends TDNode{
		public static var COVERAGE:Class = FJChild;
		
		public function TestChild() {
			
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
	}
}