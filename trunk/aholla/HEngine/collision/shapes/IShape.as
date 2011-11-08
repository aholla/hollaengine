/**
 * SAT code from http://www.sevenson.com.au/actionscript/sat/
 * Repackaged and adjusted to fit within HEngine and to keep things clean.
 * Origional package: com.sevenson.geom.sat.Collision
 * @author Andrew Sevenson
 * 
*/

package aholla.HEngine.collision.shapes
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	/**
	 * The IShape class
	 */
	public interface IShape
	{		
		function destroy():void;
		function render(graphics:Graphics, $colour:uint):void;
		function translate($tx:Number, $ty:Number):void;
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y($value:Number):void;
		
		function get bounds():Rectangle;
		
		function get scale():Number;
		function set scale($value:Number):void;
		
		function get scaleX():Number;
		function set scaleX($value:Number):void;
		
		function get scaleY():Number;
		function set scaleY($value:Number):void;
		
		function get rotation():Number;
		function set rotation(value:Number):void;
		
		function get tx():Number;		
		function get ty():Number;		
		
	}
}