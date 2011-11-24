/**
 * ...
 * @author Adam
 */

package aholla.HEngine 
{
	import aholla.HEngine.core.Logger;
	import aholla.utils.pathfinding.astar.AStar;
	import aholla.utils.pathfinding.astar.AStarGrid;
	import flash.geom.Point;	
	
	public class HEGrid
	{
		public static const MANHATTAN					:String = "hs_manhattan";		
		public static const EUCLIDEAN					:String = "hs_euclidean";
		
		public static var aStar							:AStar;
		public static var aStarGrid						:AStarGrid;
		public static var grid							:Array = [];
		public static var collisionTiles				:Array = [];
		public static var gridH							:int;
		public static var gridW							:int;		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function HEGrid()
		{
			
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public static function initGrid($arr:Array):void
		{
			HEGrid.grid = $arr;
		}
		
		public static function initAStarGrid($arr:Array, $collisionTiles:Array):void
		{
			if ($arr.length < 1)
			{
				Logger.error("HEGrid.initAStarGrid - grid is not specified or big enough.");
				return;
			}
			
			collisionTiles = $collisionTiles.concat();
			
			HEGrid.grid = $arr;				
			HEGrid.aStarGrid = new AStarGrid();	
			HEGrid.aStarGrid.buildGrid(HEGrid.grid, collisionTiles);
			HEGrid.aStar = new AStar(HEGrid.aStarGrid, HEGrid.aStarGrid.columns, HEGrid.aStarGrid.rows);
			HEGrid.gridH = grid.length;
			HEGrid.gridW = grid[0].length;
			
		}
		
		/**
		 * Find a path from a start point to an end point - if the start or end points are outside the grid dimensions the search will return <i>null</i>. 
		 * @param $start The point at which the path begins.
		 * @param $end The point the path is searching for.
		 * @param $heuristic The type of heuristic to be used in calculating the path - speed and accuracy may differ.
		 * @param $diagonals Whether or not the path can move diagonaly.
		 * @param $closest Whether or not the path will get as close as it can to its destination during a failed search - if false it wont move at all.
		 * @return A <i>Vector</i> of points from start to finish. 
		 */
		public static function findAStarPath($start:Point, $end:Point, $diagonals:Boolean = false, $closest:Boolean = true, $heuristic:String = "hs_manhattan"):Vector.<Point>
		{
			if (HEGrid.aStar)
			{
				//return HEGrid.aStar.findPath($start, $end, $diagonals, $closest, $heuristic);
				return HEGrid.aStar.findPath($start, $end, $diagonals, $closest, "hs_euclidean");
			}
			else
				Logger.error("HEGrid.findAStarPath - aStar has not been set.");
				
			return null;
		}
		
		public static function updateGrid():void
		{
			HEGrid.aStarGrid.buildGrid(HEGrid.grid, collisionTiles);
			HEGrid.aStar.setGrid(HEGrid.aStarGrid);
		}
		
		public static function returnTile($point:Point, $tileW:int, $tileH:int):int
		{
			var _x:int = int($point.x / $tileW);
			var _y:int = int($point.y / $tileH);
			return HEGrid.grid[_y][_x];
		}
		
		//public static function raycast($x:int, $y:int, $a:Number, $r:int, $m:BitmapData, $c:uint, $p:int = 5, $alphaTol:int = 255):Point
		//{
			//rayStart.x = rayEnd.x = $x;
			//rayStart.y = rayEnd.y = $y;
			//dx = Math.cos($a) * $p;
			//dy = Math.sin($a) * $p;
			//for (rayI = 0; rayI < $r; rayI+=$p) 
			//{
				//px = $m.getPixel32(rayEnd.x, rayEnd.y);			
				//alpha = ((px & $c) >> 16);				
				//if (alpha == $alphaTol)
				//{
					//break;
				//}
				//rayEnd.x += dx;
				//rayEnd.y += dy;
			//}
			//return rayEnd.subtract(rayStart);
		//}
		
		
		public static function raycast($start:Point, $dest:Point, $radius:int, $tileW:int, $tileH:int, $collision:int = 1, $precision:Number = 10):Point
		{
			var rayPoint:Point 	= new Point($start.x, $start.y);			
			var dx		:Number = ($dest.x + $radius) - (rayPoint.x + $radius);
			var dy		:Number = ($dest.y + $radius) - (rayPoint.y + $radius);			
			var dist	:int 	= Math.sqrt(dx * dx + dy * dy);
			var angle	:Number = Math.atan2(dy, dx);
			
			dx = Math.cos(angle) * $precision;
			dy = Math.sin(angle) * $precision;
			
			var topL	:Point = new Point();
			var topR	:Point = new Point();
			var bottomL	:Point = new Point();
			var bottomR	:Point = new Point();
			
			var padd	:int = 1;
			
			for (var i:int = 0; i < dist; i += $precision) 
			{
				// do a check her for the direction so that i only check in one direction.
				topL.x 		= int((rayPoint.x - $radius - padd) / $tileW);
				topL.y 		= int((rayPoint.y - $radius - padd) / $tileH);				
				topR.x 		= int((rayPoint.x + $radius + padd) / $tileW);
				topR.y 		= int((rayPoint.y - $radius - padd) / $tileH);				
				bottomL.x 	= int((rayPoint.x - $radius - padd) / $tileW);
				bottomL.y 	= int((rayPoint.y + $radius + padd) / $tileH);				
				bottomR.x 	= int((rayPoint.x + $radius + padd) / $tileW);
				bottomR.y 	= int((rayPoint.y + $radius + padd) / $tileH);
				
				//topL
				if (grid[topL.y][topL.x] == $collision)
				{
					//trace("topL Collison");	
					rayPoint.x -= dx * 1.2;
					rayPoint.y -= dy * 1.2;
					return rayPoint;
				}				
				//  topR
				if (grid[topR.y][topR.x] == $collision)
				{
					//trace("topR Collison")
					rayPoint.x -= dx * 1.2; 
					rayPoint.y -= dy * 1.2;
					return rayPoint;
				}				
				//  bottomL
				if (grid[bottomL.y][bottomL.x] == $collision)
				{
					//trace("bottomL Collison");
					rayPoint.x -= dx * 1.2;
					rayPoint.y -= dy * 1.2; 
					return rayPoint;
				}					
				//  bottomR
				if (grid[bottomR.y][bottomR.x] == $collision)
				{
					//trace("bottomR Collison");
					rayPoint.x -= dx * 1.2; 
					rayPoint.y -= dy * 1.2; 
					return rayPoint;
				}
				rayPoint.x += dx;
				rayPoint.y += dy;				
			}
			
			rayPoint.x = $dest.x;
			rayPoint.y = $dest.y;
			
			return rayPoint;
		}
		
		
		public static function raycast2($start:Point, $dest:Point, $w:int, $h:int, $tileW:int, $tileH:int, $collision:Array, $precision:Number = 10):Point
		{
			var rayPoint:Point 	= new Point($start.x, $start.y);			
			var dx		:Number = ($dest.x + $w) - (rayPoint.x + $w);
			var dy		:Number = ($dest.y + $h) - (rayPoint.y + $h);			
			var dist	:int 	= Math.sqrt(dx * dx + dy * dy);
			var angle	:Number = Math.atan2(dy, dx);
			
			dx = Math.cos(angle) * $precision;
			dy = Math.sin(angle) * $precision;
			
			var topL	:Point = new Point();
			var topR	:Point = new Point();
			var bottomL	:Point = new Point();
			var bottomR	:Point = new Point();
			
			var padd	:int = 1;
			
			var collLen:int = $collision.length;
			
			for (var i:int = 0; i < dist; i += $precision) 
			{
				// do a check her for the direction so that i only check in one direction.
				topL.x 		= int((rayPoint.x - $w - padd) / $tileW);
				topL.y 		= int((rayPoint.y - $h - padd) / $tileH);				
				topR.x 		= int((rayPoint.x + $w + padd) / $tileW);
				topR.y 		= int((rayPoint.y - $h - padd) / $tileH);				
				bottomL.x 	= int((rayPoint.x - $w - padd) / $tileW);
				bottomL.y 	= int((rayPoint.y + $h + padd) / $tileH);				
				bottomR.x 	= int((rayPoint.x + $w + padd) / $tileW);
				bottomR.y 	= int((rayPoint.y + $h + padd) / $tileH);
				
				for (var j:int = 0; j < collLen; j++) 
				{
					var _collision:int = $collision[j];
					
					//topL
					if (grid[topL.y][topL.x] == _collision)
					{
						trace("topL Collison");	
						rayPoint.x -= dx;
						rayPoint.y -= dy;
						return rayPoint;
					}				
					//  topR
					if (grid[topR.y][topR.x] == _collision)
					{
						trace("topR Collison")
						rayPoint.x -= dx; 
						rayPoint.y -= dy; 
						return rayPoint;
					}				
					//  bottomL
					if (grid[bottomL.y][bottomL.x] == _collision)
					{
						trace("bottomL Collison");
						rayPoint.x -= dx; 
						rayPoint.y -= dy; 
						return rayPoint;
					}			
					//  bottomR
					if (grid[bottomR.y][bottomR.x] == _collision)
					{
						trace("bottomR Collison");
						rayPoint.x -= dx; 
						rayPoint.y -= dy; 
						return rayPoint;
					}
					
				}				
				
				rayPoint.x += dx;
				rayPoint.y += dy;				
			}
			
			rayPoint.x = $dest.x;
			rayPoint.y = $dest.y;
			
			return rayPoint;
		}
		
		
		//public static function hasLOS($start:Point, $dest:Point, $radius:int = 0, $tileW:int = 0, $tileH:int = 0, $collision:int = 1, $precision:Number = 10):Boolean
		public static function hasLOS($start:Point, $dest:Point, $tileW:int, $tileH:int, $collisionArr:Array, $precision:Number = 10):Boolean
		{
			var $radius:int = 1;
			if ($start && $dest)
			{
				var rayPoint	:Point 	= new Point($start.x, $start.y);
				var tilePoint	:Point = new Point();
				var dx			:Number = ($dest.x + $radius) - (rayPoint.x + $radius);
				var dy			:Number = ($dest.y + $radius) - (rayPoint.y + $radius);			
				var dist		:int 	= Math.sqrt(dx * dx + dy * dy);
				var angle		:Number = Math.atan2(dy, dx);
				
				dx = Math.cos(angle) * $precision;
				dy = Math.sin(angle) * $precision;
				
				for (var i:int = 0; i < dist; i += $precision) 
				{
					tilePoint.x = int(rayPoint.x / $tileW);
					tilePoint.y = int(rayPoint.y / $tileH);
					
					if (grid[tilePoint.y][tilePoint.x])
					{
						for (var j:int = 0; j < $collisionArr.length; j++) 
						{
							var _collisionTile:int = $collisionArr[j];							
							if (int(grid[tilePoint.y][tilePoint.x]) == _collisionTile)	return false;					
						}
					}
					
					rayPoint.x += dx;
					rayPoint.y += dy;
				}				
				return true;
			}
			else
			{
				Logger.error("HEGrid - hasLOS(): No startPos or destPos specified.");
				return false;
			}
		}
		
		public static function destroy():void
		{
			HEGrid.aStar.destroy();
			HEGrid.aStarGrid.destroy();
			HEGrid.aStar = null;
			HEGrid.aStarGrid = null;
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
		
		
		
	}
}