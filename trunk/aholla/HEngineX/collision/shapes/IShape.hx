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
	function translate(tx:Float, ty:Float):Void;
	
	var x:Float;	
	var y:Float;
	var bounds:Rectangle;
	var scale:Float;
	var scaleX:Float;
	var scaleY:Float;
	var rotation:Float;
	var tx:Float;
	var ty:Float;	
	
}
