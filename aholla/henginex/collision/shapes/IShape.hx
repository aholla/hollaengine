/**
* SAT code from http://www.sevenson.com.au/actionscript/sat/
* Repackaged and adjusted to fit within HEngine and to keep things clean.
* Origional package: com.sevenson.geom.sat.Collision
* @author Andrew Sevenson
* 
*/

package aholla.henginex.collision.shapes;

import nme.geom.Rectangle;
import nme.display.Graphics;

/**
 * The IShape class
 */
interface IShape
{		
	function destroy():Void;
	function render(graphics:Graphics, shapeColour:UInt = 0x00FFFF, shapeAlpha:Float = 0.1, boundsColour:UInt = 0x0080FF, boundsAlpha:Float = 0.5):Void;
	function translate(tx:Int, ty:Int):Void;
	
	var x(getX, setX):Int;	
	var y(getY, setY):Int;
	var bounds(getBounds, null):Rectangle;
	var scale(getScale, setScale):Float;
	var scaleX(getScaleX, setScaleX):Float;
	var scaleY(getScaleY, setScaleY):Float;
	var rotation(getRotation, setRotation):Float;
	var tx(getTX, null):Int;
	var ty(getTY, null):Int;	
	
}
