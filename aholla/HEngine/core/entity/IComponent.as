/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity
{
	import aholla.HEngine.core.entity.IEntity;

	public interface IComponent 
	{	
		/**
		 * Called when the component is added to the Entity (like and "Init").
		 * @param	$owner
		 * @param	$name
		 */
		function onAdded($owner:IEntity, $name:String):void;
		
		/**
		 * Called when the entity is started.
		 */
		function start():void;
		
		/**
		 * Called from the process managed when the Enity is "destroyed"
		 */
		function destroy():void;
		
		/**
		 * Called when the HEngine is paused.
		 */
		function onPause():void;
		
		/**
		 * Called when the HEngine is unpaused.
		 */
		function onUnPause():void;		
		
		/**
		 * Retruns the components owning Entity.
		 */
		function get owner():IEntity;
		
		/**
		 * Retruns the name of the component.
		 */
		function get name():String;	
		
		function set isActive($value:Boolean):void;	
		function get isActive():Boolean;	
		
		function toString():String
		
		//function injectOtherComponent($component:IComponent, $componentName:String):void;
	}	
}