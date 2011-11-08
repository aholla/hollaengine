/**
 * ...
 * @author Adam
 */

package com.aholla.utils 
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class PieTimer extends Sprite
	{
		private var gfx						:Sprite;
		private var pTimer					:Timer
		private var time					:Number;
		private var radius					:Number;
		private var rotationStart			:Number;
		private var pAlpha					:Number;
		private var hasLine					:Boolean;
		private var isNegative				:Boolean;
		private var percentage				:Number;
		private var timeDelay				:Number;
		private var timeCount				:Number;
		private var second					:Number = 1000;
		private var pColour					:uint = 0xFF0000;	
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		/**
		 * Creates a PIE CHART style timer that times down.
		 * @param	$time - the time it takes to time down
		 * @param	$radius	- the radius of teh pie chart
		 * @param	$rotationStart - the starting point of teh pie chart
		 * @param	$colour - the colour of the pie chart
		 * @param	$alpha - the alpha of the pie chart
		 * @param	$hasLine - a linestyle is applied to the pie chart.
		 */
		public function PieTimer($time:Number, $radius:int, $rotationStart:int = -90, $colour:uint = 0xFF0000, $alpha:Number = 1, $hasLine:Boolean = false,  $isNegative:Boolean = false) 
		{
			time 	= $time;
			radius	= $radius;
			rotationStart = $rotationStart;
			pColour	= $colour;
			pAlpha	= $alpha;
			hasLine	= $hasLine;
			isNegative	= $isNegative;
			
			gfx = new Sprite();
			gfx.graphics.beginFill(0xFF0000, 1);
			gfx.graphics.drawCircle(0, 0, $radius);
			gfx.graphics.endFill();
			this.addChild(gfx);
			
			if (isNegative)
				gfx.scaleY *= -1;
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function startTimer():void
		{			
			if (!isNegative)
				percentage 	= 0;
			else
				percentage 	= 1;				
				
			timeDelay 	= second / 10;
			timeCount 	= time * 10;			
			//pTimer = new Timer(timeDelay, timeCount);// HAs a bug with some number steh fractions become too small.
			
			pTimer = new Timer(timeDelay, 0);
			pTimer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			pTimer.start();
		}	
		
		public function destroy():void
		{
			if (pTimer)
			{
				pTimer.stop()
				pTimer.removeEventListener(TimerEvent.TIMER, onTimer);
				pTimer = null;
			}
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		private function onTimer(e:TimerEvent):void 
		{		
			if (!isNegative)
				percentage += (timeDelay / timeCount) / 100;
			else
				percentage -= (timeDelay / timeCount) / 100;
				
			if (percentage < 0)	
			{
				percentage = 0;
				complete();
			}
			
			if (percentage > 1)
			{
				percentage = 1;
				complete();
			}
			//trace(percentage);
			
			DrawPieChart.drawChart(gfx, radius, percentage, pColour, rotationStart, pAlpha, hasLine);
		}
		
		private function complete():void 
		{
			destroy();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		
	}
}











/**
 * THIS CLASS IS TERRY PATONS BUT WRAPPED IN HERE TO ALLEVIATE PACKAGE DEPENDENCIES.
 */
import flash.display.Sprite;

internal class DrawPieChart 
{
	private static const CONVERT_TO_RADIANS:Number = Math.PI / 180;
	
	public function DrawPieChart() 
	{
		
	}
	
	public static function drawChart(_shape:Sprite, _radius:Number, _percent:Number, _colour:uint = 0xFF0000, _rotationOffset:Number = 0, _alpha:Number = 1, $hasLine:Boolean = false):void 
	{
		if (_percent > 1) 
			_percent = 1
		var angle:Number = 360 * _percent;
		
		if($hasLine)
			_shape.graphics.lineStyle(0, 0);
			
		_shape.graphics.clear();
		_shape.graphics.moveTo (0, 0);		
		_shape.graphics.beginFill (_colour, _alpha);		
		_shape.graphics.lineTo (_radius, 0);
		_shape.rotation = _rotationOffset
		
		var nSeg:Number = Math.floor (angle/30);
		var pSeg:Number = angle - nSeg * 30
		var a:Number = 0.268;
		
		for (var i:Number = 0; i < nSeg; i++) 
		{
			var endx:Number = _radius * Math.cos ((i + 1)* 30* CONVERT_TO_RADIANS);
			var endy:Number = _radius * Math.sin ((i + 1) * 30* CONVERT_TO_RADIANS);
			var ax:Number = endx + _radius * a * Math.cos (((i + 1)* 30  - 90) * CONVERT_TO_RADIANS);
			var ay:Number = endy + _radius * a * Math.sin (((i + 1)* 30  - 90) * CONVERT_TO_RADIANS);
			_shape.graphics.curveTo (ax,ay,endx,endy);
		}
		
		if (pSeg > 0) 
		{
			a = Math.tan (pSeg / 2 * CONVERT_TO_RADIANS);
			endx = _radius * Math.cos ((i* 30 + pSeg) * CONVERT_TO_RADIANS);
			endy = _radius * Math.sin ((i * 30 + pSeg) * CONVERT_TO_RADIANS);
			ax = endx + _radius * a * Math.cos ((i* 30+ pSeg - 90) * CONVERT_TO_RADIANS);
			ay = endy + _radius * a * Math.sin ((i* 30+ pSeg - 90) * CONVERT_TO_RADIANS);
			_shape.graphics.curveTo (ax,ay,endx,endy);
		}
	}	
}