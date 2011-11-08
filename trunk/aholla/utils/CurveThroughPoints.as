/**
 * ...
 * @author Adam
 */

package com.aholla.utils 
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class CurveThroughPoints
	{	
		private var numSegments			:int;	
		private var display				:Sprite;
		private var path				:Array;
		private var pathFinal			:Array;
		private var p0					:Point;
		private var p1					:Point;
		private var p2					:Point;
		private var p3					:Point;
		private var t					:Number;
		private var sx					:int;
		private var sy					:int;
		private var v0					:Number
		private var v1					:Number
		private var isVisible			:Boolean;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function CurveThroughPoints($isVisible:Boolean = false) 
		{
			isVisible = $isVisible;
			if(isVisible)	display = new Sprite();
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function returnPoints($arr:Array, $numSegments:int = 10):Array
		{
			path 		= $arr;
			numSegments = $numSegments;		
			pathFinal 	= [];
			setPoints();			
			return pathFinal;
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		private function setPoints():void
		{
			var v:Vector.<Point> = new Vector.<Point>();
			for(var i:uint; i<path.length; i++)
			{
				v[i] = new Point(path[i].x, path[i].y);
			}
			
			if(isVisible)	display.graphics.clear();
			drawSpline(v);
		}
		
		private function drawSpline(v:Vector.<Point>):void
		{
			if (v.length < 2) 
			{
				pathFinal = path.concat();
				trace("Path too short, go directly to point")
				return;
			}
			v.splice(0,0,v[0]);
			v.push(v[v.length - 1]);
			
			for(var i:uint=0; i<v.length-3; i++)
			{
				p0 = v[i];
				p1 = v[i+1];
				p2 = v[i+2];
				p3 = v[i+3];
				splineTo(p0, p1, p2, p3, numSegments);
			}
		}		
		
		private function splineTo(p0:Point, p1:Point, p2:Point, p3:Point, numSegments:uint):void
		{
			if (isVisible)	
			{
				display.graphics.lineStyle(2, 0x666666, 1);
				display.graphics.moveTo(p1.x, p1.y);
			}
			
			for(var i:uint=0; i<numSegments; i++)
			{
				t = (i + 1) / numSegments;
				sx = catmullRom(p0.x, p1.x, p2.x, p3.x, t);
				sy = catmullRom(p0.y, p1.y, p2.y, p3.y, t);				
				pathFinal.push(new Point(sx, sy));	
				if (isVisible) display.graphics.lineTo(sx, sy);
			}
		}
		
		private function catmullRom(p0:Number, p1:Number, p2:Number, p3:Number, t:Number):Number
		{
			v0 = (p2 - p0) * 0.5;
			v1 = (p3 - p1) * 0.5;
			return (2*p1 - 2*p2 + v0 + v1)*t*t*t +(-3*p1 + 3*p2 - 2*v0 - v1)*t*t + v0*t + p1;
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		public function get _display():Sprite 
		{ 
			if(display)
				return display; 
			else
			{
				trace("No Display")
				return null;
			}
		}
		
	}
}