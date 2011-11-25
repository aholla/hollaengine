/**
* SAT code from http://www.sevenson.com.au/actionscript/sat/
* Repackaged and adjusted to fit within HEngine and to keep things clean.
* Origional package: com.sevenson.geom.sat.Collision
* @author Andrew Sevenson
* 
*/

package aholla.henginex.collision.shapes;

import flash.display.Graphics;
import flash.geom.Rectangle;

class Circle implements IShape
{		
	private var _x								:Float;
	private var _y								:Float;
	private var _tx								:Float;
	private var _ty								:Float;
	private var _scale							:Float;
	private var _scaleX							:Float;
	private var _scaleY							:Float;
	private var _rawScale						:Float;
	private var _radius							:Float;
	private var _rotation						:Float;
	private var _bounds							:Rectangle;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
	public function Circle (radius:Float = 0, tx:Float = 0, ty:Float = 0)
	{
		_x			= 0;
		_y			= 0;			
		_scale		= 1;		
		_scaleX		= 1;		
		_scaleY		= 1;		
		_rawScale	= 1;		
		_radius		= 0;
		_rotation	= 0;
		_tx			= tx;
		_ty			= ty;
		setRadius(radius * _scale);
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
		var c:Circle = new Circle(_radius);
		c.x = _x;
		c.y = _y;
		c.scale = _scale;
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
		graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);			
		
		// shape
		graphics.lineStyle(0.5, shapeColour, 0.8);
		graphics.beginFill(shapeColour, shapeAlpha);
		graphics.drawCircle(_tx, _ty, getTransformedRadius);
		graphics.endFill();
	}
	
	public function translate(tx:Float, ty:Float):Void
	{
		_bounds = null;
		_tx = tx;
		_ty = ty;
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
		_bounds = null;
		_radius = Math.abs(value);
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
	//public function get radius():Float { return _radius; }
	//public function set radius(value:Float):Void { setRadius(value); }
	
	/**
	 * Returns the radius with the the scale applied
	 */
	public function getTransformedRadius():Float 
	{
		_bounds = null;
		return _radius * Math.abs(_scale);
	}
	
	/**
	 * Returns the x position
	 */
	//public function get x():Float {return _x;}
	//public function set x(value:Float):Void 
	//{
		//_x = value + _tx;
	//}
	
	/**
	 * Returns the y position
	 */
	//public function get y():Float { return _y;}
	//public function set y(value:Float):Void 
	//{
		//_y = value + _ty;
	//}
	
	
	/**
	 * Returns the current rotation of this circle
	 * (not really valid - applied as part of the IShape Interface)
	 */
	//public function get rotation():Float { return _rotation; }
	//public function set rotation(value:Float):Void 
	//{
		//_bounds = null;
		//_rotation = value;
	//}
	
	
	/**
	 * Returns the scale
	 */
	//public function get scale():Float { return _scale; }
	//public function set scale(value:Float):Void 
	//{
		//_bounds = null;
		//_scale = Math.abs(value);
	//}		
	
	/**
	 * Returns the scale
	 */
	//public function get scaleX():Float { return _scale; }
	//public function set scaleX(value:Float):Void 
	//{
		//_bounds = null;			
		//_scaleX = value;
	//}		
	//public function get scaleY():Float { return _scale; }
	//public function set scaleY(value:Float):Void 
	//{
		//_bounds = null;
		//_scaleY = value;
	//}	
	
	
	/**
	 * returns the bounds of the circle.
	 */
	//public function get bounds():Rectangle
	//{
		//if (_bounds)
		//{
			//return _bounds;
		//}
		//else
		//{
			//var _scaledRadius:Float = radius * _scale;
			//_bounds = new Rectangle(-_scaledRadius + _tx, -_scaledRadius + _ty, _scaledRadius * 2, _scaledRadius * 2);;
			//return _bounds;
		//}
	//}		
	
	/**
	 * Gets/Sets the TX and TY values.
	 */
	//public function get tx():Float		{	return _tx;	}		
	//public function get ty():Float		{	return _ty;	}		
	
}
