/**
* ...
* @author Adam
*/

package aholla.HEngine;

import aholla.hxhengine.core.Logger;
import aholla.utils.pathfinding.astar.AStar;
import aholla.utils.pathfinding.astar.AStarGrid;
import flash.geom.PoInt;	

class HEGrid
{
	public static const MANHATTAN					:String = "hs_manhattan";		
	public static const EUCLIDEAN					:String = "hs_euclidean";
	
	public static var aStar							:AStar;
	public static var aStarGrid						:AStarGrid;
	public static var grid							:Array = [];
	public static var collisionTiles				:Array = [];
	public static var gridH							:Int;
	public static var gridW							:Int;		
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new()
	{
		
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	public static function initGrid(arr:Array):Void
	{
		HEGrid.grid = arr;
	}
	
	public static function initAStarGrid(arr:Array, collisionTiles:Array):Void
	{
		if (arr.length < 1)
		{
			Logger.error("HEGrid.initAStarGrid - grid is not specified or big enough.");
			return;
		}
		
		collisionTiles = collisionTiles.concat();
		
		HEGrid.grid = arr;				
		HEGrid.aStarGrid = new AStarGrid();	
		HEGrid.aStarGrid.buildGrid(HEGrid.grid, collisionTiles);
		HEGrid.aStar = new AStar(HEGrid.aStarGrid, HEGrid.aStarGrid.columns, HEGrid.aStarGrid.rows);
		HEGrid.gridH = grid.length;
		HEGrid.gridW = grid[0].length;
		
	}
	
	/**
	 * Find a path from a start poInt to an end poInt - if the start or end poInts are outside the grid dimensions the search will return <i>null</i>. 
	 * @param start The poInt at which the path begins.
	 * @param end The poInt the path is searching for.
	 * @param heuristic The type of heuristic to be used in calculating the path - speed and accuracy may differ.
	 * @param diagonals Whether or not the path can move diagonaly.
	 * @param closest Whether or not the path will get as close as it can to its destination during a failed search - if false it wont move at all.
	 * @return A <i>Vector</i> of poInts from start to finish. 
	 */
	public static function findAStarPath(start:PoInt, end:PoInt, diagonals:Bool = false, closest:Bool = true, heuristic:String = "hs_manhattan"):Vector.<PoInt>
	{
		if (HEGrid.aStar)
		{
			//return HEGrid.aStar.findPath(start, end, diagonals, closest, heuristic);
			return HEGrid.aStar.findPath(start, end, diagonals, closest, "hs_euclidean");
		}
		else
			Logger.error("HEGrid.findAStarPath - aStar has not been set.");
			
		return null;
	}
	
	public static function updateGrid():Void
	{
		HEGrid.aStarGrid.buildGrid(HEGrid.grid, collisionTiles);
		HEGrid.aStar.setGrid(HEGrid.aStarGrid);
	}
	
	public static function returnTile(poInt:PoInt, tileW:Int, tileH:Int):Int
	{
		var _x:Int = Int(poInt.x / tileW);
		var _y:Int = Int(poInt.y / tileH);
		return HEGrid.grid[_y][_x];
	}
	
	//public static function raycast(x:Int, y:Int, a:Float, r:Int, m:BitmapData, c:Uint, p:Int = 5, alphaTol:Int = 255):PoInt
	//{
		//rayStart.x = rayEnd.x = x;
		//rayStart.y = rayEnd.y = y;
		//dx = Math.cos(a) * p;
		//dy = Math.sin(a) * p;
		//for (rayI = 0; rayI < r; rayI+=p) 
		//{
			//px = m.getPixel32(rayEnd.x, rayEnd.y);			
			//alpha = ((px & c) >> 16);				
			//if (alpha == alphaTol)
			//{
				//break;
			//}
			//rayEnd.x += dx;
			//rayEnd.y += dy;
		//}
		//return rayEnd.subtract(rayStart);
	//}
	
	
	public static function raycast(start:PoInt, dest:PoInt, radius:Int, tileW:Int, tileH:Int, collision:Int = 1, precision:Float = 10):PoInt
	{
		var rayPoInt:PoInt 	= new PoInt(start.x, start.y);			
		var dx		:Float = (dest.x + radius) - (rayPoInt.x + radius);
		var dy		:Float = (dest.y + radius) - (rayPoInt.y + radius);			
		var dist	:Int 	= Math.sqrt(dx * dx + dy * dy);
		var angle	:Float = Math.atan2(dy, dx);
		
		dx = Math.cos(angle) * precision;
		dy = Math.sin(angle) * precision;
		
		var topL	:PoInt = new PoInt();
		var topR	:PoInt = new PoInt();
		var bottomL	:PoInt = new PoInt();
		var bottomR	:PoInt = new PoInt();
		
		var padd	:Int = 1;
		
		for (var i:Int = 0; i < dist; i += precision) 
		{
			// do a check her for the direction so that i only check in one direction.
			topL.x 		= Int((rayPoInt.x - radius - padd) / tileW);
			topL.y 		= Int((rayPoInt.y - radius - padd) / tileH);				
			topR.x 		= Int((rayPoInt.x + radius + padd) / tileW);
			topR.y 		= Int((rayPoInt.y - radius - padd) / tileH);				
			bottomL.x 	= Int((rayPoInt.x - radius - padd) / tileW);
			bottomL.y 	= Int((rayPoInt.y + radius + padd) / tileH);				
			bottomR.x 	= Int((rayPoInt.x + radius + padd) / tileW);
			bottomR.y 	= Int((rayPoInt.y + radius + padd) / tileH);
			
			//topL
			if (grid[topL.y][topL.x] == collision)
			{
				//trace("topL Collison");	
				rayPoInt.x -= dx * 1.2;
				rayPoInt.y -= dy * 1.2;
				return rayPoInt;
			}				
			//  topR
			if (grid[topR.y][topR.x] == collision)
			{
				//trace("topR Collison")
				rayPoInt.x -= dx * 1.2; 
				rayPoInt.y -= dy * 1.2;
				return rayPoInt;
			}				
			//  bottomL
			if (grid[bottomL.y][bottomL.x] == collision)
			{
				//trace("bottomL Collison");
				rayPoInt.x -= dx * 1.2;
				rayPoInt.y -= dy * 1.2; 
				return rayPoInt;
			}					
			//  bottomR
			if (grid[bottomR.y][bottomR.x] == collision)
			{
				//trace("bottomR Collison");
				rayPoInt.x -= dx * 1.2; 
				rayPoInt.y -= dy * 1.2; 
				return rayPoInt;
			}
			rayPoInt.x += dx;
			rayPoInt.y += dy;				
		}
		
		rayPoInt.x = dest.x;
		rayPoInt.y = dest.y;
		
		return rayPoInt;
	}
	
	
	public static function raycast2(start:PoInt, dest:PoInt, w:Int, h:Int, tileW:Int, tileH:Int, collision:Array, precision:Float = 10):PoInt
	{
		var rayPoInt:PoInt 	= new PoInt(start.x, start.y);			
		var dx		:Float = (dest.x + w) - (rayPoInt.x + w);
		var dy		:Float = (dest.y + h) - (rayPoInt.y + h);			
		var dist	:Int 	= Math.sqrt(dx * dx + dy * dy);
		var angle	:Float = Math.atan2(dy, dx);
		
		dx = Math.cos(angle) * precision;
		dy = Math.sin(angle) * precision;
		
		var topL	:PoInt = new PoInt();
		var topR	:PoInt = new PoInt();
		var bottomL	:PoInt = new PoInt();
		var bottomR	:PoInt = new PoInt();
		
		var padd	:Int = 1;
		
		var collLen:Int = collision.length;
		
		for (var i:Int = 0; i < dist; i += precision) 
		{
			// do a check her for the direction so that i only check in one direction.
			topL.x 		= Int((rayPoInt.x - w - padd) / tileW);
			topL.y 		= Int((rayPoInt.y - h - padd) / tileH);				
			topR.x 		= Int((rayPoInt.x + w + padd) / tileW);
			topR.y 		= Int((rayPoInt.y - h - padd) / tileH);				
			bottomL.x 	= Int((rayPoInt.x - w - padd) / tileW);
			bottomL.y 	= Int((rayPoInt.y + h + padd) / tileH);				
			bottomR.x 	= Int((rayPoInt.x + w + padd) / tileW);
			bottomR.y 	= Int((rayPoInt.y + h + padd) / tileH);
			
			for (var j:Int = 0; j < collLen; j++) 
			{
				var _collision:Int = collision[j];
				
				//topL
				if (grid[topL.y][topL.x] == _collision)
				{
					trace("topL Collison");	
					rayPoInt.x -= dx;
					rayPoInt.y -= dy;
					return rayPoInt;
				}				
				//  topR
				if (grid[topR.y][topR.x] == _collision)
				{
					trace("topR Collison")
					rayPoInt.x -= dx; 
					rayPoInt.y -= dy; 
					return rayPoInt;
				}				
				//  bottomL
				if (grid[bottomL.y][bottomL.x] == _collision)
				{
					trace("bottomL Collison");
					rayPoInt.x -= dx; 
					rayPoInt.y -= dy; 
					return rayPoInt;
				}			
				//  bottomR
				if (grid[bottomR.y][bottomR.x] == _collision)
				{
					trace("bottomR Collison");
					rayPoInt.x -= dx; 
					rayPoInt.y -= dy; 
					return rayPoInt;
				}
				
			}				
			
			rayPoInt.x += dx;
			rayPoInt.y += dy;				
		}
		
		rayPoInt.x = dest.x;
		rayPoInt.y = dest.y;
		
		return rayPoInt;
	}
	
	
	//public static function hasLOS(start:PoInt, dest:PoInt, radius:Int = 0, tileW:Int = 0, tileH:Int = 0, collision:Int = 1, precision:Float = 10):Bool
	public static function hasLOS(start:PoInt, dest:PoInt, tileW:Int, tileH:Int, collisionArr:Array, precision:Float = 10):Bool
	{
		var radius:Int = 1;
		if (start && dest)
		{
			var rayPoInt	:PoInt 	= new PoInt(start.x, start.y);
			var tilePoInt	:PoInt = new PoInt();
			var dx			:Float = (dest.x + radius) - (rayPoInt.x + radius);
			var dy			:Float = (dest.y + radius) - (rayPoInt.y + radius);			
			var dist		:Int 	= Math.sqrt(dx * dx + dy * dy);
			var angle		:Float = Math.atan2(dy, dx);
			
			dx = Math.cos(angle) * precision;
			dy = Math.sin(angle) * precision;
			
			for (var i:Int = 0; i < dist; i += precision) 
			{
				tilePoInt.x = Int(rayPoInt.x / tileW);
				tilePoInt.y = Int(rayPoInt.y / tileH);
				
				if (grid[tilePoInt.y][tilePoInt.x])
				{
					for (var j:Int = 0; j < collisionArr.length; j++) 
					{
						var _collisionTile:Int = collisionArr[j];							
						if (Int(grid[tilePoInt.y][tilePoInt.x]) == _collisionTile)	return false;					
					}
				}
				
				rayPoInt.x += dx;
				rayPoInt.y += dy;
			}				
			return true;
		}
		else
		{
			Logger.error("HEGrid - hasLOS(): No startPos or destPos specified.");
			return false;
		}
	}
	
	public static function destroy():Void
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