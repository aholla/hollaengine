	/**
	 * Use for collision detection. Mostly code by Andrew Sevenson with 
	 * some extras for the HEngine. Based upon SAT code 
	 * from http://www.sevenson.com.au/actionscript/sat/. 
	 * @author Adam
	 */

package aholla.HEngine.collision.shapes 
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
		

	public class Polygon implements IPolygon 
	{
		private var _x								:Number = 0;
		private var _y								:Number = 0;
		private var _transform						:Matrix = new Matrix();		
		private var _rotation						:Number = 0;
		private var _scaleX							:Number = 1;
		private var _scaleY							:Number = 1;
		private var _tx								:Number = 0;
		private var _ty								:Number = 0;
		private var _scale							:Number = 1;	
		private var _transfromDirty					:Boolean = true; // tracks if the current transform is up to date		
		private var _rawVertices					:Vector.<Point> = new Vector.<Point>;
		private var _transformedVertices			:Vector.<Point> = new Vector.<Point>;
		private var _bounds							:Rectangle;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

		public function Polygon() 
		{
			
		}
		
/*-------------------------------------------------
* STATIC FUNCTIONS
-------------------------------------------------*/

		/**
		 * Generates a polygon with the given number of sides at the given radius
		 * Note that the radius param is not related to the radius used to define a circle shape
		 * @param	sides
		 * @param	radius
		 * @return
		 */
		static public function basicPolygon(sides:int = 3, radius:Number = 100):Polygon 
		{
			if (sides < 3) throw new Error('Polygon - Needs at least 3 sides');
			// create a return polygon 
			var poly:Polygon = new Polygon();
			// figure out the angles required
			var rotangle:Number = (Math.PI * 2) / sides;
			var angle:Number;
			var pt:Point;
			// loop through and generate each point
			for (var i:int = 0; i < sides; i++) 
			{
				angle = (i * rotangle) + ((Math.PI-rotangle)*0.5);
				pt = new Point();
				pt.x = Math.cos(angle) * radius;
				pt.y = Math.sin(angle) * radius;
				poly.addVertex(pt);
			}
			return poly;
		}		
		
		/**
		 * Generates a polygon based on the points passed in
		 * @param	points...
		 * @return
		 */
		static public function fromArray(points:Array, $tx:Number = 0, $ty:Number = 0):Polygon 
		{
			var poly:Polygon = new Polygon();
			for each (var pt:Point in points) 
			{
				poly.addVertex(pt);
			}			
			poly.translate($tx, $ty)
			return poly;
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Renders the outline of this object to the given graphics object
		 * @param	graphics:Display object for rendering and a colour
		 */
		public function render(graphics:Graphics, $colour:uint = 0x00FFFF):void 
		{
			//_bounds = null;
			
			// bounds
			graphics.lineStyle(0.1, 0x0000FF, 0.5);
			graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			
			// shape
			graphics.lineStyle(1.0, $colour, 0.8);
			graphics.beginFill($colour, 0.1);
			
			// loop through the vertices, drawing from one to another			
			//var basePt:Point = new Point(_tx, _ty);			
			var basePt:Point = new Point(_tx, _ty);			
			var len:int = vertices.length;
			if (len == 0) return;		// bail if there is only 1 vertex
			var pt:Point = basePt.add(vertices[0]);				
			var vertex:Point;
			graphics.moveTo(pt.x, pt.y);	
			
			for (var i:uint = 0; i < len; i++)
			{
				vertex = (i == len - 1) ? vertices[0] : vertices[i+1];
				pt = basePt.add(vertex);
				graphics.lineTo(pt.x, pt.y);
			}
			graphics.endFill();	
		}
		
		/**
		 * A clean up routine that destroys all external references to prepare the class for garbage collection
		 */
		public function destroy () : void
		{
			_rawVertices 			= new Vector.<Point>;
			_transformedVertices 	= new Vector.<Point>;			
			_transform = null;
		}
		
		
		/**
		 * Adds a vertex/point to this polygon
		 * @param	pt
		 */
		public function addVertex(pt:Point):void 
		{
			addVertexAt(pt, _rawVertices.length);
		}
		
		/**
		 * Adds a vertex/point at the given position
		 * @param	pt
		 * @param	pos
		 */
		public function addVertexAt(pt:Point, pos:uint):void 
		{
			_rawVertices.splice(pos, 0, pt);
			// flag the transform list as dirty
			_transfromDirty = true;
		}
		
		/**
		 * Removes the vertex/point at the given pos
		 * @param	pos
		 * @return
		 */
		public function removeVertexAt(pos:uint):Point 
		{
			// flag the transform list as dirty
			_transfromDirty = true;
			return _rawVertices.splice(pos, 1)[0];
		}
		
		/**
		 * Returns the vertex/point at the given pos
		 * @param	pos
		 */
		public function getVertexAt(pos:uint):Point 
		{
			return _rawVertices[pos];
		}		
		
		/**
		 * Marks the polygon as "dirty", it will then be recalculated.
		 */
		public function markAsDirty():void 
		{
			_transfromDirty = true;
		}
			
		/**
		 * Translates the polygons position.
		 * @param	$tx:Number
		 * @param	$ty:Number
		 */
		public function translate($tx:Number, $ty:Number):void
		{
			_tx = $tx;
			_ty = $ty;			
			updateTransformation();			
		}
		
		/**
		 * Duplicates the current polygon
		 * @return
		 */
		public function clone():Polygon 
		{
			var p:Polygon = new Polygon();
			for each(var pt:Point in rawVertices) 
			{
				p.addVertex(pt.clone());
			}			
			// apply all of the transformations
			p.x = x;
			p.y = y;
			p.scaleX = scaleX;
			p.scaleY = scaleY;
			p.rotation = rotation;
			return p;
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		
		/**
		 * Updates the current transformation matrix
		 */
		private function updateTransformation():void 
		{
			_bounds = null;
			_transform.identity();
			//
			//trace("MATRIX a:", _transform.a)
			_transform.translate(_tx, _ty);
			_transform.scale(_scaleX, _scaleY);	
			//trace("MATRIX b:", _transform.a)
			_transform.rotate(_rotation * Math.PI / 180);
			// mark the points as dirty
			_transfromDirty = true;
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		/**
		 * Returns the x position
		 */
		public function get x():Number 	{ return _x; }
		public function set x(value:Number):void 
		{
			_x = value + _tx;
			//_bounds.x = _x;
		}		
		
		/**
		 * Returns the y position
		 */
		public function get y():Number 	{return _y;	}
		public function set y(value:Number):void 
		{
			_y = value + _ty;
			//_bounds.y = _y;
		}
		
		/**
		 * Sets/gets the rotation of this polygon
		 */
		public function get rotation():Number { return _rotation; }
		public function set rotation(value:Number):void 
		{
			_rotation = value;
			//updateTransformation();
		}
		
		/**
		 * Adjusts the scale in the x dimension
		 */
		public function get scaleX():Number { return _scaleX; }
		public function set scaleX(value:Number):void
		{
			_scaleX = value;
			//updateTransformation();
		}
		
		/**
		 * Adjusts the scale in the Y direction.
		 */
		public function get scaleY():Number { return _scaleY; }
		public function set scaleY(value:Number):void 
		{
			_scaleY = value;
			//updateTransformation();
		}		
		
		public function get scale():Number{	return _scale;}		
		public function set scale(value:Number):void
		{
			_scale = value;
			updateTransformation();
		}
		
		/**
		 * Returns the vertices without any transformations applied
		 * Note that this is the 'actual' array stored, 
		 */
		//public function get rawVertices():Array { return _rawVertices; }
		public function get rawVertices():Vector.<Point> { return _rawVertices; }
		
		
		/**
		 * Returns the vertices with all of the transforms applied (scale, rotaiton, etc)
		 * Note that this is a concated array - in order to protect the current vertices.
		 */
		public function get vertices():Vector.<Point> 
		{
			// see if yo have to rebuild the transformed vertices?
			if (_transfromDirty == true) 
			{
				_transformedVertices = new Vector.<Point>;
				for each(var pt:Point in _rawVertices) 
				{
					_transformedVertices[_transformedVertices.length] = _transform.transformPoint(pt);
				}
			}
			_transfromDirty = false;
			return _transformedVertices.concat();
		}
		
		
		/**
		 * Returns the bounds of the polygon.
		 */
		public function get bounds():Rectangle
		{
			if (_bounds)
			{
				return _bounds;
			}
			else
			{
				var lowX	:int = int.MAX_VALUE;
				var highX	:int = 0;
				var lowY	:int = int.MAX_VALUE;
				var highY	:int = 0;
				var pX		:int;
				var pY		:int;
				
				for each(var pt:Point in vertices) 
				{
					pX = _transform.transformPoint(pt).x;
					pY = _transform.transformPoint(pt).y;
					
					if (pX < lowX) 	lowX = pX;
					if (pX > highX) highX = pX;
					if (pY < lowY)	lowY = pY;
					if (pY > highY) highY = pY;
				}
				var _width	:int = highX - lowX;
				var _height	:int = highY - lowY;
				_bounds = new Rectangle(lowX, lowY, _width, _height);	
				return _bounds;
			}
		}		
		
		public function get tx():Number	{	return _tx;		}		
		public function get ty():Number	{	return _ty;		}
	}

}