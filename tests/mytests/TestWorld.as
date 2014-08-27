package mytests {
	import bigp.tdd.TDNode;
	import flash.display.BitmapData;
	import flash.utils.getTimer;
	import flashjam.basic.components.FJGraphic;
	import flashjam.basic.components.FJPhysics;
	import flashjam.basic.FJSprite;
	import flashjam.core.FJComponent;
	import flashjam.core.FJDoubleBuffer;
	import flashjam.core.FJEntity;
	import flashjam.core.FJTime;
	import flashjam.core.FJWorld;
	import flashjam.objects.FJDirtyFlags;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestWorld extends TDNode {
		public static var COVERAGE:Class = FJWorld;
		
		public function TestWorld() {
			super();
			
		}
		
		public function testWorld():void {
			new FJDirtyFlags();
			
			var theWorld:FJWorld = new FJWorld();
			var child:FJEntity = new FJEntity();
			var time:FJTime = new FJTime(getTimer());
			var draw:FJDoubleBuffer = new FJDoubleBuffer(128, 128);
			
			ASSERT_IS_NULL(theWorld.parent);
			ASSERT_IS_NOT_NULL(theWorld.transform);
			ASSERT_EQUAL(theWorld.transform.x, 0);
			ASSERT_EQUAL(theWorld.transform.y, 0);
			ASSERT_EQUAL(theWorld.transform.width, 1);
			ASSERT_EQUAL(theWorld.transform.height, 1);
			ASSERT_EQUAL(theWorld.numChildren, 0);
			
			theWorld.invalidate();
			ASSERT_EQUAL(theWorld.numChildren, 0);
			ASSERT_EQUAL(theWorld.totalChildren, 1);
			
			theWorld.addChild(child);
			theWorld.invalidate();
			
			ASSERT_EQUAL(theWorld.numChildren, 1);
			ASSERT_EQUAL(theWorld.totalChildren, 2);
			
			ASSERT_EQUAL(theWorld.update(time), 0);
			ASSERT_EQUAL(theWorld.draw(time, draw), 0);
			
			child.addComponent( new FJComponent(), TestWorld );
			
			ASSERT_EQUAL(theWorld.update(time), 0);
			theWorld.invalidate();
			
			//Since the above abstract classes are not ICompUpdate and ICompDraw, the count doesn't change:
			ASSERT_EQUAL(theWorld.update(time), 0);
			ASSERT_EQUAL(theWorld.draw(time, draw), 0);
			
			//Let's add some updateable/drawable components:
			child.addComponent( new FJPhysics() );
			child.addComponent( new FJGraphic(new BitmapData(16, 16, false, 0x223344) ) );
			
			theWorld.invalidate();
			ASSERT_EQUAL(theWorld.update(time), 1, "num of updates 1");
			ASSERT_EQUAL(theWorld.draw(time, draw), 1, "num of draws 1");
			
			var spr:FJSprite = new FJSprite();
			theWorld.addChild( spr );
			ASSERT_IS_NOT_NULL( spr.graphic, "sprite.graphic " );
			ASSERT_IS_NOT_NULL( spr.physics, "sprite.physics " );
			ASSERT_IS_NOT_NULL( spr.getComponent( FJGraphic ), "sprite has graphic" );
			ASSERT_IS_NOT_NULL( spr.getComponent( FJPhysics ), "sprite has physics" );
			
			ASSERT_EQUAL(theWorld.update(time), 1, "num of updates pre");
			theWorld.invalidate();
			ASSERT_EQUAL(theWorld.update(time), 2, "num of updates post");
			
			if(FJGraphic.IS_TEXTURES_AUTOCREATED) {
				ASSERT_EQUAL(theWorld.draw(time, draw), 3, "num of draws 2");
			} else {
				ASSERT_EQUAL(theWorld.draw(time, draw), 2, "num of draws 2");
			}
		}
	}
}