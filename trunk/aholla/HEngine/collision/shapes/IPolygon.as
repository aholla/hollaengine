/**
 * SAT code from http://www.sevenson.com.au/actionscript/sat/
 * Repackaged and adjusted to fit within HEngine and to keep things clean.
 * Origional package: com.sevenson.geom.sat.Collision
 * @author Andrew Sevenson
 * 
*/

package aholla.HEngine.collision.shapes
{
	
	public interface IPolygon extends IShape
	{		
		function get vertices():Array ;		// returns the vertices with transformations applied		
		function get rawVertices():Array; 	// vertices with no transformations 

	}
}