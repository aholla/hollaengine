/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity 
{
	import aholla.HEngine.core.entity.IEntity;
	import aholla.HEngine.HE;
	import flash.utils.Dictionary;
	
	public class Component implements IComponent
	{
		private var _owner							:IEntity;
		private var _name							:String;
		private var _isActive						:Boolean;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function Component() 
		{
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function onAdded($owner:IEntity, $name:String):void
		{
			_owner 	= $owner;
			_name 	= $name;
		}
		
		public function onRemove():void
		{
			destroy();
		}
		
		public function start():void
		{
			if (!_isActive)
			{
				HE.processManager.addComponent(this);
				_isActive = true;
			}
		}
		
		public function destroy():void
		{
			HE.processManager.removeComponent(this);
			_isActive = false;
			_owner = null;
		}
		
		public function onPause():void
		{
			
		}
		
		public function onUnPause():void
		{
			
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
		
		public function get owner():IEntity						{ return _owner; }
		public function get name():String						{ return _name; }	
		
		public function get isActive():Boolean 					{ return _isActive;	}		
		public function set isActive(value:Boolean):void 		{	_isActive = value;	}		
		
		public function toString():String 
		{
			return "[Component name=" + name + " isActive=" + isActive + " owner=" + owner + "]";
		}
	}
}