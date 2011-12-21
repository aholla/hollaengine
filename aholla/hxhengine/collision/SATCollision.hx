/**
* SAT code from http://www.sevenson.com.au/actionscript/sat/
* Repackaged within HEngine to keep things clean.
* Origional package: com.sevenson.geom.sat.Collision
*/

package aholla.hxhengine.collision;


import aholla.hxhengine.collision.shapes.IPolygon;
import aholla.hxhengine.collision.shapes.IShape;
import aholla.hxhengine.collision.shapes.Circle;
import aholla.hxhengine.collision.shapes.IShape;
import aholla.hxhengine.core.entity.IEntity;
import flash.display.Graphics;
import flash.geom.Point;
import nme.errors.Error;
import nme.Lib;


/**
 * The Collision class provides a set of static properties and methods
 */
class SATCollision
{
	
	/**
	 * [Static class] Collision cannot be directly instantiated
	 */
	public function SATCollision()
	{
		throw new Error("Collision cannot be directly instantiated.");
	}
	
	
	
	
	
	// STATIC PUBLIC FUNCTIONS
	// ------------------------------------------------------------------------------------------
	
	
	/**
	 * Tests the shapes from two entities colliders. Returns a CollisionInfor with teh collision info...
	 * @param	shapeA
	 * @param	shapeB
	 * @return CollisionInfo
	 */
	static public function test(entityA:IEntity, entityB:IEntity):CollisionInfo
	{
		var shapeA:IShape = entityA.collider.shape;
		var shapeB:IShape = entityB.collider.shape;
		
		// circle circle is easy
		if (Std.is(shapeA, Circle) && Std.is(shapeB, Circle))
		{
			return checkCircleCollision(entityA, entityB, true);
		}
		
		var result1:CollisionInfo;
		var result2:CollisionInfo;			
		
		// most likely two polygons, test for that next...
		if (Std.is(shapeA, IPolygon) && Std.is(shapeB, IPolygon) )
		{
			// check both polygons sides against eachother
			result1 = checkPolygons(entityA, entityB, false, true);
			if (result1 == null) return null;
			
			result2 = checkPolygons(entityB, entityA, true, true);
			if (result2 == null) return null;
			
			// if no gap was found then return true
			if (Math.abs(result1.distance) < Math.abs(result2.distance)) return calculateCollisionInfoSeparation(result1, result2);
			return calculateCollisionInfoSeparation(result2, result1);
		}
		
		// finally, check for cirlce / polygon - it should be the oly option left
		if (shapeA == Circle) 
			result1 = checkCirclePolygon(entityA, entityB, true, true);
		else 
			result1 = checkCirclePolygon(entityB, entityA, false, true);
		
		if (result1 == null) return null;
		
		return calculateCollisionInfoSeparation(result1);
	}
	
	/**
	 * Tests the shapes from two entities colliders. Returns a a Bool if they collide or not.
	 * @param	shapeA
	 * @param	shapeB
	 * @return Bool
	 */
	static public function testBool(entityA:IEntity, entityB:IEntity):Bool 
	{			
		var shapeA:IShape = entityA.collider.shape;
		var shapeB:IShape = entityB.collider.shape;
		
		// circle circle is easy
		if (shapeA == Circle && shapeB == Circle)
		{
			return checkCircleCollision(entityA, entityB, false) != null;
		}
		
		var result1:CollisionInfo;
		
		// most likely two polygons, test for that next...
		if (shapeA == IPolygon && shapeB == IPolygon) 
		{
			// check both polygons sides against eachother
			result1 = checkPolygons(entityA, entityB, false, false);
			if (result1 == null) return false;
			
			result1 = checkPolygons(entityB, entityA, true, false);
			if (result1 == null) return false;
			
			// if no gap was found then return true
			return true;
		}
		
		// finally, check for cirlce / polygon - it should be the only option left
		if (shapeA == Circle) 
			result1 = checkCirclePolygon(entityA, entityB, true, true);
		else 
			result1 = checkCirclePolygon(entityB, entityA, false, true);
			
		if (result1 == null) return false;
			
		return true;
		
	}
	
	
	

	
	
