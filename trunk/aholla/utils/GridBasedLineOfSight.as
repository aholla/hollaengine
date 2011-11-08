/**
 * ...
 * @author Adam
 * 
 * GRID BASED LINE OF SIGHT
 * 
 * Based on electrotanks script but modified to include a function for checking simple collision. 
 * SOURCE: http://jobemakar.wordpress.com/2010/09/15/bresenhams-line-algorithm-in-actionscript/ 
 * Uses the BRESENHAM algorithm: http://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
 */


package aholla.utils
{
	import flash.geom.Point;

	public class GridBasedLineOfSight 
	{
		private static var 	_instance		:GridBasedLineOfSight;
		private static var 	_allowInstance	:Boolean;
		
		private var touched					:Array;
		private var startX						:int;
		private var startY						:int;
		private var endX						:int;
		private var endY						:int;
		private var steep					:Boolean;
		private var ystep					:int;
		private var startX_old					:int;
		private var startY_old					:int;
		private var deltax					:int;
		private var deltay					:int;
		private var error					:int;
		private var y						:int;
		private var x						:int;
		private var hasLos					:Boolean;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function GridBasedLineOfSight() 
		{
			if (!GridBasedLineOfSight._allowInstance)
			{
				throw new Error("Error: Use GridBasedLineOfSight.inst instead of the new keyword.");
			}
		}
		
		public static function get inst():GridBasedLineOfSight
		{
			if (GridBasedLineOfSight._instance == null)
			{
				GridBasedLineOfSight._allowInstance	= true;
				GridBasedLineOfSight._instance		= new GridBasedLineOfSight();
				GridBasedLineOfSight._allowInstance	= false;
			}
			return GridBasedLineOfSight._instance;
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * RETURN AN ARRAY OF POINTS THAT CREATE THE GRID BASED LINE OF SIGHT.
		 * @param	$p0 - Starting Point
		 * @param	$p1 - End Point
		 * @return
		 */
		public function returnLineOfSight($startPoint:Point, $endPoint:Point):Array 
		{
			touched = [];
			
			startX 	= $startPoint.x;
			startY 	= $startPoint.y;
			endX 	= $endPoint.x;
			endY 	= $endPoint.y;
			
			steep = Math.abs(endY - startY) > Math.abs(endX - startX);
			
			if (steep) 
			{
				startX 	= $startPoint.y;
				startY 	= $startPoint.x;
				endX 	= $endPoint.y;
				endY 	= $endPoint.x;
			}
			
			if (startX > endX) 
			{
				startX_old = startX;
				startY_old = startY;
				
				startX = endX;
				endX = startX_old;
				startY = endY;
				endY = startY_old;
			}
			
			deltax 	= endX - startX;
			deltay 	= Math.abs(endY - startY);
			error 	= deltax / 2;
			y 		= startY;
			
			if (startY < endY) 
			{
				ystep = 1;
			} 
			else 
			{
				ystep = -1;
			}
			
			for (x = startX; x <= endX;++x) 
			{
				if (steep) 
					touched[touched.length] = new Point(y, x);
				else 
					touched[touched.length] = new Point(x, y);
					
				error = error - deltay;
				
				if (error < 0) 
				{
					y = y + ystep;
					error = error + deltax;
				}
			}
			
			return touched;
		}
		
		/**
		 * RUNS THOUGH THE GRID AND RETURNS TRUE IF IT REACHES THE END POINT. 
		 * IF THE TILE UNDER TEH POINT HAS TEH SEARCH(WALL) PARAM IT RETURNS A FALSE.
		 * 
		 * @param	$p0 	- Starting Point
		 * @param	$p1 	- End Point
		 * @param	$arr 	- The data array of the tiles
		 * @param	$search - teh search parameter for the data tiles.
		 * @return
		 */
		public function hasLineOfSight($startPoint:Point, $endPoint:Point, $arr:Array, $search:int):Boolean 
		{
			hasLos = true;
			
			touched = [];
			
			startX 	= $startPoint.x;
			startY 	= $startPoint.y;
			endX 	= $endPoint.x;
			endY 	= $endPoint.y;
			
			steep = Math.abs(endY - startY) > Math.abs(endX - startX);
			
			if (steep) 
			{
				startX 	= $startPoint.y;
				startY 	= $startPoint.x;
				endX 	= $endPoint.y;
				endY 	= $endPoint.x;
			}
			
			if (startX > endX) 
			{
				startX_old = startX;
				startY_old = startY;
				
				startX 	= endX;
				endX 	= startX_old;
				startY 	= endY;
				endY 	= startY_old;
			}
			
			deltax 	= endX - startX;
			deltay 	= Math.abs(endY - startY);
			error 	= deltax / 2;
			y 		= startY;
			
			if (startY < endY) 
			{
				ystep = 1;
			} 
			else 
			{
				ystep = -1;
			}
			
			for (x = startX; x <= endX;++x) 
			{
				trace("IN")
				
				if (steep) 
					touched[touched.length] = new Point(y, x);
				else 
					touched[touched.length] = new Point(x, y);
				
				error = error - deltay;
				
				if (error < 0) 
				{
					y = y + ystep;
					error = error + deltax;
				}
				
				if ($arr[y][x] == $search)
				{
					hasLos = false;
					return false;
				}
				
			}
			return hasLos;
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