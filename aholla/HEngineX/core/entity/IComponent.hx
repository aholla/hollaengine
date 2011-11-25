/**
 * ...
 * @author Adam
 */

package aholla.henginex.core.entity;

import aholla.henginex.core.entity.IEntity;

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
	
	/**
	 * Retruns the components owning Entity.
	 */
	//function get owner():IEntity;
	//function get owner():IEntity;
	var owner:IEntity;
	
	var hashID:String;
	/**
	 * Retruns the name of the component.
	 */
	//function get name():String;	
	//
	//function set isActive(value:Bool):Void;	
	//function get isActive():Bool;	
	//
	//function toString():String
	
	//function injectOtherComponent(component:IComponent, componentName:String):Void;
}	