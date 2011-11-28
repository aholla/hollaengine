/**
 * ...
 * @author Adam
 */

package aholla.henginex.core.entity;

import flash.display.BitmapData;

interface ITiledRender implements IRendererComponent
{	
	function initTilesheet(level:Array<Array<Int>>, tilesheet:BitmapData, tileW:Int, tileH:Int, x:Int = 0, y:Int = 0):Void;
}	