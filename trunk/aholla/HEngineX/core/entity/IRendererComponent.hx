/**
* ...
* @author Adam
*/

package aholla.henginex.core.entity;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import nme.geom.Point;

//interface IRendererComponent extends IComponent
interface IRendererComponent implements IComponent
{
	function drawBox(width:Int, height:Int, 	 colour:UInt = 0xFF0000, alpha:Float = 1):Void;		
	function drawCircle(radius:Int, 			 colour:UInt = 0xFF0000, alpha:Float = 1):Void;
	function drawPolygon(verticies:Array<Point>, colour:UInt = 0xFF0000, alpha:Float = 1):Void;
	
	/**
	 * Stops the animations running.
	 */
	function stop():Void;
	
	function play(animation:String):Void;
	
	
	function onRender(canvasData:BitmapData = null):Void;
	//function debugRender(canvasDebugData:BitmapData):Void;
	function debugRender():Void;
	
	
	function flashColour(colour:UInt = 0xFFFFFF, duration:Float = 1, alpha:Float = 1, delay:Float = 0):Void;
	
	function tInt(colour:UInt = 0xFFFFFF, alpha:Float = 1):Void;
	
	function setGraphic(image:Bitmap, width:Int = 0, height:Int = 0):Void;
	
	
	
	var alpha:Float;
	
	
	
	/**
	 * OffsetX is used to offset the display from the spacial component.
	 */
	var offsetX:Float;
	var offsetY:Float;
	
	/**
	 * OffsetY is used to offset the display from the spacial component.
	 */

	
	/**
	 * Spritemap
	 */
	//function get spritemap():Spritemap;
	//function set spritemap(spriteMap:Spritemap):Void;
	
	/**
	 * Graphic of renderer.
	 * */
	//function set graphic(graphic:Bitmap):Void;
	var graphic:Bitmap;

	

	
}	
