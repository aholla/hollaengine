/**
 * ...
 * @author Adam
 */

package aholla.screenManager
{
	
	public interface IScreen
	{	
		/**
		 * Inityialisation
		 */
		function init() : void;
		
		/**
		 * Load all of the data and graphics that this scene needs to function.
		 */
		function load() :void;
		
		/**
		 * Unload everything that the garbage collector won't unload itself, including graphics.
		 */
		function unload() :void;
		
		/**
		 * Transition IN the section.
		 */
		function transIn() :void;
	
		/**
		 * Tranmsition OUT the section.
		 */
		function transOut() :void;
		
		/**
		 * Pause
		 */
		function pause() : void;
		
		/**
		 * Pause
		 */
		function resume() : void;
		
		function set isLoaded($value:Boolean):void
		function get isLoaded():Boolean
		
		function set alpha($value:Number):void
		
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
	}	
}