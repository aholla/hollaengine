/**
* SAT code from http://www.sevenson.com.au/actionscript/sat/
* Repackaged and adjusted to fit within HEngine and to keep things clean.
* Origional package: com.sevenson.geom.sat.Collision
* @author Andrew Sevenson
* 
*/

package aholla.henginex.collision.shapes;

import nme.display.Graphics;
import nme.geom.Rectangle;

class Circle implements IShape
{		
	public var x(getX, setX)						:Int;
	public var y(getY, setY)						:Int;
	public var tx(getTX, null)						:Int;
	public var ty(getTY, null)						:Int;
	public var scale(getScale, setScale)			:Float;
	public var scaleX(getScaleX, setScaleX)			:Float;
	public var scaleY(getScaleY, setScaleY)			:Float;
	public var rawScale								:Float;
	public var radius								:Float;
	public var rotation(getRotation, setRotation)	:Float;
	public var bounds(getBounds, null)				:Rectangle;	
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
	public function new (radius:Float = 1.0, tx:Int = 0, ty:Int = 0)
	{
		x			= 0;
		y			= 0;		
		scale		= 1.0;
		scaleX		= 1.0;		
		scaleY		= 1.0;		
		rawScale	= 1.0;		
		rotation	= 0.0;
		this.radius	= radius;
		this.tx		= tx;
		this.ty		= ty;		
		setRadius(radius * scale);
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	/**
	 * Creates a duplicate of this circle
	 * @return
	 */
	public function clone():IShape 
	{
		var c:Circle = new Circle(radius);
		c.x = x;
		c.y = y;
		c.scale = scale;
		return c;			
	}
	
	
	/**
	 * Renders this circle Into the given graphics object
	 * @param	g
	 */
	public function render(graphics:Graphics, shapeColour:UInt = 0x00FFFF, shapeAlpha:Float = 0.1, boundsColour:UInt = 0x0080FF, boundsAlpha:Float = 0.5):Void 
	{
		// bounds
		graphics.lineStyle(0.1, boundsColour, boundsAlpha);	
		trace("1" + " " + bounds.x + " " + bounds.y + " " + bounds.width+ " " + bounds.height);
		graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);			
		
		// shape
		graphics.lineStyle(0.5, shapeColour, 0.8);
		graphics.beginFill(shapeColour, shapeAlpha);
		graphics.drawCircle(tx, ty, getTransformedRadius());
		graphics.endFill();
	}
	
	public function translate(tx:Int, ty:Int):Void
	{
		bounds = null;
		this.tx = tx;
		this.ty = ty;
	}		
	
	/**
	 * A clean up routine that destroys all external references to prepare the class for garbage collection
	 */
	public function destroy () : Void
	{
		
	}
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
	
	/**
	 * Sets the radius of this circle (if the shape was a polygon then it will now be a circle);
	 * @param	value
	 */
	private function setRadius(value:Float):Void
	{
		bounds = null;
		radius = Math.abs(value);
		trace(">>> " +  radius + " " + Math.abs(value) +" "+  value);
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
	/**
	 * Gets the radius of this shape (if it is a circle)
	 * If set, converts this shape Into a circle
	 */
	//public function get radius():Float { return radius; }
	//public function set radius(value:Float):Void { setRadius(value); }
	
	/**
	 * Returns the radius with the the scale applied
	 */
	private function getTransformedRadius():Float 
	{
		bounds = null;
		return radius * Math.abs(scale);
	}
	
	/**
	 * Returns the x position
	 */
	private function getX():Int 
	{ 
		return x;
	}
	private function setX(value:Int):Int 
	{
		return x = value + tx;
	}
	
	/**
	 * Returns the y position
	 */
	private function getY():Int 
	{
		return y;
	}
	private function setY(value:Int):Int 
	{
		return y = value + ty;
	}
	
	
	/**
	 * Returns the current rotation of this circle
	 * (not really valid - applied as part of the IShape Interface)
	 */
	private function getRotation():Float 
	{
		return rotation; 
	}
	private function setRotation(value:Float):Float 
	{
		bounds = null;
		return rotation = value;
	}
	
	/**
	 * Returns the scale
	 */
	private function getScale():Float 
	{ 
		return scale; 
	}
	
	private function setScale(value:Float):Float 
	{
		bounds = null;
		return scale = value;
	}	
	
	/**
	 * Returns the scale
	 */
	private function getScaleX():Float 
	{ 
		return scaleX; 
	}
	private function setScaleX(value:Float):Float 
	{
		bounds = null;			
		return scaleX = value;
	}	
	
	private function getScaleY():Float 
	{ 
		return scaleY; 
	}
	private function setScaleY(value:Float):Float 
	{
		bounds = null;
		return scaleY = value;
	}	
	
	
	/**
	 * returns the bounds of the circle.
	 */
	private function getBounds():Rectangle
	{
		if (bounds != null)
		{
			return bounds;
		}
		else
		{
			var _scaledRadius:Float = radius * scale;
			bounds = new Rectangle(Std.int(-_scaledRadius + tx), Std.int(-_scaledRadius + ty), _scaledRadius * 2, _scaledRadius * 2);
			return bounds;
		}
	}		
	
	/**
	 * Gets/Sets the TX and TY values.
	 */
	private function getTX():Int		{	return tx;	}		
	private function getTY():Int		{	return ty;	}		
	
}
