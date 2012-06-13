/**
 * ...
 * @author ADAM
 */
 
package  aholla.screenManager 
{
	import adobe.utils.CustomActions;
	import aholla.screenManager.IScreen;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class ScreenManager
	{
		private static var 	_instance				:ScreenManager;
		private static var 	_allowInstance			:Boolean;
		
		private var _display						:Sprite;
		private var _groups							:Dictionary;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function ScreenManager() 
		{
			if (!ScreenManager._allowInstance)
			{
				throw new Error("Error: Use ScreenManager.inst instead of the new keyword.");
			}
			init();			
		}	
		
		public static function get inst():ScreenManager
		{
			if (ScreenManager._instance == null)
			{
				ScreenManager._allowInstance		= true;
				ScreenManager._instance				= new ScreenManager();
				ScreenManager._allowInstance		= false;
			}
			return ScreenManager._instance;
		}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function createScreenGroup(groupName:String, depth:int = 0):void
		{
			var screenGroup:ScreenGroup = new ScreenGroup(groupName, depth, new Vector.<IScreen>());
			_groups[groupName] = screenGroup;
		}
		
		public function addScreen(screen:IScreen, replace:Boolean = true, group:String = null, transition:ITransition = null):void
		{
			
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		private function init():void 
		{
			_display = new Sprite();
			_groups = new Dictionary();
			_groups["default"] = new Vector.<IScreen>();
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
	
	
	}
	
	
	
}

import aholla.screenManager.IScreen;


internal class ScreenGroup
{	
	public var groupName			:String;
	public var depth				:int;
	public var screens				:Vector.<IScreen>
	
	public function ScreenGroup(groupName:String, depth:int, screens:Vector.<IScreen>)
	{
		this.groupName 	= groupName;
		this.depth	 	= depth;
		this.screens 	= screens;
	}
}









