/**
 * ...
 * @author Adam
 */

package aholla.HEngine.components.astar
{
	import flash.geom.Point;
	
	public interface IAStarComponent 
	{	
		function setGrid($grid:Array):void;
		function findPath($start:Point, $end:Point, $diagonals:Boolean = false, $closest:Boolean = true, $heuristic:String = ""):Vector.<Point>;
		function updateGrid():void;
	}	
}