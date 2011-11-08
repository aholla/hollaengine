/*
 * ADAM
 * This is the origional A* version.
 * SLOW.
 * 26 / 08 / 2010
 * */


package aholla.utils.pathfinding.astar.other
{
	import flash.geom.Point;
	import flash.utils.getTimer;

	public final class AStar_Origional
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
		public function AStar_Origional
		($grid:IAStarGrid, $columns:int, $rows:int)
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
		public function findPath($start:Point, $end:Point, $diagonals:Boolean = false, $randomness:int = 0, $closest:Boolean = true, $heuristic:String = MANHATTAN):Vector.<Point>
		{				
			if ($start.x < 0 || $start.y < 0 || $end.x < 0 || $end.y < 0) return null;		
			if ($start.x > columns - 1 || $end.x > columns - 1) return null;			
			if ($start.y > rows - 1 || $end.y > rows - 1) return null;			
			
			open.length = 0;
			closed.length = 0;					
			
			var startNode	:AStarNode = nodes[$start.y][$start.x];
			var endNode		:AStarNode = nodes[$end.y][$end.x];		
			open.push(startNode);
			
			startNode.g = 0;
			startNode.h = getHeuristic(startNode, endNode, $heuristic);
			startNode.f = startNode.g + startNode.h;
			startNode.parent = null;
			
			while (open.length)
			{				
				var index:int;
				var lowestA:Number = Number.POSITIVE_INFINITY;;
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
					open.splice(index, 1);
					closed.push(lowestNodeA);					
					
					var nn:AStarNode;
					var neighbors:Vector.<AStarNode> = getNeighbors(lowestNodeA, $diagonals, $randomness);				
					var lengthB:int = neighbors.length;
					for (var j:int = 0; j < lengthB; j ++)
					{
						nn = neighbors[j];						
						if (-1 != closed.indexOf(nn)) 
							continue;						
						
						var g:Number = lowestNodeA.g + nn.cost;
						var better:Boolean = false;						
						
						//if (-1 == open.indexOf(nn))
						if (-1 == open.indexOf(nn))
						{		
							open.push(nn);							
							better = true;
						}
						else if (g < nn.g)
						{
							better = true;
						}						
						if (better)
						{																					
							nn.g = g;		
							nn.h = getHeuristic(nn, endNode, $heuristic);					
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
					dist = getHeuristic(nnn, endNode, $heuristic);					
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
			nodes 	= new Vector.<Vector.<AStarNode>>;
			for (var i:int = 0; i < rows; i ++)
			{
				nodes[i] 	= new Vector.<AStarNode>;
				for (var j:int = 0; j < columns; j ++)
				{
					var n:AStarNode = new AStarNode(j, i);
					n.walkable 		= grid.isWalkable(j, i);
					n.terrainCost 	= grid.getCost(j, i);
					nodes[i].push(n);
				}
			}	
			//trace("AStar - Grid updated.");
		}
		
		// -------------------------------------------------------
		// Private Functions
		// -------------------------------------------------------
		
		private function init():void
		{			
			open 	= new Vector.<AStarNode>;
			closed 	= new Vector.<AStarNode>;
			updateGrid();
			//trace("AStar - Initialized.");
		}
		
		private function getHeuristic($nodeA:AStarNode, $nodeB:AStarNode, $heuristic:String):Number
		{
			var h:Number;
			switch ($heuristic)
			{
				case MANHATTAN :
					h = Math.abs($nodeA.x - $nodeB.x) + Math.abs($nodeA.y - $nodeB.y);
					break;
				case EUCLIDEAN :
					h = Math.sqrt(Math.pow(($nodeA.x - $nodeB.x), 2) + Math.pow(($nodeA.y - $nodeB.y), 2));
					break;
			}
			return h;
		}
		
		private function getNeighbors($node:AStarNode, $diagonals:Boolean, $randomness:int):Vector.<AStarNode>
		{						
			var list:Vector.<AStarNode> = new Vector.<AStarNode>;					
			var x:int = $node.x;
			var y:int = $node.y;
			var n:AStarNode;
			
			if (x > 0)
			{
				n = nodes[y][x - 1];
				if (n.walkable)
				{
					n.cost = COST_ORTHOGONAL + n.terrainCost + int(Math.random() * $randomness);
					list.push(n);						
				}
			}					
			if (x < columns - 1)
			{
				n = nodes[y][x + 1];
				if (n.walkable)
				{
					n.cost = COST_ORTHOGONAL + n.terrainCost + int(Math.random() * $randomness);
					list.push(n);
				}
			}					
			if (y > 0)
			{
				n = nodes[y - 1][x];
				if (n.walkable)
				{
					n.cost = COST_ORTHOGONAL + n.terrainCost + int(Math.random() * $randomness);
					list.push(n);
				}
			}					
			if (y < rows - 1)
			{
				n = nodes[y + 1][x];
				if (n.walkable)
				{
					n.cost = COST_ORTHOGONAL + n.terrainCost + int(Math.random() * $randomness);
					list.push(n);
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
						list.push(n);							
					}
				}					
				if (x < columns - 1 && y < rows - 1)
				{
					n = nodes[y + 1][x + 1];
					if (n.walkable)
					{
						n.cost = COST_DIAGONAL + n.terrainCost;
						list.push(n);
					}
				}					
				if (x < columns - 1 && y > 0)
				{
					n = nodes[y - 1][x + 1];
					if (n.walkable)
					{
						n.cost = COST_DIAGONAL + n.terrainCost;
						list.push(n);
					}
				}					
				if (y < rows - 1 && x > 0)
				{
					n = nodes[y + 1][x - 1];
					if (n.walkable)
					{
						n.cost = COST_DIAGONAL + n.terrainCost;
						list.push(n);
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