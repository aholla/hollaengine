/**
 * SAT code from http://www.sevenson.com.au/actionscript/sat/
 * Repackaged within HEngine to keep things clean.
 * Origional package: com.sevenson.geom.sat.Collision
*/

package aholla.HEngine.collision
{
	import aholla.HEngine.collision.shapes.IShape;
	import aholla.HEngine.core.entity.IEntity;
	import flash.geom.Point;
	
	/**
	 * The CollisionInfo class
	 */
	public class CollisionInfo
	{
		public var entityA			:IEntity;	// A is the entity that is checking for collision
		public var entityB			:IEntity;	// B is the collidee.
		
		public var shapeA			:IShape;						// the first shape
		public var shapeB			:IShape;					// the second shape
		public var distance			:Number = 0;				// how much overlap there is
		public var vector			:Point = new Point();		// the direction you need to move - unit vector
		public var shapeAContained	:Boolean = false;			// is object A contained in object B
		public var shapeBContained	:Boolean = false;			// is object B contained in object A
		public var separation		:Point = new Point();		// a vector that when subtracted to shape A will separate it from shape B
		
		
		/**
		 * Creates a new instance of the CollisionInfo class.
		 */
		public function CollisionInfo()
		{
		}
		
		public function toString():String 
		{
			return "[CollisionInfo entityA=" +entityA + "entityB=" + entityB + "shapeA=" + shapeA + " shapeB=" + shapeB + " distance=" + distance + " vector=" + vector + " shapeAContained=" + shapeAContained + " shapeBContained=" + shapeBContained + " separation=" + separation + "]";
		}
	}
}