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

	public class Circle implements IShape
	{		
		private var _x								:Number;
		private var _y								:Number;
		private var _tx								:Number;
		private var _ty								:Number;
		private var _scale							:Number;
		private var _scaleX							:Number;
		private var _scaleY							:Number;
		private var _rawScale						:Number;
		private var _radius							:Number;
		private var _rotation						:Number;
		private var _bounds							:Rectangle;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
			
		public function Circle ($radius:Number = 0, $tx:Number = 0, $ty:Number = 0)
		{
			_x			= 0;
			_y			= 0;			
			_scale		= 1;		
			_scaleX		= 1;		
			_scaleY		= 1;		
			_rawScale	= 1;		
			_radius		= 0;
			_rotation	= 0;
			_tx			= $tx;
			_ty			= $ty;
			setRadius($radius * _scale);
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
		 * Renders this circle into the given graphics object
		 * @param	g
		 */
		public function render(graphics:Graphics, shapeColour:uint = 0x00FFFF, shapeAlpha:Number = 0.1, boundsColour:uint = 0x0080FF, boundsAlpha:Number = 0.5):void 
		{
			// bounds
			graphics.lineStyle(0.1, boundsColour, boundsAlpha);				
			graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);			
			
			// shape
			graphics.lineStyle(0.5, shapeColour, 0.8);
			graphics.beginFill(shapeColour, shapeAlpha);
			graphics.drawCircle(_tx, _ty, transformedRadius);
			graphics.endFill();
		}
		
		public function translate($tx:Number, $ty:Number):void
		{
			_bounds = null;
			_tx = $tx;
			_ty = $ty;
		}		
		
		/**
		 * A clean up routine that destroys all external references to prepare the class for garbage collection
		 */
		public function destroy () : void
		{
			
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Sets the radius of this circle (if the shape was a polygon then it will now be a circle);
		 * @param	value
		 */
		private function setRadius(value:Number):void
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
		 * If set, converts this shape into a circle
		 */
		public function get radius():Number { return _radius; }
		public function set radius(value:Number):void { setRadius(value); }
		
		/**
		 * Returns the radius with the the scale applied
		 */
		public function get transformedRadius():Number 
		{
			_bounds = null;
			return _radius * Math.abs(_scale);
		}
		
		/**
		 * Returns the x position
		 */
		public function get x():Number {return _x;}
		public function set x(value:Number):void 
		{
			_x = value + _tx;
		}
		
		/**
		 * Returns the y position
		 */
		public function get y():Number { return _y;}
		public function set y(value:Number):void 
		{
			_y = value + _ty;
		}
		
		
		/**
		 * Returns the current rotation of this circle
		 * (not really valid - applied as part of the IShape interface)
		 */
		public function get rotation():Number { return _rotation; }
		public function set rotation(value:Number):void 
		{
			_bounds = null;
			_rotation = value;
		}
		
		
		/**
		 * Returns the scale
		 */
		public function get scale():Number { return _scale; }
		public function set scale(value:Number):void 
		{
			_bounds = null;
			_scale = Math.abs(value);
		}		
		
		/**
		 * Returns the scale
		 */
		public function get scaleX():Number { return _scale; }
		public function set scaleX(value:Number):void 
		{
			_bounds = null;			
			_scaleX = value;
		}		
		public function get scaleY():Number { return _scale; }
		public function set scaleY(value:Number):void 
		{
			_bounds = null;
			_scaleY = value;
		}	
		
		
		/**
		 * returns the bounds of the circle.
		 */
		public function get bounds():Rectangle
		{
			if (_bounds)
			{
				return _bounds;
			}
			else
			{
				var _scaledRadius:Number = radius * _scale;
				_bounds = new Rectangle(-_scaledRadius + _tx, -_scaledRadius + _ty, _scaledRadius * 2, _scaledRadius * 2);;
				return _bounds;
			}
		}		
		
		/**
		 * Gets/Sets the TX and TY values.
		 */
		public function get tx():Number		{	return _tx;	}		
		public function get ty():Number		{	return _ty;	}		
		//public function set tx($value:Number):void
		//{
			//_tx = $value;
		//}		
		//public function set ty($value:Number):void
		//{
			//_ty = $value;
		//}
		
	}
}