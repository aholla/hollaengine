/**
* ...
* @author Adam
*/

package aholla.hxhengine.core.entity;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.display.MovieClip;
import nme.display.Sprite;
import nme.geom.Point;

interface IRendererComponent implements IComponent
{
	function drawBox(width:Int, height:Int, 	 colour:UInt = 0xFF0000, alpha:Float = 1):Void;		
	function drawCircle(radius:Int, 			 colour:UInt = 0xFF0000, alpha:Float = 1):Void;
	function drawPolygon(verticies:Array<Point>, colour:UInt = 0xFF0000, alpha:Float = 1):Void;
	function stop():Void;	
	function play(animation:String):Void;	
	function onRender(canvasData:BitmapData = null):Void;
	function debugRender():Void;	
	function flashColour(colour:UInt = 0xFFFFFF, duration:Float = 1, alpha:Float = 1, delay:Float = 0):Void;	
	function tint(colour:UInt = 0xFFFFFF, alpha:Float = 1):Void;	
	function setGraphic(image:Bitmap, width:Int = 0, height:Int = 0):Void;	
	
	var alpha(getAlpha, setAlpha):Float;	
	var offsetX:Float;
	var offsetY:Float;
	var graphic(default, null):Bitmap;
	//var map:Spritemap;
	
}	
