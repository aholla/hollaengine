/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public interface IRendererComponent extends IComponent
	{
		function drawBox($width:int, $height:int, $colour:uint = 0xFF0000, $alpha:Number = 1):void
		function drawCircle($radius:int, $colour:uint = 0xFF0000, $alpha:Number = 1):void
		function drawPolygon($verticies:Array, $tx:Number = 0, $ty:Number = 0, $colour:uint = 0xFF0000, $alpha:Number = 1, $lineAlpha:Number = 0):void
		
		/**
		 * Stops the animations running.
		 */
		function stop():void;
		
		function render(canvasData:BitmapData):void;
		function debugRender(canvasDebugData:BitmapData):void;
		function play($animation:String):void;
		
		
		
		function get alpha():Number;
		function set alpha($value:Number):void;
		
		/**
		 * OffsetX is used to offset the display from the spacial component.
		 */
		function get offsetX():Number;
		function set offsetX($value:Number):void;
		
		/**
		 * OffsetY is used to offset the display from the spacial component.
		 */
		function get offsetY():Number;
		function set offsetY($value:Number):void;
		
		/**
		 * Spritemap
		 */
		function get spritemap():Spritemap;
		function set spritemap($spriteMap:Spritemap):void;
		
		/**
		 * Graphic of renderer.
		 * */
		function get graphic():Bitmap;
		function set graphic($graphic:Bitmap):void;

		

		
	}	
}