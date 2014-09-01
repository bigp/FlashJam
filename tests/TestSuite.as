package  {
	import bigp.tdd.TDSuite;
	import flash.events.Event;
	import flashjam.FJ;
	import flashjam.objects.FJDirtyFlags;
	import mytests.*;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestSuite extends TDSuite {
		
		public function TestSuite() {
			super("flashjam.core");
			coverage.addPathOfTargets("flashjam.basic");
			coverage.addPathOfTargets("flashjam.utils");
			coverage.addPathOfTargets("flashjam::FJ");
			coverage.addPathOfTests("mytests");
			
			addEventListener(Event.ADDED, onTestAdded);
			addChild(new TestFJ());
			addChild(new TestGeom());
			addChild(new TestDisplayList());
			addChild(new TestEntity());
			addChild(new TestWorld());
			addChild(new TestSprite());
			addChild(new TestUtils());
		}
		
		private function onTestAdded(e:Event):void {
			if (e.currentTarget == this) return;
			FJDirtyFlags.INSTANCE = null;
			FJ.INSTANCE.dispose();
		}
	}
}