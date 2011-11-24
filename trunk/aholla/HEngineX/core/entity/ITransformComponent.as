/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public interface ITransformComponent extends IComponent
	{	
		function isOnscreen():Boolean;
		function get x():Number;		
		function set x(value:Number):void;
		
		function get y():Number;		
		function set y(value:Number):void;
		
		function get z():Number;	
		function set z(value:Number):void;
		
		function get zIndex():Number;	
		function set zIndex(value:Number):void;
		
		function get width():Number;	
		function set width(value:Number):void;
		
		function get height():Number;	
		function set height(value:Number):void;
		
		function get rotation():Number;
		function set rotation(value:Number):void;
		
		function get scale():Number;
		function set scale(value:Number):void;
		
		function get scaleX():Number;
		function set scaleX(value:Number):void;
		
		function get scaleY():Number;
		function set scaleY(value:Number):void;
		
		function get velocity():Point;
		function set velocity(value:Point):void;
		
		function get acceleration():Point;
		function set acceleration(value:Point):void;
		
		function get layerIndex():Number;	
		function set layerIndex(value:Number):void;
		
		function set bounds(value:Rectangle):void
		function get bounds():Rectangle
		
		function set hasMoved(value:Boolean):void;
		function get hasMoved():Boolean;
		
		function set isDirty(value:Boolean):void;
		function get isDirty():Boolean;
		
	}	
}