/**
 * ...
 * @author Adam
 * 
 * Based on Doob Stats but cut down.
 */

package aholla.HEngine 
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	
	public class FPSCounter extends Sprite
	{
		private var timer				:uint;
		private var oldTimer			:uint;		
		private var fps				 	:uint;
		private var mem 				:Number;
		private var fpsOutput			:String;
		private var memOutput			:String;
		private var txt					:TextField;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function FPSCounter($alpha:Number = 0.6, $forgroundColour:uint = 0x00FFFF, $backgroundColour:uint = 0x000000) 
		{
			var _bg:Sprite = new Sprite();
			_bg.graphics.lineStyle(0.5, $forgroundColour, $alpha-0.2);
			_bg.graphics.beginFill($backgroundColour, $alpha);
			_bg.graphics.drawRect(0, 0, 120, 14);
			_bg.graphics.endFill();
			_bg.mouseEnabled = false;
			_bg.x = -1;
			_bg.y = -1;
			this.addChild(_bg);
			
			var _format:TextFormat = new TextFormat();
            _format.font = "Arial";
			_format.color = $forgroundColour;
            _format.size = 8;
			
			txt = new TextField();
			txt.x = 4;
			txt.y = 0;
			txt.defaultTextFormat = _format;
			txt.text = "";
			txt.selectable = false;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.mouseEnabled = false;
			this.addChild(txt);
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		private function onEnterFrame(e:Event):void 
		{
			timer = getTimer();			
			if(timer - 1000 > oldTimer)
			{
				oldTimer = timer;
				mem = Number((System.totalMemory * 0.000000954).toFixed(3));				
				fpsOutput = "FPS: " + fps + " / " + stage.frameRate;
				memOutput = "MEM: " + mem;			
				fps = 0;
			}
			fps++;			
			txt.text = fpsOutput + "  |  " + memOutput;
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		
	}
}