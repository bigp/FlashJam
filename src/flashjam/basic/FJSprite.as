package flashjam.basic {
	import flashjam.basic.components.FJGraphic;
	import flashjam.basic.components.FJPhysics;
	import flashjam.core.FJEntity;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class FJSprite extends FJEntity {
		
		public var graphic:FJGraphic;
		public var physics:FJPhysics;
		
		public function FJSprite() {
			super();
			
			graphic = addComponent( new FJGraphic() ) as FJGraphic;
			physics = addComponent( new FJPhysics() ) as FJPhysics;
		}
	}
}