package flashjam.interfaces {
	import flashjam.core.FJDoubleBuffer;
	import flashjam.core.FJTime;
	
	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public interface ICompDraw {
		function onDraw(pTime:FJTime, pBuffer:FJDoubleBuffer):void
	}
	
}