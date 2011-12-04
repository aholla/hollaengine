/**
* ...
* @author Adam
*/

package aholla.hxhengine.core.entity;

import aholla.hxhengine.core.entity.IEntity;
import aholla.hxhengine.HE;
import flash.utils.Dictionary;

class Component implements IComponent
{
	public var hashKey(getHashKey, null)			:String;	
	public var owner(default, null)					:IEntity;
	public var name(default, null)					:String;
	public var isActive								:Bool;

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
		this.owner 	= owner;
		this.name 	= name;
	}
	
	public function onRemove():Void
	{
		destroy();
	}
	
	public function start():Void
	{
		if (!isActive)
		{
			HE.processManager.addComponent(this);
			isActive = true;
		}
	}
	
	public function destroy():Void
	{
		isActive = false;
		HE.processManager.removeComponent(this);
		owner = null;
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

	private function getHashKey():String
	{
		if(owner != null)
			return owner.name + "_" + name;
		else
			return name;
	}
	
	public function toString():String 
	{
		return "[Component name=" + name + " isActive=" + isActive + " owner=" + owner + " hashKey=" + hashKey + "]";
	}
}