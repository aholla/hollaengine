/**
 * ...
 * @author Adam
 * VERSION 0.0.1;
 */

package aholla.screenManager
{	
	public interface IScreen
	{			
		/**
		 * Load all of the data and graphics that this scene needs to function.
		 */
		function load() :void;
		
		/**
		 * Unload everything that the garbage collector won't unload itself, including graphics.
		 */
		function unload() :void;
		
		/**
		 * Called when the Screen is added to the stage.
		 */
		//function init():void
		
		/**
		 * Pause
		 */
		//function pause() : void;
		
		/**
		 * resume
		 */
		//function resume() : void;		
		
		function set isLoaded($value:Boolean):void
		function get isLoaded():Boolean
		
		function set alpha($value:Number):void
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
	}	
}