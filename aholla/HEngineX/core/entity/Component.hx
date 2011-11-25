/**
* ...
* @author Adam
*/

package aholla.henginex.core.entity;

import aholla.henginex.core.entity.IEntity;
import aholla.henginex.HE;
import flash.utils.Dictionary;

class Component implements IComponent
{
	public var hashID(getHashID, null)			:String;
	
	private var _owner							:IEntity;
	private var _name							:String;
	private var _isActive						:Bool;

/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new() 
	{
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	public function onAdded(owner:IEntity, name:String):Void
	{
		_owner 	= owner;
		_name 	= name;
	}
	
	public function onRemove():Void
	{
		destroy();
	}
	
	public function start():Void
	{
		if (!_isActive)
		{
			HE.processManager.addComponent(this);
			_isActive = true;
		}
	}
	
	public function destroy():Void
	{
		HE.processManager.removeComponent(this);
		_isActive = false;
		_owner = null;
	}
	
	public function onPause():Void
	{
		
	}
	
	public function onUnPause():Void
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

	private function getHashID():String
	{
		return _owner.name + "_" + _name;
	}
	
	//public function get owner():IEntity						{ return _owner; }
	//public function get name():String						{ return _name; }	
	//
	//public function get isActive():Bool 					{ return _isActive;	}		
	//public function set isActive(value:Bool):Void 		{	_isActive = value;	}		
	
	public function toString():String 
	{
		return "[Component name=" + name + " isActive=" + isActive + " owner=" + owner + "]";
	}
}