/**
* A* Component
* 
* Dependancies on AStarGrid version 1.0.0 and
* aStar version 1.0.0
* 
* @author Adam
*/

package aholla.henginex.components.astar 

import aholla.henginex.core.entity.Component;
import aholla.henginex.core.Logger;
import aholla.utils.pathfinding.astar.AStar;
import aholla.utils.pathfinding.astar.AStarGrid;
import flash.geom.PoInt;

class AStarComponent extends Component implements IAStarComponent
{
	private var aStarGrid						:AStarGrid;
	private var aStar							:AStar;
	
/*-------------------------------------------------
* CONSTRUCTOR
-------------------------------------------------*/

	public function AStarComponent() 
	{
	}	
	
/*-------------------------------------------------
* PUBLIC METHODS
-------------------------------------------------*/
	
	public function setGrid(grid:Array):Void
	{
		aStarGrid = new AStarGrid();	
		aStarGrid.buildGrid(grid);
		aStar = new AStar(aStarGrid, aStarGrid.columns, aStarGrid.rows);
	}
	
	public function findPath(start:PoInt, end:PoInt, diagonals:Bool = false, closest:Bool = true, heuristic:String = ""):Vector.<PoInt>
	{
		if(aStar)
			return aStar.findPath(start, end, diagonals, closest, heuristic);
		else
			Logger.error("AStarComponent - aStar has not been set.");
			
		return null;
	}	
	
	
	public function updateGrid():Void
	{
		//aStar.updateGrid();
	}
	
	
/*-------------------------------------------------
* PRIVATE METHODS
-------------------------------------------------*/
	
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
}	
