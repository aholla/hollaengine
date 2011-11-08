/**
 * A* Component
 * 
 * Dependancies on AStarGrid version 1.0.0 and
 * aStar version 1.0.0
 * 
 * @author Adam
 */

package aholla.HEngine.components.aStarComponent 
{	
	import aholla.HEngine.core.entity.Component;
	import aholla.HEngine.core.Logger;
	import aholla.utils.pathfinding.astar.AStar;
	import aholla.utils.pathfinding.astar.AStarGrid;
	import flash.geom.Point;
	
	public class AStarComponent extends Component implements IAStarComponent
	{
		// -------------------------------------------------------
		// Statics & Constants
		// -------------------------------------------------------
		
		
		// -------------------------------------------------------
		// Variables
		// -------------------------------------------------------
		
		private var aStarGrid						:AStarGrid;
		private var aStar							:AStar;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function AStarComponent() 
		{
		}	
		
		// -------------------------------------------------------
		// Public Functions
		// -------------------------------------------------------
		
		public function setGrid($grid:Array):void
		{
			aStarGrid = new AStarGrid();	
			aStarGrid.buildGrid($grid);
			aStar = new AStar(aStarGrid, aStarGrid.columns, aStarGrid.rows);
		}
		
		public function findPath($start:Point, $end:Point, $diagonals:Boolean = false, $closest:Boolean = true, $heuristic:String = ""):Vector.<Point>
		{
			if(aStar)
				return aStar.findPath($start, $end, $diagonals, $closest, $heuristic);
			else
				Logger.error("AStarComponent - aStar has not been set.");
				
			return null;
		}
		
		
		
		public function updateGrid():void
		{
			//aStar.updateGrid();
		}
		
		// -------------------------------------------------------
		// Event Handlers
		// -------------------------------------------------------
		
		// -------------------------------------------------------
		// Getters & Setters
		// -------------------------------------------------------
		
	}	
}