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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The Box class
	 */
	public class Box implements IPolygon
	{		
		private var _width				:Number = 10;
		private var _height:Number = 10;		
		private var _polygon:Polygon;
		private var _centreReg:Boolean = true;
		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		/**
		 * Creates a new instance of the Box class
		 */
		public function Box ($width:Number = 10, $height:Number = 10, $centreReg:Boolean = true )
		{
			_polygon = new Polygon();
			
			for (var i:int = 0; i < 4; i++) 
			{
				_polygon.addVertex(new Point());
			}	
			
			_width = $width;
			_height = $height
			_centreReg = $centreReg;
			
			updateShape();			
		}
		
/*-------------------------------------------------
* STATIC FUNCTIONS
-------------------------------------------------*/
			
		/**
		 * Creates a box from the two points given
		 * @param	$topLeft
		 * @param	$bottomRight
		 * @param	$centreReg
		 * @return
		 */
		static public function fromPoints($topLeft:Point, $bottomRight:Point, $centreReg:Boolean = true):Box 
		{
			var b:Box = new Box($bottomRight.x - $topLeft.x, $bottomRight.y - $topLeft.y, $centreReg);
			b.x = ($centreReg) ? $topLeft.x + (($bottomRight.x-$topLeft.x) * 0.5) : $topLeft.x;
			b.y = ($centreReg) ? $topLeft.y + (($bottomRight.y-$topLeft.y) * 0.5) : $topLeft.y;
			return b;
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * A clean up routine that destroys all external references to prepare the class for garbage collection
		 */
		public function destroy () : void
		{
			_polygon.destroy();
			_polygon = null;			
		}
		
		/**
		 * Creates a duplicate box with the same settings
		 * @return
		 */
		public function clone():Box 
		{
			var b:Box = new Box(_width, _height, _centreReg);
			b.x = x;
			b.y = y;
			b.rotation = rotation;
			b.scaleX = scaleX;
			b.scaleY = scaleY;
			return b;
		}		
		
		/**
		 * Draws this shape into the given graphics object
		 * @param	graphics
		 */
		public function render(graphics:Graphics, $colour:uint):void 
		{
			_polygon.render(graphics, $colour);
		}		

		/**
		 * Translates the Box.
		 * @param	$tx
		 * @param	$ty
		 */	
		public function translate($tx:Number, $ty:Number):void 
		{
			_polygon.translate($tx, $ty);
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Recalcs the position of each of the objects
		 */
		private function updateShape():void 
		{
			if (_centreReg) 
			{
				_polygon.getVertexAt(0).x = -_width * 0.5;
				_polygon.getVertexAt(0).y = -_height * 0.5;
				_polygon.getVertexAt(1).x = _width * 0.5;
				_polygon.getVertexAt(1).y = -_height * 0.5;
				_polygon.getVertexAt(2).x = _width * 0.5;
				_polygon.getVertexAt(2).y = _height * 0.5;
				_polygon.getVertexAt(3).x = -_width * 0.5;
				_polygon.getVertexAt(3).y = _height * 0.5;
			}
			else
			{
				_polygon.getVertexAt(0).x = 0;
				_polygon.getVertexAt(0).y = 0;
				_polygon.getVertexAt(1).x = _width;
				_polygon.getVertexAt(1).y = 0;
				_polygon.getVertexAt(2).x = _width;
				_polygon.getVertexAt(2).y = _height;
				_polygon.getVertexAt(3).x = 0;
				_polygon.getVertexAt(3).y = _height;
			}
			_polygon.markAsDirty();		
		}	
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		/**
		 * Sets/gets the width.
		 */
		public function get width():Number { return _width; }
		public function set width(value:Number):void 
		{
			_width = value;
			updateShape();
		}
		
		/**
		 * Sets/gets th hieght.
		 */
		public function get height():Number { return _height; }
		public function set height(value:Number):void 
		{
			_height = value;
			updateShape();
		}
		
		/**
		 * Sets/gets is if the box is center registered.
		 */
		public function get centreReg():Boolean { return _centreReg; }
		public function set centreReg(value:Boolean):void 
		{
			_centreReg = value;
			updateShape();
		}
		
		
		/**
		 * Sets/gets the x position.
		 */
		public function get x():Number { return _polygon.x; }
		public function set x(value:Number):void 
		{
			_polygon.x = value;
		}
		
		/**
		 * Sets/gets the y position.
		 */
		public function get y():Number { return _polygon.y; }
		public function set y(value:Number):void 
		{
			_polygon.y = value;
		}
		
		/**
		 * Sets/gets the rotation of this polygon
		 */
		public function get rotation():Number { return _polygon.rotation; }
		public function set rotation(value:Number):void 
		{
			_polygon.rotation = value;
		}
		
		/**
		 * Adjusts the scale in the x dimension.
		 */
		public function get scaleX():Number { return _polygon.scaleX; }
		public function set scaleX(value:Number):void 
		{
			_polygon.scaleX = value;
		}
		
		/**
		 * Adjusts the scale in the Y direction.
		 */
		public function get scaleY():Number { return _polygon.scaleY; }		
		public function set scaleY(value:Number):void 
		{
			_polygon.scaleY = value;
		}			
		
		/**
		 * Adjusts the scale in both the X and Y direction.
		 */
		public function get scale():Number { return _polygon.scale; }		
		public function set scale(value:Number):void 
		{
			_polygon.scale = value;
		}
		
		/**
		 * Returns the vertices without any transformations applied
		 * Note that this is the 'actual' array stored, 
		 */
		public function get rawVertices():Array 
		{ 
			return _polygon.rawVertices; 
		}
		
		
		/**
		 * Returns the vertices with all of the transforms applied (scale, rotaiton, etc)
		 * Note that this is a concated array - in order to protect the current vertices.
		 */
		public function get vertices():Array 
		{
			return _polygon.vertices;
		}	
		
		public function get bounds():Rectangle
		{
			return _polygon.bounds;
		}
		
		public function get tx():Number {	return _polygon.tx;}		
		public function get ty():Number {	return _polygon.ty;	}
		/*
		
		
		public function get scale():Number 
		{
			return _polygon.scale;
		}
		
		public function set scale($value:Number):void 
		{
			_polygon.scale = $value
		}
		*/
	}
}