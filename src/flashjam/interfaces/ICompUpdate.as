package flashjam.interfaces {
	import flashjam.core.FJEntity;
	import flashjam.core.FJTime;
	
	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public interface ICompUpdate {
		function onUpdate(pTime:FJTime):void
		function get entity():FJEntity
		
	}
	
}