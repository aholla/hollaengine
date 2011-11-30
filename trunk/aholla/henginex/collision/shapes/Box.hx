/**
* SAT code from http://www.sevenson.com.au/actionscript/sat/
* Repackaged and adjusted to fit within HEngine and to keep things clean.
* Origional package: com.sevenson.geom.sat.Collision
* @author Andrew Sevenson
* 
*/


package aholla.henginex.collision.shapes;

import nme.display.Graphics;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.display.Graphics;

/**
 * The Box class
 */
class Box implements IPolygon
{	
	public var width(default, setWidth)				:Int;
	public var height(default, setHeight)			:Int;		
	public var centerReg(default, setCenterReg)		:Bool;
	
	public var x(getX, setX)						:Int;
	public var y(getY, setY)						:Int;
	public var bounds(getBounds, null)				:Rectangle;
	public var scale(getScale, setScale)			:Float;
	public var scaleX(getScaleX, setScaleX)			:Float;
	public var scaleY(getScaleY, setScaleY)			:Float;
	public var rotation(getRotation, setRotation)	:Float;
	public var tx(getTX, null)						:Int;
	public var ty(getTY, null)						:Int;
	
	public var vertices(getVertices, null)			:Array<Point>;
	public var rawVertices(getRawVertices, null)	:Array<Point>;
	
	private var polygon								:Polygon;
	
			
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
	/**
	 * Creates a new instance of the Box class
	 */
	public function new (width:Int = 10, height:Int = 10, centerReg:Bool = true)
	{
		polygon = new Polygon();
		for(i in 0...4)
		{
			polygon.addVertex(new Point());
		}
		this.centerReg 	= centerReg;
		this.width 		= width;
		this.height 	= height;
		
		updateShape();
		
		trace(">>>>>>>>>>>>>>>>>>>>>>>> NEW BOX:" + width + " : " + height +  " | " + polygon.bounds +  " | " + centerReg);
	}
	
/*-------------------------------------------------
* STATIC FUNCTIONS
-------------------------------------------------*/
		
	/**
	 * Creates a box from the two Points given
	 * @param	topLeft
	 * @param	bottomRight
	 * @param	centreReg
	 * @return
	 */
	static public function fromPoints(topLeft:Point, bottomRight:Point, centerReg:Bool = true):Box 
	{
		var b:Box = new Box(Std.int(bottomRight.x - topLeft.x), Std.int(bottomRight.y - topLeft.y), centerReg);
		b.x = (centerReg) ? Std.int(topLeft.x + ((bottomRight.x-topLeft.x) * 0.5)) : Std.int(topLeft.x);
		b.y = (centerReg) ? Std.int(topLeft.y + ((bottomRight.y-topLeft.y) * 0.5)) : Std.int(topLeft.y);
		return b;
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	/**
	 * A clean up routine that destroys all external references to prepare the class for garbage collection
	 */
	public function destroy () : Void
	{
		polygon.destroy();
		polygon = null;			
	}
	
	/**
	 * Creates a duplicate box with the same settings
	 * @return
	 */
	public function clone():Box 
	{
		var b:Box = new Box(width, height, centerReg);
		b.x = x;
		b.y = y;
		b.rotation = rotation;
		b.scaleX = scaleX;
		b.scaleY = scaleY;
		return b;
	}		
	
	/**
	 * Draws this shape Into the given graphics object
	 * @param	graphics
	 */
	public function render(graphics:Graphics, shapeColour:UInt = 0x00FFFF, shapeAlpha:Float = 0.1, boundsColour:UInt = 0x0080FF, boundsAlpha:Float = 0.5):Void 
	{
		polygon.render(graphics, shapeColour, shapeAlpha, boundsColour, boundsAlpha);
	}
	
	

	/**
	 * Translates the Box.
	 * @param	tx
	 * @param	ty
	 */	
	public function translate(tx:Int, ty:Int):Void 
	{
		polygon.translate(tx, ty);
	}
	
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
	
	/**
	 * Recalcs the position of each of the objects
	 */
	private function updateShape():Void 
	{
		if (centerReg) 
		{
			polygon.getVertexAt(0).x = -width * 0.5;
			polygon.getVertexAt(0).y = -height * 0.5;
			polygon.getVertexAt(1).x = width * 0.5;
			polygon.getVertexAt(1).y = -height * 0.5;
			polygon.getVertexAt(2).x = width * 0.5;
			polygon.getVertexAt(2).y = height * 0.5;
			polygon.getVertexAt(3).x = -width * 0.5;
			polygon.getVertexAt(3).y = height * 0.5;
		}
		else
		{
			polygon.getVertexAt(0).x = 0;
			polygon.getVertexAt(0).y = 0;
			polygon.getVertexAt(1).x = width;
			polygon.getVertexAt(1).y = 0;
			polygon.getVertexAt(2).x = width;
			polygon.getVertexAt(2).y = height;
			polygon.getVertexAt(3).x = 0;
			polygon.getVertexAt(3).y = height;
		}
		polygon.markAsDirty();		
	}	
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	

	private function setWidth(value:Int):Int
	{
		width = value;
		updateShape();
		return value;
	}
	
	private function setHeight(value:Int):Int
	{
		height = value;
		updateShape();
		return value;
	}	
	
	private function setCenterReg(value:Bool):Bool
	{
		centerReg = value;
		return value;
	}
	
	private function getX():Int
	{
		return polygon.x;
	}
	private function setX(value:Int):Int
	{
		polygon.x = value;
		return value;
	}
	
	private function getY():Int
	{
		return Std.int(polygon.y);
	}
	private function setY(value:Int):Int
	{
		polygon.y = value;
		return value;
	}
	
	private function getRotation():Float
	{
		return polygon.rotation;
	}
	private function setRotation(value:Float):Float
	{
		polygon.rotation = value;
		return value;
	}
	
	private function getScale():Float
	{
		return polygon.scale;
	}
	private function setScale(value:Float):Float
	{
		polygon.scale = polygon.scaleX = polygon.scaleY = value;
		return value;
	}
	
	private function getScaleX():Float
	{
		return polygon.scaleX;
	}
	private function setScaleX(value:Float):Float
	{
		polygon.scaleX = value;
		return value;
	}
	
	private function getScaleY():Float
	{
		return polygon.scaleY;
	}
	private function setScaleY(value:Float):Float
	{
		polygon.scaleY = value;
		return value;
	}

	public function getBounds():Rectangle
	{
		return polygon.bounds;
	}
	
	public function getTX():Int 
	{		
		return polygon.tx;
	}
	
	public function getTY():Int 
	{	
		return polygon.ty;	
	}
	
	public function getRawVertices():Array<Point>
	{ 
		return polygon.rawVertices; 
	}
	
	public function getVertices():Array<Point> 
	{
		return polygon.vertices;
	}
}