	// STATIC PRIVATE FUNCTIONS
	// ------------------------------------------------------------------------------------------		
	/**
	 * Converts a Resolve object to a Point
	 * @param	obj
	 * @return
	 */
	static private function calculateCollisionInfoSeparation(obj:CollisionInfo, obj2:CollisionInfo = null):CollisionInfo 
	{
		obj.separation = new Point(obj.vector.x * obj.distance, obj.vector.y * obj.distance);
		obj.separation.x *= 1.000001; // @Adam - a little bit of padding to stop objects getting stuck on corners.
		obj.separation.y *= 1.000001;
		if (obj2 != null) obj.shapeAContained = (obj.shapeAContained && obj2.shapeAContained);	// hack to check for containment
		if (obj2 != null) obj.shapeBContained = (obj.shapeBContained && obj2.shapeBContained);	
		return obj;
	}
	
	
	/**
	 * Simple check for an overlap between 2 circles
	 * @param	circleA
	 * @param	circleB
	 * @return 	collisionInfo
	 */
	static private function checkCircleCollision(entityA:IEntity, entityB:IEntity, docalc:Bool):CollisionInfo 
	{	
		var circleA:Circle = cast(entityA.collider.shape, Circle);
		var circleB:Circle = cast(entityB.collider.shape, Circle);
		
		// get the toal of both radius
		//var radiusTotal:Float = Std.int(circleA.transformedRadius) +  Std.int(circleB.transformedRadius);
		var radiusTotal:Float = circleA.transformedRadius + circleB.transformedRadius;
		
		// look how far away the circles are
		var distSquared:Float = (circleB.x - circleA.x) * (circleB.x - circleA.x) + (circleB.y - circleA.y) * (circleB.y - circleA.y);
		
		// bail if not overlapping
		if (distSquared > (radiusTotal * radiusTotal)) return null;
		if (!docalc) return new CollisionInfo();
		
		// there is an overlap - figure out the separation;
		var dist:Float = Math.sqrt(distSquared);
		var diff:Float = radiusTotal - dist;
		
		var info:CollisionInfo = new CollisionInfo();
		info.entityA 		= entityA;
		info.entityB 		= entityB;
		info.shapeA 		= circleA;
		info.shapeB 		= circleB;
		info.vector 		= new Point(circleB.x - circleA.x, circleB.y - circleA.y);
		info.vector.normalize(1);			
		info.distance 		= Math.sqrt(distSquared);
		info.separation		= new Point(info.vector.x*diff, info.vector.y*diff);
		info.shapeAContained = (circleA.transformedRadius <= circleB.transformedRadius && dist <= circleB.transformedRadius - circleA.transformedRadius);
		info.shapeBContained = (circleB.transformedRadius <= circleA.transformedRadius && dist <= circleA.transformedRadius - circleB.transformedRadius);
		
		return info;
	}
	
	
	
	
	
	
	
	
	/**
	 * Checks for overlaps between polygons
	 * @param	polygonA
	 * @param	polygonB
	 * @param	flip
	 * @return
	 */
	static private function checkPolygons(entityA:IEntity, entityB:IEntity, flip:Bool, docalc:Bool ):CollisionInfo 
	{
		var polygonA:IPolygon = cast(entityA.collider.shape, IPolygon);
		var polygonB:IPolygon = cast(entityB.collider.shape, IPolygon);
		
		// working vars
		var min0:Float, max0:Float;
		var min1:Float, max1:Float;
		var vAxis	:Point;
		var sOffset	:Float;
		var vOffset	:Point;
		var d0		:Float;
		var d1		:Float;
		var i		:Int;
		var j		:Int;
		var t		:Float;
		var p1		:Array<Point>;
		var p2		:Array<Point>;
		var ra		:Point;
		
		var shortestDist:Float = 999999999;
		var distmin		:Float;
		var distminAbs	:Float;
		
		var result:CollisionInfo = new CollisionInfo();
		result.entityA 	= (flip) ? entityB : entityA;
		result.entityB 	= (flip) ? entityA : entityB;			
		result.shapeA 	= (flip) ? polygonB : polygonA;
		result.shapeB 	= (flip) ? polygonA : polygonB;
		result.shapeAContained = true;
		result.shapeBContained = true;
		
		// get the vertices
		p1 = polygonA.vertices.concat([]);
		p2 = polygonB.vertices.concat([]);
		
		// small hack here to deal with line segments - adds a small depth to make it act like a thing rectangle
		if (p1.length == 2) 
		{
			ra = new Point(-(p1[1].y - p1[0].y), p1[1].x - p1[0].x);
			ra.normalize(0.0000001);
			p1.push(p1[1].add(ra));
		}
		
		if (p2.length == 2) 
		{
			ra = new Point(-(p2[1].y - p2[0].y), p2[1].x - p2[0].x);
			ra.normalize(0.0000001);
			p2.push(p2[1].add(ra));
		}
		
		// get the offset
		vOffset = new Point(polygonA.x - polygonB.x, polygonA.y - polygonB.y);
		
		// loop through all of the axis on the first polygon
		//for (i = 0; i < p1.length; i++) 
		for (i in 0...p1.length) 
		{
			// find the axis that we will project onto
			vAxis = getAxisNormal(p1, i);
			
			// project polygon A
			min0 = vectorDotProduct(vAxis, p1[0]);
			max0 = min0;
			
			//for (j = 1; j < p1.length; j++) 
			for (j in 1...p1.length) 
			{
				t = vectorDotProduct(vAxis, p1[j]);
				if (t < min0) min0 = t;
				if (t > max0) max0 = t;
			}
			
			// project polygon B
			min1 = vectorDotProduct(vAxis, p2[0]);
			max1 = min1;
			
			//for (j = 1; j < p2.length; j++) 
			for (j in 1...p2.length) 
			{
				t = vectorDotProduct(vAxis, p2[j]);
				if (t < min1) min1 = t;
				if (t > max1) max1 = t;
			}
			
			// shift polygonA's projected Points
			sOffset = vectorDotProduct(vAxis, vOffset);
			min0 += sOffset;
			max0 += sOffset;
			
			// test for Intersections
			d0 = min0 - max1;
			d1 = min1 - max0;
			if (d0 > 0 || d1 > 0) 
			{
				// gap found
				return null;
			}
			
			if (docalc) 
			{
				// check for containment
				if (!flip) 
				{
					if (max0 > max1 || min0 < min1) result.shapeAContained = false;
					if (max1 > max0 || min1 < min0) result.shapeBContained = false;
				} 
				else 
				{
					if (max0 < max1 || min0 > min1) result.shapeAContained = false;				
					if (max1 < max0 || min1 > min0) result.shapeBContained = false;				
				}					
				
				distmin = (max1 - min0) * -1;  //Math.min(dist0, dist1);
				if (flip) distmin *= -1;
				distminAbs = (distmin < 0) ? distmin * -1 : distmin;
				if (distminAbs < shortestDist) 
				{
					// this distance is shorter so use it...
					result.distance = distmin;
					result.vector = vAxis;
					shortestDist = distminAbs;
				}
			}
			
		}
		// if you are here then no gap was found
		return result;
		
	}
	
