/**
 * Use for collision detection. Mostly code by Andrew Sevenson with 
 * some extras for the hxhengine. Based upon SAT code 
 * from http://www.sevenson.com.au/actionscript/sat/. 
 * @author Adam
 */

package aholla.hxhengine.collision.shapes;

import aholla.hxhengine.HEUtils;
import nme.display.Graphics;
import nme.display.Shape;
import nme.errors.Error;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.display.Graphics;
	

class Polygon implements IPolygon 
{
	public var x(getX, setX)						:Int;
	public var y(getY, setY)						:Int;			
	public var rotation(getRotation, setRotation)	:Float;
	public var scale(getScale, setScale)			:Float;	
	public var scaleX(getScaleX, setScaleX)			:Float;
	public var scaleY(getScaleY, setScaleY)			:Float;
	public var tx(getTX, null)						:Int;
	public var ty(getTY, null)						:Int;
	public var width								:Int;
	public var height								:Int;
	
	public var bounds(getBounds, null)				:Rectangle;	
	
	public var transfromDirty						:Bool;	
	private var transform							:Matrix;
	
	public var vertices(getVertices, null)			:Array<Point>;
	public var rawVertices(getRawVertices, null)	:Array<Point>;
	public var transformedVertices(default, null)	:Array<Point>;
	
	private var _bounds								:Rectangle;
	
