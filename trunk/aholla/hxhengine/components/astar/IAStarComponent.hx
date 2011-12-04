/**
* ...
* @author Adam
*/

package aholla.hxhengine.components.astar

import flash.geom.PoInt;

interface IAStarComponent 
{	
	function setGrid(grid:Array):Void;
	function findPath(start:PoInt, end:PoInt, diagonals:Bool = false, closest:Bool = true, heuristic:String = ""):Vector.<PoInt>;
	function updateGrid():Void;
}	
