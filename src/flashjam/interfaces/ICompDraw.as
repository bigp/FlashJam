package flashjam.interfaces {
	import flashjam.core.FJDoubleBuffer;
	import flashjam.core.FJEntity;
	import flashjam.core.FJTime;
	import flashjam.core.geom.FJTransform;
	
	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public interface ICompDraw {
		function onDraw(pTime:FJTime, pBuffer:FJDoubleBuffer, pTrans:FJTransform):void
		function get entity():FJEntity;
		function get canDraw():Boolean;
	}
	
}