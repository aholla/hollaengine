/**
 * This is an optimised version of the origional A* version.
 * It used 2 new "flagged" arrays for flagging node and increases 
 * lookup times.
 * Fast but the version with binary Heaps is faster.
 * 26 / 08 / 2010
 * 
 * 
 * VERSION 1.0.0.
 * 
 * @author Adam & Joe
 * 
 **/

package aholla.utils.pathfinding.astar
{
	import flash.geom.Point;
	import flash.utils.getTimer;

	public final class AStar
	{
		// -------------------------------------------------------
		// Statics & Constants
		// -------------------------------------------------------
		
		private static const COST_ORTHOGONAL						:int = 10;
		private static const COST_DIAGONAL							:int = 14;		
		
		public static const MANHATTAN								:String = "hs_manhattan";		
		public static const EUCLIDEAN								:String = "hs_euclidean";
		
		// -------------------------------------------------------
		// Variables
		// -------------------------------------------------------
		
		private var grid											:IAStarGrid;
		private var rows											:int;
		private var columns											:int;
		
		private var nodes											:Vector.<Vector.<AStarNode>>;
		private var open											:Vector.<AStarNode>;
		private var closed											:Vector.<AStarNode>;		
		private var flaggedOpen										:Vector.<Vector.<Boolean>>;
		private var flaggedClosed									:Vector.<Vector.<Boolean>>;
		private var solution										:Vector.<Point>;
		
		// -------------------------------------------------------
		// Public Functions
		// -------------------------------------------------------
				
		/**
		 * Creates a new instance of <i>AStar</i>.
		 * @param $grid
		 * @param $columns
		 * @param $rows
		 * 
		 */
		public function AStar($grid:IAStarGrid, $columns:int, $rows:int)
		{
			grid 	= $grid;
			columns = $columns;
			rows 	= $rows;			
			init();
		}			
		
		
		/**
		 * Find a path from a start point to an end point - if the start or end points are outside the grid dimensions the search will return <i>null</i>. 
		 * @param $start The point at which the path begins.
		 * @param $end The point the path is searching for.
		 * @param $heuristic The type of heuristic to be used in calculating the path - speed and accuracy may differ.
		 * @param $diagonals Whether or not the path can move diagonaly.
		 * @param $closest Whether or not the path will get as close as it can to its destination during a failed search - if false it wont move at all.
		 * @return A <i>Vector</i> of points from start to finish. 
		 * 
		 */
		public function findPath($start:Point, $end:Point, $diagonals:Boolean = false, $closest:Boolean = true, $heuristic:String = MANHATTAN):Vector.<Point>
		{	
			//trace("AStar - findPath. start:", $start, "end:", $end);
			
			if ($heuristic == "") $heuristic = MANHATTAN;
			
			if ($start.x < 0 || $start.y < 0 || $end.x < 0 || $end.y < 0) return null;
			if ($start.x > columns - 1 || $end.x > columns - 1) return null;
			if ($start.y > rows - 1 || $end.y > rows - 1) return null;
			
			for (var ii:int = 0; ii < rows; ii ++)
			{
				for (var jj:int = 0; jj < columns; jj ++)
				{
					flaggedOpen[ii][jj] 	= false;
					flaggedClosed[ii][jj] 	= false;
				}
			}			
			
			open.length 	= 0;
			closed.length 	= 0;
			
			var startNode	:AStarNode = nodes[$start.y][$start.x];
			var endNode		:AStarNode = nodes[$end.y][$end.x];		
			
			open[open.length] = startNode;
			flaggedOpen[$start.y][$start.x] = true;
			
			startNode.g = 0;
			startNode.h = getHeuristic(startNode, endNode);
			startNode.f = startNode.g + startNode.h;
			startNode.parent = null;
			
			while (open.length)
			{				
				var index:int;
				var lowestA:Number = Number.POSITIVE_INFINITY;
				var lowestNodeA:AStarNode;				
				var lengthA:int = open.length;
				for (var i:int = 0; i < lengthA; i ++)
				{
					var n:AStarNode = open[i];
					if (n.f < lowestA)
					{
						index = i;
						lowestNodeA = n;						
						lowestA = lowestNodeA.f;
					}
				}				
				
				if (lowestNodeA == endNode)
				{								
					solution = sortSolution(endNode);
					return solution.length ? solution : null;										
				}
				else
				{
					// heap dequeue first item.
					open.splice(index, 1);
					flaggedOpen[lowestNodeA.y][lowestNodeA.x] = false;
					
					//closed.push(lowestNodeA);
					closed[closed.length] = lowestNodeA;
					flaggedClosed[lowestNodeA.y][lowestNodeA.x] = true;
					
					var nn:AStarNode;
					var neighbors:Vector.<AStarNode> = getNeighbors(lowestNodeA, $diagonals);				
					var lengthB:int = neighbors.length;
					for (var j:int = 0; j < lengthB; j ++)
					{
						nn = neighbors[j];						
						if (flaggedClosed[nn.y][nn.x]) 
							continue;						
						
						var g:Number = lowestNodeA.g + nn.cost;
						var better:Boolean = false;						
						
						if(!flaggedOpen[nn.y][nn.x])
						{		
							// heap queue nn.							
							open[open.length] = nn;
							flaggedOpen[nn.y][nn.x] = true;
							better = true;
						}
						else if (g < nn.g)
						{
							better = true;
						}						
						if (better)
						{																					
							nn.g = g;		
							nn.h = getHeuristic(nn, endNode);					
							nn.f = nn.g + nn.h;
							nn.parent = lowestNodeA;
						}
					}
				}
			}			
			if ($closest)
			{				
				var nnn:AStarNode;
				var dist:Number;
				var lowestB:Number = Number.POSITIVE_INFINITY;
				var lowestNodeB:AStarNode;
				var lengthC:int = closed.length;
				for (var m:int = 0; m < lengthC; m ++)
				{
					nnn = closed[m];					
					dist = getHeuristic(nnn, endNode);					
					if (dist < lowestB)
					{
						lowestB = dist;
						lowestNodeB = nnn;
					}
				}	
				solution = sortSolution(lowestNodeB);
				return solution.length ? solution : null;
			}
			return null;
		}	
		
		/**
		 * Sets the grid the <i>Astar</i>. 
		 * @param $grid
		 * 
		 */
		public function setGrid($grid:IAStarGrid):void
		{			
			grid = $grid;
			updateGrid();			
		}
		
		/**
		 * Updates the current grid - use this function if you change the current grids structure. 
		 * 
		 */
		public function updateGrid():void
		{
			nodes 			= new Vector.<Vector.<AStarNode>>;
			flaggedOpen 	= new Vector.<Vector.<Boolean>>;
			flaggedClosed 	= new Vector.<Vector.<Boolean>>;
			
			for (var i:int = 0; i < rows; i ++)
			{
				nodes[i] 			= new Vector.<AStarNode>;
				flaggedOpen[i]		= new Vector.<Boolean>;
				flaggedClosed[i]	= new Vector.<Boolean>;
				
				for (var j:int = 0; j < columns; j ++)
				{
					var n:AStarNode = new AStarNode(j, i);
					n.walkable 		= grid.isWalkable(j, i);
					n.terrainCost 	= grid.getCost(j, i);
					nodes[i].push(n);
				}
			}	
		}
		
		public function destroy():void
		{
			nodes			= null;
			open 			= null;
			closed 			= null;
			flaggedOpen		= null;
			flaggedClosed	= null;
			solution		= null;
			grid			= null;
		}
		
		// -------------------------------------------------------
		// Private Functions
		// -------------------------------------------------------
		
		private function init():void
		{			
			open 			= new Vector.<AStarNode>;
			closed 			= new Vector.<AStarNode>;
			flaggedOpen		= new Vector.<Vector.<Boolean>>;
			flaggedClosed	= new Vector.<Vector.<Boolean>>;
			
			//flaggedOpen		= new Vector.< new Vector.<Boolean>(100, true)>(100, true);
			//flaggedClosed	= new Vector.< new Vector.<Boolean>(100, true)>(100, true);
			
			updateGrid();
			//trace("AStar - Initialized.");
		}
		
		private var heur:Number;
		
		//private function getHeuristic($nodeA:AStarNode, $nodeB:AStarNode, $heuristic:String):Number
		private function getHeuristic($nodeA:AStarNode, $nodeB:AStarNode):Number
		{
			//var h:Number;
			//switch ($heuristic)
			//{
				//case MANHATTAN :
					//h = Math.abs($nodeA.x - $nodeB.x) + Math.abs($nodeA.y - $nodeB.y);
					//break;
				//case EUCLIDEAN :
					//h = Math.sqrt(Math.pow(($nodeA.x - $nodeB.x), 2) + Math.pow(($nodeA.y - $nodeB.y), 2));
					//break;
			//}
			//return h;
			
			heur = Math.abs($nodeA.x - $nodeB.x) + Math.abs($nodeA.y - $nodeB.y);
			return heur;
		}
			
		private var listL:int;
		
		private function getNeighbors($node:AStarNode, $diagonals:Boolean):Vector.<AStarNode>
		{						
			var list:Vector.<AStarNode> = new Vector.<AStarNode>;					
			var x:int = $node.x;
			var y:int = $node.y;
			var n:AStarNode;
			listL = 0;
			
			if (x > 0)
			{
				n = nodes[y][x - 1];
				if (n.walkable)
				{
					n.cost = COST_ORTHOGONAL + n.terrainCost;
					//list.push(n);	
					list[listL] = n;
					listL++;
				}
			}					
			if (x < columns - 1)
			{
				n = nodes[y][x + 1];
				if (n.walkable)
				{
					n.cost = COST_ORTHOGONAL + n.terrainCost;
					//list.push(n);	
					list[listL] = n;
					listL++;
				}
			}					
			if (y > 0)
			{
				n = nodes[y - 1][x];
				if (n.walkable)
				{
					n.cost = COST_ORTHOGONAL + n.terrainCost;
					//list.push(n);	
					list[listL] = n;
					listL++;
				}
			}					
			if (y < rows - 1)
			{
				n = nodes[y + 1][x];
				if (n.walkable)
				{
					n.cost = COST_ORTHOGONAL + n.terrainCost;
					//list.push(n);	
					list[listL] = n;
					listL++;
				}
			}
			
			if ($diagonals)
			{
				if (x > 0 && y > 0)
				{
					n = nodes[y - 1][x - 1];
					if (n.walkable)
					{
						n.cost = COST_DIAGONAL + n.terrainCost;
						//list.push(n);	
						list[listL] = n;
						listL++;						
					}
				}					
				if (x < columns - 1 && y < rows - 1)
				{
					n = nodes[y + 1][x + 1];
					if (n.walkable)
					{
						n.cost = COST_DIAGONAL + n.terrainCost;
						//list.push(n);	
						list[listL] = n;
						listL++;	
					}
				}					
				if (x < columns - 1 && y > 0)
				{
					n = nodes[y - 1][x + 1];
					if (n.walkable)
					{
						n.cost = COST_DIAGONAL + n.terrainCost;
						//list.push(n);	
						list[listL] = n;
						listL++;
					}
				}					
				if (y < rows - 1 && x > 0)
				{
					n = nodes[y + 1][x - 1];
					if (n.walkable)
					{
						n.cost = COST_DIAGONAL + n.terrainCost;
						//list.push(n);	
						list[listL] = n;
						listL++;
					}
				}
			}
			return list;
		}
		
		private function sortSolution(n:AStarNode):Vector.<Point>
		{
			var node:AStarNode = n;					
			var solution:Vector.<Point> = new Vector.<Point>;					
			while (node.parent)
			{
				solution.unshift(new Point(node.x, node.y));						
				node = node.parent;
			}			
			return solution;
		}		
		
		// -------------------------------------------------------
		// Event Handlers
		// -------------------------------------------------------
		
		// -------------------------------------------------------
		// Getters & Setters
		// -------------------------------------------------------
		
	}	
	
}