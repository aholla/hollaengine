/**
 * ...
 * @author Adam
 */

package aholla.screenManager 
{	
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class AbstractScreen extends Sprite implements IScreen
	{
		private var _isLoaded:Boolean
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function AbstractScreen() 
		{
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function init():void 
		{
			//trace("screen init")
		}
		
		public function load():void 
		{
			_isLoaded = true;
			//trace("screen load")
		}
		
		public function unload():void 
		{
			_isLoaded = false;
			//trace("screen unload")
		}
		
		public function transIn():void 
		{
			//trace("screen transIn")
		}
		
		public function transOut():void 
		{
			//trace("screen transOut")
		}
		
		public function pause():void 
		{
			//trace("screen pause")
		}
		
		public function resume():void
		{
			//trace("screen resume")
		}
		
		public function set isLoaded(value:Boolean):void 
		{
			_isLoaded = value;
		}
		
		public function get isLoaded():Boolean
		{
			return _isLoaded;
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