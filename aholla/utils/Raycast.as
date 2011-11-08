package com.aholla.utils
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author 
	 */
	public class Raycast 
	{
		
		private static var 	_instance		:Raycast;
		private static var 	_allowInstance	:Boolean;
		
		private var rayI		:uint = 0;
		private var rayStart	:Point = new Point();
		private var rayEnd		:Point = new Point();
		private var px			:uint;
		private var alpha		:Number;
		private var dx			:Number;
		private var dy			:Number;
			
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/	

		public function Raycast() 
		{
			if (!Raycast._allowInstance)
			{
				throw new Error("Error: Use Raycast.inst() instead of the new keyword.");
			}
		}
		
		public static function inst():Raycast
		{
			if (Raycast._instance == null)
			{
				Raycast._allowInstance 	= true;
				Raycast._instance 		= new Raycast();
				Raycast._allowInstance 	= false;
			}
			return Raycast._instance;
		}	
		
		public static function destroy():void
		{
			if (Raycast._instance == null)
			{
				Raycast._instance = null;
			}
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/

		
		
		public function cast($x:int, $y:int, $a:Number, $r:int, $m:BitmapData, $c:uint, $p:int = 5, $alphaTol:int = 255):Point
		{
			rayStart.x = rayEnd.x = $x;
			rayStart.y = rayEnd.y = $y;
			dx = Math.cos($a) * $p;
			dy = Math.sin($a) * $p;
			for (rayI = 0; rayI < $r; rayI+=$p) 
			{
				px = $m.getPixel32(rayEnd.x, rayEnd.y);			
				alpha = ((px & $c) >> 16);				
				if (alpha == $alphaTol)
				{
					break;
				}
				rayEnd.x += dx;
				rayEnd.y += dy;
			}
			return rayEnd.subtract(rayStart);
		}	
		
		public function cast2($x:int, $y:int, $a:Number, $r:int, $m:BitmapData, $c:uint, $p:int = 5, $alphaTol:int = 255):Boolean
		{
			rayStart.x = rayEnd.x = $x;
			rayStart.y = rayEnd.y = $y;
			dx = Math.cos($a) * $p;
			dy = Math.sin($a) * $p;
			
			for (rayI = 0; rayI <= $r; rayI+=$p) 
			{
				px = $m.getPixel32(rayEnd.x, rayEnd.y);			
				alpha = ((px & $c) >> 16);
				if (alpha == $alphaTol)	
				{
					return true;
				}
				rayEnd.x += dx;
				rayEnd.y += dy;
			}
			return false;
		}

	}
	
}