	public var isCentered							:Bool;
	

/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new() 
	{
		x 		= 0;
		y 		= 0;		
		rotation = 0;
		scale = scaleX = scaleY = 0;
		tx 		= 0;
		ty 		= 0;
		width 	= 0;
		height 	= 0;
		_bounds 	= new Rectangle(0, 0, 1, 1);
		transform = new Matrix();
		transfromDirty = true;
		vertices 			= [];
		rawVertices 		= [];
		transformedVertices = [];		
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
		var pt:Point;
		// loop through and generate each Point
		//for (var i:Int = 0; i < sides; i++) 
		for (i in 0...sides)
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
	 * Generates a polygon based on the Points passed in
	 * @param	Points...
	 * @return
	 */
	//static public function fromArray(Points:Array, tx:Float = 0, ty:Float = 0):Polygon 
	static public function fromArray(points:Array<Point>, centreReg:Bool = false):Polygon 
	{
		var poly:Polygon = new Polygon();
		poly.isCentered = centreReg;
		
		var lowX	:Int = Std.int(Math.POSITIVE_INFINITY);
		var highX	:Int = 0;
		var lowY	:Int = Std.int(Math.POSITIVE_INFINITY);
		var highY	:Int = 0;
		var pX		:Int;
		var pY		:Int;		
		
		for (i in 0...points.length)
		{
			var p:Point = points[i];				
			pX = Std.int(p.x);
			pY = Std.int(p.y);					
			if (pX < lowX) 	lowX = pX;
			if (pX > highX) highX = pX;
			if (pY < lowY)	lowY = pY;
			if (pY > highY) highY = pY;				
		}
		
		poly.width = highX;
		poly.height = highY;
		
		for (pt in points) 
		{
			poly.addVertex(pt);
		}
		
		for(j in 0...poly.vertices.length)
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
	public function render(graphics:Graphics, shapeColour:UInt = 0x00FFFF, shapeAlpha:Float = 0.1, boundsColour:UInt = 0x0080FF, boundsAlpha:Float = 0.5):Void 
	{
		// bounds
		graphics.lineStyle(0.1, boundsColour, boundsAlpha);
		graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);			
		
		trace("recder:" + " " + _bounds);
		
		// shape
		graphics.lineStyle(0.5, shapeColour, 0.8);
		graphics.beginFill(shapeColour, shapeAlpha);
		
		//loop through the vertices, drawing from one to another	
		var basePt:Point = new Point(0, 0);	
		
		var len:Int = vertices.length;
		if (len == 0) return;		// bail if there is only 1 vertex
		var pt:Point = basePt.add(vertices[0]);				
		var vertex:Point;
		graphics.moveTo(pt.x, pt.y);	
		
		//for (var i:UInt = 0; i < len; i++)
		for (i in 0...len)
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
	public function destroy():Void
	{
		rawVertices 		= [];
		transformedVertices = [];			
		transform = null;
	}
	
	
	/**
	 * Adds a vertex/Point to this polygon
	 * @param	pt
	 */
	public function addVertex(pt:Point):Void 
	{
		addVertexAt(pt, rawVertices.length);
	}
	
	/**
	 * Adds a vertex/Point at the given position
	 * @param	pt
	 * @param	pos
	 */
	public function addVertexAt(pt:Point, pos:UInt):Void 
	{
		//rawVertices.splice(pos, 0, pt);//AS3
		rawVertices.splice(pos, 0);
		rawVertices.insert(pos, pt);
		// flag the transform list as dirty
		transfromDirty = true;
	}
	
	/**
	 * Removes the vertex/Point at the given pos
	 * @param	pos
	 * @return
	 */
	public function removeVertexAt(pos:UInt):Point 
	{
		// flag the transform list as dirty
		transfromDirty = true;
		return rawVertices.splice(pos, 1)[0];
	}
	
	/**
	 * Returns the vertex/Point at the given pos
	 * @param	pos
	 */
	public function getVertexAt(pos:UInt):Point 
	{
		return rawVertices[pos];
	}		
	
	/**
	 * Marks the polygon as "dirty", it will then be recalculated.
	 */
	public function markAsDirty():Void 
	{
		_bounds = null;
		transfromDirty = true;
	}
		
	/**
	 * Translates the polygons position.
	 * @param	tx:Float
	 * @param	ty:Float
	 */
	public function translate(tx:Int, ty:Int):Void
	{
		this.tx += tx;
		this.ty += ty;			
		updateTransformation();			
	}
	
	/**
	 * Duplicates the current polygon
	 * @return
	 */
	public function clone():Polygon 
	{
		var p:Polygon = new Polygon();
		//for each(var pt:Point in rawVertices) 
		for (pt in rawVertices)
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
		if (transform == null)
			transform = new Matrix();
			
		transform.identity();			
		transform.scale(scaleX, scaleY);	
		transform.rotate(rotation * HEUtils.TO_RADIANS);			
		transform.translate(tx, ty);
		// mark the Points as dirty
		transfromDirty = true;
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/		

	/**
	 * X
	 * @return
	 */
	private function getX():Int
	{
		return x;
	}
	private function setX(value:Int):Int
	{
		return x = value;
	}
	
	/**
	 * Y
	 * @return
	 */
	private function getY():Int
	{
		return y;
	}
	private function setY(value:Int):Int
	{
		return y = value;
	}
	
	/**
	 * Rotation
	 * @return
	 */
	private function getRotation():Float
	{
		return rotation;
	}
	private function setRotation(value:Float):Float 
	{
		rotation = value;
		updateTransformation();
		return value;
	}
	
	/**
	 * Scale
	 * @return
	 */
	private function getScale():Float
	{
		return scale;
	}
	private function setScale(value:Float):Float
	{
		scale = value;
		scaleX = scaleY = scale;
		updateTransformation();
		return value;
	}	
	
	/**
	 * Scale X
	 * @return
	 */
	private function getScaleX():Float
	{
		return scaleX;
	}
	private function setScaleX(value:Float):Float
	{
		scaleX = value;
		updateTransformation();
		return value;
	}
	
	/**
	 * Scale Y
	 * @return
	 */
	private function getScaleY():Float
	{
		return scaleY;
	}
	private function setScaleY(value:Float):Float 
	{
		scaleY = value;
		updateTransformation();
		return value;
	}
	
	public function getTX():Int 
	{		
		return tx;
	}
	
	public function getTY():Int 
	{	
		return ty;	
	}
	/**
	 * Raw Vertices
	 * @return
	 */
	private function getRawVertices():Array<Point>
	{
		return rawVertices;
	}
	
	/**
	 * Transformed Vertices
	 * @return
	 */
	private function getVertices():Array<Point> 
	{
		// see if yo have to rebuild the transformed vertices?
		if (transfromDirty == true) 
		{
			transformedVertices = [];
			for(pt in rawVertices)
			{
				transformedVertices[transformedVertices.length] = transform.transformPoint(pt);
			}
		}
		transfromDirty = false;
		//return transformedVertices.concat();
		return transformedVertices;
	}
	
	/**
	 * Bounds
	 * @return
	 */
	private function getBounds():Rectangle
	{
		if (_bounds != null)
		{
			return _bounds;
		}
		else
		{
			var lowX	:Int = 999999999;
			var highX	:Int = 0;
			var lowY	:Int = 999999999;
			var highY	:Int = 0;
			var pX		:Int;
			var pY		:Int;
			for(pt in rawVertices)
			{
				pX = Std.int(transform.transformPoint(pt).x);
				pY = Std.int(transform.transformPoint(pt).y);				
				if (pX < lowX) 	lowX = pX;
				if (pX > highX) highX = pX;
				if (pY < lowY)	lowY = pY;
				if (pY > highY) highY = pY;
			}
			width  = (highX - lowX);			
			height = (highY - lowY);
			
			//trace([this, "width = " + " " + width, lowX, highX]);
			
			_bounds = new Rectangle(lowX, lowY, width, height);
			return _bounds;
		}
	}		

}
