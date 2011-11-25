/**
 * Use for collision detection. Mostly code by Andrew Sevenson with 
 * some extras for the henginex. Based upon SAT code 
 * from http://www.sevenson.com.au/actionscript/sat/. 
 * @author Adam
 */

package aholla.henginex.collision.shapes;

import aholla.henginex.HEUtils;
import flash.display.Graphics;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.PoInt;
import flash.geom.Rectangle;
	

class Polygon implements IPolygon 
{
	private var _x								:Float = 0;
	private var _y								:Float = 0;
	private var _transform						:Matrix = new Matrix();		
	private var _rotation						:Float = 0;
	private var _scaleX							:Float = 1;
	private var _scaleY							:Float = 1;
	private var _tx								:Float = 0;
	private var _ty								:Float = 0;
	private var _scale							:Float = 1;	
	private var _transfromDirty					:Bool = true; // tracks if the current transform is up to date		
	private var _rawVertices					:Vector.<PoInt> = new Vector.<PoInt>;
	private var _transformedVertices			:Vector.<PoInt> = new Vector.<PoInt>;
	private var _bounds							:Rectangle;				
	private var _width							:Int;
	private var _height							:Int;
	
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
	 * Generates a polygon with the given Float of sides at the given radius
	 * Note that the radius param is not related to the radius used to define a circle shape
	 * @param	sides
	 * @param	radius
	 * @return
	 */
	static public function basicPolygon(sides:Int = 3, radius:Float = 100):Polygon 
	{
		if (sides < 3) throw new Error('Polygon - Needs at least 3 sides');
		// create a return polygon 
		var poly:Polygon = new Polygon();
		// figure out the angles required
		var rotangle:Float = (Math.PI * 2) / sides;
		var angle:Float;
		var pt:PoInt;
		// loop through and generate each poInt
		for (var i:Int = 0; i < sides; i++) 
		{
			angle = (i * rotangle) + ((Math.PI-rotangle)*0.5);
			pt = new PoInt();
			pt.x = Math.cos(angle) * radius;
			pt.y = Math.sin(angle) * radius;
			poly.addVertex(pt);
		}
		return poly;
	}		
	
	/**
	 * Generates a polygon based on the poInts passed in
	 * @param	poInts...
	 * @return
	 */
	//static public function fromArray(poInts:Array, tx:Float = 0, ty:Float = 0):Polygon 
	static public function fromArray(poInts:Array, centreReg:Bool):Polygon 
	{
		var poly:Polygon = new Polygon();
		
		var lowX	:Int = Int.MAX_VALUE;
		var highX	:Int = 0;
		var lowY	:Int = Int.MAX_VALUE;
		var highY	:Int = 0;
		var pX		:Int;
		var pY		:Int;
		for (var i:Int = 0; i < poInts.length; i++) 
		{
			var p:PoInt = poInts[i] as PoInt;				
			pX = p.x;
			pY = p.y;					
			if (pX < lowX) 	lowX = pX;
			if (pX > highX) highX = pX;
			if (pY < lowY)	lowY = pY;
			if (pY > highY) highY = pY;				
		}
		
		poly.width = highX;
		poly.height = highY;
		
		for each (var pt:PoInt in poInts) 
		{
			poly.addVertex(pt);
		}
		
		for (var j:Int = 0; j < poly.vertices.length; j++) 
		{
			if (centreReg) 
			{
				poly.getVertexAt(j).x -= poly.width * 0.5;
				poly.getVertexAt(j).y -= poly.height * 0.5;
			}
			
		}
		poly.markAsDirty();
		poly.markAsDirty();
		poly.updateTransformation();
		return poly;
	}

	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	/**
	 * Renders the outline of this object to the given graphics object
	 * @param	graphics:Display object for rendering and a colour
	 */
	public function render(graphics:Graphics, shapeColour:Uint = 0x00FFFF, shapeAlpha:Float = 0.1, boundsColour:Uint = 0x0080FF, boundsAlpha:Float = 0.5):Void 
	{
		// bounds
		graphics.lineStyle(0.1, boundsColour, boundsAlpha);
		graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);			
		
		// shape
		graphics.lineStyle(0.5, shapeColour, 0.8);
		graphics.beginFill(shapeColour, shapeAlpha);
		
		//loop through the vertices, drawing from one to another	
		var basePt:PoInt = new PoInt(0, 0);	
		
		var len:Int = vertices.length;
		if (len == 0) return;		// bail if there is only 1 vertex
		var pt:PoInt = basePt.add(vertices[0]);				
		var vertex:PoInt;
		graphics.moveTo(pt.x, pt.y);	
		
		for (var i:Uint = 0; i < len; i++)
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
	public function destroy () : Void
	{
		_rawVertices 			= new Vector.<PoInt>;
		_transformedVertices 	= new Vector.<PoInt>;			
		_transform = null;
	}
	
	
	/**
	 * Adds a vertex/poInt to this polygon
	 * @param	pt
	 */
	public function addVertex(pt:PoInt):Void 
	{
		addVertexAt(pt, _rawVertices.length);
	}
	
