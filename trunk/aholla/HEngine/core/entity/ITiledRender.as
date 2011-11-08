/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity 
{
	import flash.display.BitmapData;
	
	public interface ITiledRender extends IRendererComponent
	{	
		function initTilesheet($level:Array, $tilesheet:BitmapData, $tileW:int, tileH:int, $x:int = 0, $y:int = 0):void;
	}	
}