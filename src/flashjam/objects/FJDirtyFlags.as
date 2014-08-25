package flashjam.objects {

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJDirtyFlags {
		
		public static var INSTANCE:FJDirtyFlags;
		
		public var dirtyUpdates:Boolean = true;
		public var dirtyDraws:Boolean = true;
		public var dirtyDisplayList:Boolean = true;
		public var dirtyComponentList:Boolean = true;
		
		public function FJDirtyFlags() {
			INSTANCE = this;
		}
	}
}