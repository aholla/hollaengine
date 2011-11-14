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
		private var _x								:Number = 0;
		private var _y								:Number = 0;	
		private var _tx								:Number = 0;
		private var _ty								:Number = 0;
		private var _scale							:Number = 1;		
		private var _scaleX							:Number = 1;		
		private var _scaleY							:Number = 1;		
		private var _rawScale						:Number = 1;		
		private var _radius							:Number = 0;
		private var _rotation						:Number = 0;
		private var _bounds							:Rectangle;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
			
		public function Circle ($radius:Number = 0)
		{
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
		public function render(g:Graphics, $colour:uint = 0x00FFFF):void 
		{
			_bounds = null;
			
			// bounds
			g.lineStyle(0.1, 0x0000FF, 0.3);			
			g.drawRect(bounds.x + _tx, bounds.y + _ty, bounds.width, bounds.height);			
			
			// shape
			g.lineStyle(0.1, $colour, 1);
			g.beginFill($colour, 0.1);
			g.drawCircle(_tx, _ty, transformedRadius);
			g.endFill();
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
				//_tx -= _scaledRadius;
				//_ty -= _scaledRadius;
				_bounds = new Rectangle(- _scaledRadius, - _scaledRadius, _scaledRadius * 2, _scaledRadius * 2);;
				return _bounds;
			}
		}		
		
		/**
		 * Gets/Sets the TX and TY values.
		 */
		public function get tx():Number		{	return _tx;	}		
		public function get ty():Number		{	return _ty;	}		
		public function set tx($value:Number):void
		{
			_tx = $value;
		}		
		public function set ty($value:Number):void
		{
			_ty = $value;
		}
		
	}
}