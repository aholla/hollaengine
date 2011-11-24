/**
 * SAT code from http://www.sevenson.com.au/actionscript/sat/
 * Repackaged and adjusted to fit within HEngine and to keep things clean.
 * Origional package: com.sevenson.geom.sat.Collision
 * @author Andrew Sevenson
 * 
*/

package aholla.HEngine.collision.shapes
{
	import flash.geom.Point;
	
	public interface IPolygon extends IShape
	{		
		function get vertices():Vector.<Point>;		// returns the vertices with transformations applied		
		function get rawVertices():Vector.<Point>; 	// vertices with no transformations 

	}
}