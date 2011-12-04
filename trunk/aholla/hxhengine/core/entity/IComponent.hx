/**
 * ...
 * @author Adam
 */
package aholla.hxhengine.core.entity;

import aholla.hxhengine.core.entity.IEntity;

interface IComponent 
{	
	/**
	 * Called when the component is added to the Entity (like and "Init").
	 * @param	owner
	 * @param	name
	 */
	function onAdded(owner:IEntity, name:String):Void;
	
	/**
	 * Called when the entity is started.
	 */
	function start():Void;
	
	/**
	 * Called from the process managed when the Enity is "destroyed"
	 */
	function destroy():Void;
	
	/**
	 * Called when the HEngine is paused.
	 */
	function onPause():Void;
	
	/**
	 * Called when the HEngine is unpaused.
	 */
	function onUnPause():Void;		
	
	var owner(default, null):IEntity;
	var name(default, null):String;
	var isActive:Bool;	
	var hashKey(getHashKey, null):String;
	
	function toString():String;
}	