/**
* SAT code from http://www.sevenson.com.au/actionscript/sat/
* Repackaged and adjusted to fit within HEngine and to keep things clean.
* Origional package: com.sevenson.geom.sat.Collision
* @author Andrew Sevenson
* 
*/

package aholla.henginex.collision.shapes;

import nme.geom.Point;

interface IPolygon implements IShape
{		
	var vertices(getVertices, null):Array<Point>;
	var rawVertices(getRawVertices, null):Array<Point>;

}
