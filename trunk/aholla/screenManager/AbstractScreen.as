/**
 * ...
 * @author Adam
 * VERSION 0.0.1;
 */

package aholla.screenManager 
{	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;	
	import flash.events.MouseEvent;
	
	public class AbstractScreen extends Sprite implements IScreen
	{
		private var _isLoaded						:Boolean
		private var buttonsArr						:Array;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function AbstractScreen() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Called from the ScreenManager. Can be overridden to "start" the screen when it is loaded.
		 */
		public function load():void 
		{
			_isLoaded = true;
		}
		
		/**
		 * Called from the ScreenManager. Can be overridden to "unload" the screen when it is unloaded.
		 */
		public function unload():void 
		{
			_isLoaded = false;
			removeButtons();
		}
		
		/**
		 * Pass in a movieclip to create a "simple button"
		 * @param	$button
		 * @param	$clickCallback
		 * @param	$rolloverCallback
		 * @param	$rolloutCallback
		 */
		protected function addButton($button:MovieClip, $clickCallback:Function = null, $rolloverCallback:Function = null, $rolloutCallback:Function = null):void
		{
			$button.clickCallback 		= $clickCallback;
			$button.rolloverCallback 	= $rolloverCallback;
			$button.rolloutCallback 	= $rolloutCallback;
			
			$button.mouseChildren = false;
			$button.buttonMode = true;				
			$button.addEventListener(MouseEvent.CLICK,		onButtonClick, false, 0, true);
			$button.addEventListener(MouseEvent.ROLL_OVER,	onButtonOver, false, 0, true);
			$button.addEventListener(MouseEvent.ROLL_OUT,	onButtonOut, false, 0, true);	
				
			if (!buttonsArr)
				buttonsArr = [];
			
			buttonsArr.push($button);
		}
		
		/**
		 * Remove a button from the screen.
		 * @param	$button
		 */
		protected function removeButton($button:MovieClip):void
		{
			var id:int = buttonsArr.indexOf($button)
			if (id >= 0)
			{
				$button.buttonMode = false;				
				$button.removeEventListener(MouseEvent.CLICK,		onButtonClick);
				$button.removeEventListener(MouseEvent.ROLL_OVER,	onButtonOver);
				$button.removeEventListener(MouseEvent.ROLL_OUT,	onButtonOut);
				buttonsArr.splice(id, 1);
			}
		}
		
		/**
		 * Called when the screen is added to the Stage. Can be overridden to "initialise" the screen when it is added.
		 */
		protected function init():void
		{
			// Does nothing but can be used to instantiate stuff.
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Removes the button interactivity on "Unload".
		 */
		private function removeButtons():void
		{
			for each(var _btn:MovieClip in buttonsArr)
			{
				_btn.removeEventListener(MouseEvent.CLICK,		onButtonClick);
				_btn.removeEventListener(MouseEvent.ROLL_OVER,	onButtonOver);
				_btn.removeEventListener(MouseEvent.ROLL_OUT,	onButtonOut);
				_btn = null;
			}
			buttonsArr = [];
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/		
		
		/**
		 * Button CLick method, calls a callback if provided or dispatched the mouseEvent.
		 * @param	e
		 */
		private function onButtonClick(e:MouseEvent):void 
		{
			var _btn:MovieClip = e.currentTarget as MovieClip;
			var _callback:Function = _btn.clickCallback;
			if (_callback != null)
			{
				if (_callback.length == 0) _callback();
				else _callback(_btn);
				
			}
			else
				_btn.dispatchEvent(e);
		}
		
		/**
		 * Button Over method, calls a callback if provided or dispatched the mouseEvent.
		 * @param	e
		 */
		private function onButtonOver(e:MouseEvent):void 
		{
			var _btn:MovieClip = e.currentTarget as MovieClip;	
			var _callback:Function = _btn.rolloverCallback;
			if (_callback != null)
			{
				if (_callback.length == 0) _callback();
				else _callback(_btn)
			}
			else
			{
				var _lablesArr:Array = _btn.currentLabels;
				for each(var _lable:FrameLabel in _lablesArr)
				{
					if (_lable.name == "over")	_btn.gotoAndStop(_lable.name);
				}
			}
		}
		
		/**
		 * Button Out method, calls a callback if provided or dispatched the mouseEvent.
		 * @param	e
		 */
		private function onButtonOut(e:MouseEvent):void 
		{
			var _btn:MovieClip = e.currentTarget as MovieClip;	
			var _callback:Function = _btn.rolloutCallback;
			if (_callback != null)
			{
				if (_callback.length == 0) _callback();
				else _callback(_btn)
			}
			else
			{
				var _lablesArr:Array = _btn.currentLabels;
				for each(var _lable:FrameLabel in _lablesArr)
				{
					if (_lable.name == "out")	_btn.gotoAndStop(_lable.name);
				}
			}
		}
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/			
		
		public function set isLoaded(value:Boolean):void 
		{
			_isLoaded = value;
		}
		
		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
	}
}