	/**
	 * Checks for overlaps between the polygons and circles
	 * @param	circleA
	 * @param	polygonA
	 * @return
	 */
	static private function checkCirclePolygon(entityA:IEntity, entityB:IEntity, flip:Bool, docalc:Bool ):CollisionInfo 
	{
		var circleA:Circle 		= cast(entityA.collider.shape, Circle);
		var polygonA:IPolygon 	= cast(entityB.collider.shape, IPolygon);
		
		// working vars
		var min0:Float, max0:Float;
		var min1:Float, max1:Float;
		var vAxis:Point;
		var sOffset:Float;
		var vOffset:Point;
		var d0	:Float;
		var d1	:Float;
		var i	:Int;
		var j	:Int;
		var t	:Float;
		var p1	:Array<Point>;	// array of vertices
		var p2	:Array<Point>;
		
		
		var currentDist:Float;
		var dist:Float = 999999999;
		var closestPoint:Point = new Point();
		var ra:Point = new Point();
		
		var shortestDist:Float = 999999999;
		var distmin:Float;
		var distminAbs:Float;
		
		var result:CollisionInfo = new CollisionInfo();
		result.entityA = (flip) ? entityA : entityB;
		result.entityB = (flip) ? entityB : entityA;			
		result.shapeA = (flip) ? cast(circleA, IShape) : cast(polygonA, IShape);
		result.shapeB = (flip) ? cast(polygonA, IShape) : cast(circleA, IShape);
		
		result.shapeAContained = true;
		result.shapeBContained = true;
		
		
		// get the offset
		vOffset = new Point(polygonA.x - circleA.x, polygonA.y - circleA.y);			
		
		// get the vertices
		p1 = polygonA.vertices.concat([]);
		
		// small hack here to deal with line segments - adds a small depth to make it act like a thing rectangle
		if (p1.length == 2) 
		{
			ra = new Point(-(p1[1].y - p1[0].y), p1[1].x - p1[0].x);
			ra.normalize(0.00001);
			p1.push(p1[1].add(ra));
		}
		
		// find the closest Point
		//for each (var p:Point in p1) 
		for (p in p1)
		{
			currentDist = (circleA.x - (polygonA.x + p.x)) * (circleA.x - (polygonA.x + p.x)) + (circleA.y - (polygonA.y + p.y)) * (circleA.y - (polygonA.y + p.y));
			if (currentDist < dist) 
			{
				dist = currentDist;
				closestPoint.x = polygonA.x + p.x;
				closestPoint.y = polygonA.y + p.y;
			}				
		}
		
		// make a normal of this vector
		vAxis = new Point( closestPoint.x-circleA.x, closestPoint.y-circleA.y);
		vAxis.normalize(1);
		
		// project polygon A
		min0 = vectorDotProduct(vAxis, p1[0]);
		max0 = min0;
		//
		//for (j = 1; j < p1.length; j++) 
		for (j in 1...p1.length) 
		{
			t = vectorDotProduct(vAxis, p1[j]);
			if (t < min0) min0 = t;
			if (t > max0) max0 = t;			
		}
		
		// project circle A
		min1 = vectorDotProduct(vAxis, new Point(0,0) );
		max1 = min1 + circleA.transformedRadius;
		min1 -= circleA.transformedRadius;				
		
		// shift polygonA's projected Points
		sOffset = vectorDotProduct(vAxis, vOffset);
		min0 += sOffset;
		max0 += sOffset;				
		
		// test for Intersections
		d0 = min0 - max1;
		d1 = min1 - max0;
		
		if (d0 > 0 || d1 > 0) 
		{
			// gap found
			return null;
		}
		
		if (docalc) 
		{
			distmin = (max1 - min0) * -1;  //Math.min(dist0, dist1);
			if (flip) distmin *= -1;
			distminAbs = (distmin < 0) ? distmin * -1 : distmin;
						
			// check for containment
			if (!flip) 
			{
				if (max0 > max1 || min0 < min1) result.shapeAContained = false;
				if (max1 > max0 || min1 < min0) result.shapeBContained = false;
			} 
			else 
			{
				if (max0 < max1 || min0 > min1) result.shapeAContained = false;				
				if (max1 < max0 || min1 > min0) result.shapeBContained = false;				
			}			
			
			// this distance is shorter so use it...
			result.distance = distmin;
			result.vector = vAxis;
			//
			shortestDist = distminAbs;
		}
		
		// loop through all of the axis on the first polygon
		//for (i = 0; i < p1.length; i++) 
		for (i in 0...p1.length) 
		{
			// find the axis that we will project onto
			vAxis = getAxisNormal(p1, i);
			
			// project polygon A
			min0 = vectorDotProduct(vAxis, p1[0]);
			max0 = min0;
			
			//
			//for (j = 1; j < p1.length; j++) 
			for (j in 1...p1.length)
			{
				t = vectorDotProduct(vAxis, p1[j]);
				if (t < min0) min0 = t;
				if (t > max0) max0 = t;
			}
			
			// project circle A
			min1 = vectorDotProduct(vAxis, new Point(0,0) );
			max1 = min1 + circleA.transformedRadius;
			min1 -= circleA.transformedRadius;				
			
			// shift polygonA's projected Points
			sOffset = vectorDotProduct(vAxis, vOffset);
			min0 += sOffset;
			max0 += sOffset;				
			
			// test for Intersections
			d0 = min0 - max1;
			d1 = min1 - max0;
			
			if (d0 > 0 || d1 > 0) 
			{
				// gap found
				return null;
			}
			
			if (docalc) 
			{
				// check for containment
				if (!flip) 
				{
					if (max0 > max1 || min0 < min1) result.shapeAContained = false;
					if (max1 > max0 || min1 < min0) result.shapeBContained = false;
				} 
				else 
				{
					if (max0 < max1 || min0 > min1) result.shapeAContained = false;				
					if (max1 < max0 || min1 > min0) result.shapeBContained = false;				
				}				
				
				distmin = (max1 - min0) * -1;
				if (flip) distmin *= -1;
				distminAbs = (distmin < 0) ? distmin * -1 : distmin;
				if (distminAbs < shortestDist) 
				{
					// this distance is shorter so use it...
					result.distance = distmin;
					result.vector = vAxis;
					//
					shortestDist = distminAbs;
				}
			}
		}
		
		// if you are here then no gap was found
		return result;
	}		
	
	
	
	/**
	 * Returns the normal of a polygons side.
	 * @param	polygon	Array of Points
	 * @param	PointIndex
	 * @return
	 */
	static private function getAxisNormal(vertexArray:Array<Point>, PointIndex:Int):Point 
	{
		// grab the Points
		var pt1:Point = vertexArray[PointIndex];
		var pt2:Point = (PointIndex >= vertexArray.length - 1) ? vertexArray[0] : vertexArray[PointIndex + 1];
		//
		var p:Point = new Point( -(pt2.y - pt1.y), pt2.x - pt1.x);
		p.normalize(1);
		return p;
		
	}
	
	/**
	 * Returns the dor product of two vectors
	 * @param	pt1
	 * @param	pt2
	 * @return
	 */
	static private function vectorDotProduct(pt1:Point, pt2:Point):Float 
	{
		return (pt1.x * pt2.x + pt1.y * pt2.y);
	}		
	
	
	// EVENT HANDLERS
	// ------------------------------------------------------------------------------------------
	
	
	// GETTERS & SETTERS
	// ------------------------------------------------------------------------------------------
}

