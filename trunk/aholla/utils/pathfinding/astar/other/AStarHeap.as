/*
 * ADAM
 * This is an optimised version with an un-typed Heap.
 * NOT THE LATEST FASTEST VERSION
 * 26 / 08 / 2010
 * */

 
  
 /*
  * NOTE NOT SURE THIS IS WORKING. SEEMED TO BE BUT NO LONGER......
  */ 


package aholla.utils.pathfinding.astar.other
{
	import AStar.AStarHeap;
	import de.polygonal.ds.Heap;
	import flash.geom.Point;
	import flash.utils.getTimer;

	public final class AStarHeap
	{
		// -------------------------------------------------------
		// Statics & Constants
		// -------------------------------------------------------
		
		private static const COST_ORTHOGONAL						:int = 10;
		private static const COST_DIAGONAL							:int = 14;		
		
		// -------------------------------------------------------
		// Variables
		// -------------------------------------------------------
		
		private var grid											:IAStarGrid;
		private var rows											:int;
		private var columns											:int;
		
		private var heap											:Heap;
		
		private var nodes											:Vector.<Vector.<AStarNode>>;
		private var open											:Vector.<AStarNode>;
		private var closed											:Vector.<AStarNode>;		
		private var flaggedOpen										:Vector.<Vector.<Boolean>>;
		private var flaggedClosed									:Vector.<Vector.<Boolean>>;
		private var solution										:Vector.<Point>;
		
		private var searchFunction									:Function = function(a:AStarNode, b:AStarNode):int { return b.f - a.f; };		
		
		private var i												:int;
		private var j												:int;
		private var ii												:int;
		private var jj												:int;
		
		private var lowestNodeA										:AStarNode;	
		
		private var nn												:AStarNode;
		private var neighbors										:Vector.<AStarNode> = new Vector.<AStarNode>	;
		private var lengthN											:int
		
		private var g												:Number
		private var better											:Boolean
		
		private var heur											:Number;
		
		private var list											:Vector.<AStarNode> = new Vector.<AStarNode>;					
		private var x												:int;
		private var y												:int;
		private var n												:AStarNode;
		private var listL											:int;	
		
		
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
		public function AStarHeap($grid:IAStarGrid, $columns:int, $rows:int)
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
		 * @param $diagonals Whether or not the path can move diagonaly.
		 * @param $closest Whether or not the path will get as close as it can to its destination during a failed search - if false it wont move at all.
		 * @return A <i>Vector</i> of points from start to finish. 
		 * 
		 */
		public function findPath($start:Point, $end:Point, $diagonals:Boolean = false, $closest:Boolean = true):Vector.<Point>
		{	
			heap = new Heap(10000, searchFunction);
			
			if ($start.x < 0 || $start.y < 0 || $end.x < 0 || $end.y < 0) return null;
			if ($start.x > columns - 1 || $end.x > columns - 1) return null;
			if ($start.y > rows - 1 || $end.y > rows - 1) return null;
			
			for (ii = 0; ii < rows; ii ++)
			{
				for (jj = 0; jj < columns; jj ++)
				{
					flaggedOpen[ii][jj] 	= false;
					flaggedClosed[ii][jj] 	= false;
				}
			}			
			
			open.length 	= 0;
			closed.length 	= 0;
			
			var startNode	:AStarNode = nodes[$start.y][$start.x];
			var endNode		:AStarNode = nodes[$end.y][$end.x];		
			
			heap.enqueue(startNode);			
			flaggedOpen[$start.y][$start.x] = true;
			
			startNode.g = 0;
			startNode.h = getHeuristic(startNode, endNode);
			startNode.f = startNode.g + startNode.h;
			startNode.parent = null;
			
			while (heap.size)
			{
				lowestNodeA = heap.front;
				
				if (lowestNodeA == endNode)
				{								
					solution = sortSolution(endNode);
					return solution.length ? solution : null;										
				}
				else
				{
					heap.dequeue();
					
					flaggedOpen[lowestNodeA.y][lowestNodeA.x] = false;
					
					closed.push(lowestNodeA);
					flaggedClosed[lowestNodeA.y][lowestNodeA.x] = true;
					
					neighbors = getNeighbors(lowestNodeA, $diagonals);
					lengthN = neighbors.length;					
					for (j = 0; j < lengthN; j ++)
					{
						nn = neighbors[j];						
						if (flaggedClosed[nn.y][nn.x]) 
							continue;						
						
						g = lowestNodeA.g + nn.cost;
						better = false;	
						
						if(!flaggedOpen[nn.y][nn.x])
						{		
							heap.enqueue(nn);
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
				var nnn			:AStarNode;
				var dist		:Number;
				var lowestB		:Number = Number.POSITIVE_INFINITY;
				var lowestNodeB	:AStarNode;
				var lengthC		:int = closed.length;
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
			
			for (i = 0; i < rows; i ++)
			{
				nodes[i] 			= new Vector.<AStarNode>;
				flaggedOpen[i]		= new Vector.<Boolean>;
				flaggedClosed[i]	= new Vector.<Boolean>;
				
				for (j = 0; j < columns; j ++)
				{
					var n:AStarNode = new AStarNode(j, i);
					n.walkable 		= grid.isWalkable(j, i);
					n.terrainCost 	= grid.getCost(j, i);
					nodes[i].push(n);
				}
			}	
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
			updateGrid();
		}
		
		private function getHeuristic($nodeA:AStarNode, $nodeB:AStarNode):Number
		{
			heur = Math.abs($nodeA.x - $nodeB.x) + Math.abs($nodeA.y - $nodeB.y);
			return heur;
		}
		
		private function getNeighbors($node:AStarNode, $diagonals:Boolean):Vector.<AStarNode>
		{						
			list.length 	= 0;
			x 				= $node.x;
			y 				= $node.y;
			listL 			= 0;
			
			if (x > 0)
			{
				n = nodes[y][x - 1];
				if (n.walkable)
				{
					n.cost = COST_ORTHOGONAL + n.terrainCost;
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