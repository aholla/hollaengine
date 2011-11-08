/**
 * This class converts an Array into a grid that is 
 * searchable for A*. 
 * 
 * VERSION 1.0.0.
 * 
 * @author Adam & Joe
 */

package aholla.utils.pathfinding.astar
{
	
	public class AStarGrid implements IAStarGrid
	{
		private var _grid									:Array;
		private var _rows									:int;
		private var _columns								:int;
		private var _collision								:Array;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function AStarGrid() 
		{
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function buildGrid($arr:Array, $collisionTiles:Array):void
		{
			_grid 		= $arr; 
			_rows 		= _grid.length;
			_columns 	= _grid[0].length;
			_collision	= $collisionTiles;
		}
		
		public function isWalkable($x:int, $y:int):Boolean
		{
			for (var i:int = 0; i < _collision.length; i++) 
			{
				var _id:int = _collision[i];
				if (_grid[$y][$x] == _id)
				{
					return false;
				}
			}			
			return true;
		}
		
		public function getCost($x:int, $y:int):int
		{
			return int(_grid[$y][$x]);
		}
		
		public function destroy():void
		{
			_grid		= null;
			_collision	= null;
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		public function get grid():Array 			{ return _grid; }
		public function get rows():int 				{ return _rows; }
		public function get columns():int 			{ return _columns; }
		
		
	}
}