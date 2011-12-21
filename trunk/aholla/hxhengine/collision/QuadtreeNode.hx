/**
* Based upon the C# quadtree found here: http://www.codeproject.com/KB/recipes/QuadTree.aspx
* @author Adam H.
* 
*/

package aholla.hxhengine.collision;

import aholla.hxhengine.core.entity.IEntity;
import aholla.hxhengine.HE;
import nme.geom.Rectangle;

class QuadtreeNode
{
	public static var MIN_SIZE						:Int = 100;
	
	private var nodes(default, null)				:Array<QuadtreeNode>;
	private var contents(default, null)				:Array<IEntity>;
	private var bounds(default, null)				:Rectangle;
	private var centerX								:Int;
	private var centerY								:Int;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
	public function new(bounds:Rectangle)
	{
		this.bounds = bounds;	
		
		nodes 		= [];
		contents 	= [];				
		centerX 	= Std.int(bounds.width * 0.5);
		centerY 	= Std.int(bounds.height * 0.5);
		
		
		//trace(["new quad", bounds]);
		
		if (HE.isDebugShowQuadTree)
		{
			HE.world.debugLayer.graphics.lineStyle(0.5, 0x99B5FF, 0.1);
			HE.world.debugLayer.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
		}
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	/**
	 * Inserts an Entities Into the Quadtree.
	 * @param	entity
	 */
	public function insert(entity:IEntity):Void
	{				
		// if the entities is outside the quadtree, there's a problem.
		if (!bounds.containsRect(entity.transform.bounds))
		{
			if (HE.isDebug)
				trace("ERROR Quadtree: entity - " + entity.name + " out of the bounds.");
			return;
		}					
		
		// If there are no subnodes and the node is a Leaf then create the subnodes if greater 
		// than the smallest size (tuning the node Into a Branch).
		if (nodes.length == 0)
		{			
			// the smallest subnode has an area 
			if ((bounds.height * bounds.width) <= MIN_SIZE)
				return;
				
			nodes.push(new QuadtreeNode(new Rectangle(bounds.x, bounds.y, centerX, centerY)));
			nodes.push(new QuadtreeNode(new Rectangle(bounds.left, bounds.top + centerY, centerX, centerY)));
			nodes.push(new QuadtreeNode(new Rectangle(bounds.left + centerX, bounds.top, centerX, centerY)));
			nodes.push(new QuadtreeNode(new Rectangle(bounds.left + centerX, bounds.top + centerY, centerX, centerY)));
		}
		
		// for each subnode:
		// if the node contains the entity, add the item to that node and return
		// this recurses Into the node that is just large enough to fit this item
		for (i in 0...nodes.length) 
		{
			var item:QuadtreeNode = nodes[i];
			if(item.bounds.containsRect(entity.transform.bounds))
			{
				item.insert(entity);
				return;
			}
		}			
		
		// if we make it to here, either
		// 1) none of the subnodes completely contained the entity. or
		// 2) we're at the smallest subnode size allowed 
		// add the item to this node's contents.
		contents.push(entity);
		
		// Add the reference o f teh quad tree to teh entity (stored in the collider
		// as that seems a good place) for fast easy removal when it moves of is deleted.	
		entity.collider.quadtreeNode = this;			
	}
	
	
	/**
	 * Returns all the Entities within the Bounds supplied.
	 * @param	queryBounds
	 * @return
	 */
	public function query(queryBounds:Rectangle):Array<IEntity>
	{		
		var results:Array<IEntity> = [];			
		
		// this quad contains items that are not entirely contained by
		// it's four sub-quads. Iterate through the items in this quad 
		// to see if they Intersect.			
		var i:Int;
		var len:Int;
		
		len = contents.length;
		for (i in 0...len) 
		{
			var item:IEntity = contents[i];
			if (queryBounds.intersects(item.transform.bounds))
			{
				results.push(item);
			}
		}
		
		len = nodes.length;
		for (i in 0...len)
		{
			var node:QuadtreeNode = nodes[i];
			
			if (node.isEmpty())
				continue;
				
			// Case 1: search area completely contained by sub-quad
			// if a node completely contains the query area, go down that branch
			// and skip the remaining nodes (break this loop)
			if (node.bounds.containsRect(queryBounds))
			{
				results = results.concat(node.query(queryBounds));
				break;
			}
			
			// Case 2: Sub-quad completely contained by search area 
			// if the query area completely contains a sub-quad,
			// just add all the contents of that quad and it's children 
			// to the result set. You need to continue the loop to test 
			// the other quads		
			if (queryBounds.containsRect(node.bounds))
			{
				results = results.concat(node.subTreeContents());
				continue;
			}
			
			//Case 3: search area Intersects with sub-quad
			//traverse Into this quad, continue the loop to search other
			//quads	
			if (node.bounds.intersects(queryBounds))
			{
				results = results.concat(node.query(queryBounds));
			}
		}			
		return results;
	}		
	
	
	/**
	 * Returns all the Entities within the child nodes.
	 * @return
	 */
	public function subTreeContents():Array<IEntity>
	{
		var results:Array<IEntity> = [];			
		var len:Int = nodes.length;
		for (i in 0...len) 
		{
			var node:QuadtreeNode = nodes[i];
			results = results.concat(node.subTreeContents());
		}
		return results;
	}	
	
	
	/**
	 * Returns in the node is empty (LEAF) or if it contains other nodes (BRANCH).
	 * @return
	 */
	public function isEmpty():Bool 
	{
		return nodes.length == 0;
	}	
	
	
	/**
	 * If an entity moves it is removed from the quadtreeNode and then inserted at the root.
	 * @param	entity
	 */
	public function moved(entity:IEntity):Void
	{
		remove(entity);
		insert(entity);
	}
	
	
	/**
	 * Removes the entity from its containing node.
	 * @param	entity
	 */
	public function remove(entity:IEntity):Void
	{
		// retrieves the node where the entity is stored (from the collider)
		// and removed it from teh conects of the node.	
		if (entity.collider.quadtreeNode != null)
		{
			//var index:Int = entity.collider.quadtreeNode.contents.indexOf(entity);
			var index:Int = Lambda.indexOf(entity.collider.quadtreeNode.contents, entity);
			if (index != -1)
			{
				entity.collider.quadtreeNode.contents.splice(index, 1);
				entity.collider.quadtreeNode = null;
			}
		}
	}
	
	
	/**
	 * Destroys the node and subnodes.
	 */		
	public function destroy():Void 
	{
		contents 	= [];
		nodes 		= [];
	}
	
	
	/**
	 * Destroys the node and subnodes.
	 */		
	public function reset():Void 
	{
		destroy();			
		centerX = Std.int(bounds.width * 0.5);
		centerY = Std.int(bounds.height * 0.5);
	}
	
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/		
	
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
}