	/**
	 * Adds a vertex/poInt at the given position
	 * @param	pt
	 * @param	pos
	 */
	public function addVertexAt(pt:PoInt, pos:Uint):Void 
	{
		_rawVertices.splice(pos, 0, pt);
		// flag the transform list as dirty
		_transfromDirty = true;
	}
	
	/**
	 * Removes the vertex/poInt at the given pos
	 * @param	pos
	 * @return
	 */
	public function removeVertexAt(pos:Uint):PoInt 
	{
		// flag the transform list as dirty
		_transfromDirty = true;
		return _rawVertices.splice(pos, 1)[0];
	}
	
	/**
	 * Returns the vertex/poInt at the given pos
	 * @param	pos
	 */
	public function getVertexAt(pos:Uint):PoInt 
	{
		return _rawVertices[pos];
	}		
	
	/**
	 * Marks the polygon as "dirty", it will then be recalculated.
	 */
	public function markAsDirty():Void 
	{
		_transfromDirty = true;
	}
		
	/**
	 * Translates the polygons position.
	 * @param	tx:Float
	 * @param	ty:Float
	 */
	public function translate(tx:Float, ty:Float):Void
	{
		_tx += tx;
		_ty += ty;			
		updateTransformation();			
	}
	
	/**
	 * Duplicates the current polygon
	 * @return
	 */
	public function clone():Polygon 
	{
		var p:Polygon = new Polygon();
		for each(var pt:PoInt in rawVertices) 
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
	private function updateTransformation():Void 
	{
		_bounds = null;
		_transform.identity();			
		_transform.scale(_scaleX, _scaleY);	
		_transform.rotate(_rotation * HEUtils.TO_RADIANS);			
		_transform.translate(_tx, _ty);
		// mark the poInts as dirty
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
	public function get x():Float 	
	{			
		return _x; 
	}
	public function set x(value:Float):Void 
	{ 
		_x = value;
	}		
	
	/**
	 * Returns the y position
	 */
	public function get y():Float 	
	{ 
		return _y;	
	}
	public function set y(value:Float):Void 
	{
		_y = value;
	}
	
	/**
	 * Sets/gets the rotation of this polygon
	 */
	public function get rotation():Float 
	{ 
		return _rotation; 
	}
	public function set rotation(value:Float):Void 
	{
		_rotation = value;
		updateTransformation();
	}
	
	/**
	 * Adjusts the scale in the x dimension
	 */
	public function get scaleX():Float { return _scaleX; }
	public function set scaleX(value:Float):Void
	{
		_scaleX = value;
		updateTransformation();
	}
	
	/**
	 * Adjusts the scale in the Y direction.
	 */
	public function get scaleY():Float { return _scaleY; }
	public function set scaleY(value:Float):Void 
	{
		_scaleY = value;
		updateTransformation();
	}		
	
	public function get scale():Float{	return _scale;}		
	public function set scale(value:Float):Void
	{
		_scale = value;
		_scaleX = _scaleY = _scale;
		updateTransformation();
	}
	
	/**
	 * Returns the vertices without any transformations applied
	 * Note that this is the 'actual' array stored, 
	 */
	//public function get rawVertices():Array { return _rawVertices; }
	public function get rawVertices():Vector.<PoInt> { return _rawVertices; }
	
	
	/**
	 * Returns the vertices with all of the transforms applied (scale, rotaiton, etc)
	 * Note that this is a concated array - in order to protect the current vertices.
	 */
	public function get vertices():Vector.<PoInt> 
	{
		// see if yo have to rebuild the transformed vertices?
		if (_transfromDirty == true) 
		{
			_transformedVertices = new Vector.<PoInt>;
			for each(var pt:PoInt in _rawVertices) 
			{
				_transformedVertices[_transformedVertices.length] = _transform.transformPoInt(pt);
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
			var lowX	:Int = Int.MAX_VALUE;
			var highX	:Int = 0;
			var lowY	:Int = Int.MAX_VALUE;
			var highY	:Int = 0;
			var pX		:Int;
			var pY		:Int;
			
			for each(var pt:PoInt in _rawVertices) 
			{
				pX = _transform.transformPoInt(pt).x;
				pY = _transform.transformPoInt(pt).y;
				
				if (pX < lowX) 	lowX = pX;
				if (pX > highX) highX = pX;
				if (pY < lowY)	lowY = pY;
				if (pY > highY) highY = pY;
			}
			var _width	:Int = (highX - lowX);
			var _height	:Int = (highY - lowY);				
			
			_bounds = new Rectangle(lowX, lowY, _width, _height);
			return _bounds;
		}
	}		
	
	public function get tx():Float	{	return _tx;		}		
	public function get ty():Float	{	return _ty;		}
	
	public function get width():Int 
	{
		return _width;
	}
	
	public function set width(value:Int):Void 
	{
		_width = value;
	}
	
	public function get height():Int 
	{
		return _height;
	}
	
	public function set height(value:Int):Void 
	{
		_height = value;
	}
}
