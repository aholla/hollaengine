/**
 * ...
 * @author Joe Redfearn
 */

package aholla.utils.pathfinding.astar
{
	public interface IAStarGrid
	{
		// -------------------------------------------------------
		// Interface Functions
		// -------------------------------------------------------
		
		/**
		 * Returns whether a <i>Tile</i> is walkable or not. 
		 * @param $x <i>Tile</i> space x coordinate.
		 * @param $y <i>Tile</i> space y coordinate.
		 * @return 
		 * 
		 */
		function isWalkable($x:int, $y:int):Boolean;
		function getCost($x:int, $y:int):int;
		
		function get grid():Array;
	}
}