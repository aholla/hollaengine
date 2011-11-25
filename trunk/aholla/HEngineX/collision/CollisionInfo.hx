/**
* SAT code from http://www.sevenson.com.au/actionscript/sat/
* Repackaged within HEngine to keep things clean.
* Origional package: com.sevenson.geom.sat.Collision
*/

package aholla.henginex.collision;

import aholla.henginex.collision.shapes.IShape;
import aholla.henginex.core.entity.IEntity;
import nme.geom.Point;

/**
 * The CollisionInfo class
 */
class CollisionInfo
{
	public var entityA			:IEntity;	// A is the entity that is checking for collision
	public var entityB			:IEntity;	// B is the collidee.	
	public var shapeA			:IShape;						// the first shape
	public var shapeB			:IShape;					// the second shape
	public var distance			:Float;				// how much overlap there is
	public var vector			:Point;		// the direction you need to move - unit vector
	public var separation		:Point;		// a vector that when subtracted to shape A will separate it from shape B
	public var shapeAContained	:Bool;			// is object A contained in object B
	public var shapeBContained	:Bool;			// is object B contained in object A
	
	
	/**
	 * Creates a new instance of the CollisionInfo class.
	 */
	public function new()
	{
		distance 	= 0;
		vector 		= new Point();
		separation 	= new Point();
		shapeAContained = shapeBContained = false;
	}
	
	public function toString():String 
	{
		return "[CollisionInfo entityA=" +entityA + "entityB=" + entityB + "shapeA=" + shapeA + " shapeB=" + shapeB + " distance=" + distance + " vector=" + vector + " shapeAContained=" + shapeAContained + " shapeBContained=" + shapeBContained + " separation=" + separation + "]";
	}
}
