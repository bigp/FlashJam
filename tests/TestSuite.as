package  {
	import bigp.tdd.TDSuite;
	import flash.events.Event;
	import flashjam.core.FJ;
	import flashjam.objects.FJDirtyFlags;
	import mytests.*;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestSuite extends TDSuite {
		
		public function TestSuite() {
			super("flashjam.core");
			coverage.addPathOfTargets("flashjam.utils");
			coverage.addPathOfTests("mytests");
			
			addEventListener(Event.ADDED, onTestAdded);
			addChild(new TestFJ());
			addChild(new TestDoubleBuffer());
			addChild(new TestDraw());
			addChild(new TestPoint());
			addChild(new TestRect());
			addChild(new TestChild());
			addChild(new TestComponent());
			addChild(new TestGroup());
			addChild(new TestEntity());
			addChild(new TestTime());
			addChild(new TestWorld());
		}
		
		private function onTestAdded(e:Event):void {
			if (e.currentTarget == this) return;
			FJDirtyFlags.INSTANCE = null;
			FJ.INSTANCE.dispose();
		}
		
	}
}