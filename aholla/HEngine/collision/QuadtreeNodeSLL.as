/**
 * Based upon the C# quadtree found here: http://www.codeproject.com/KB/recipes/QuadTree.aspx
 * @author Adam H.
 * 
 */

package aholla.HEngine.collision
{
	import aholla.HEngine.core.entity.IEntity;
	import aholla.HEngine.HE;
	import de.polygonal.ds.SLL;
	import de.polygonal.ds.SLLIterator;
	import de.polygonal.ds.SLLNode;
	import flash.geom.Rectangle;
	
	public class QuadtreeNodeSLL
	{
		public static var MIN_SIZE					:int = 100;
		
		private var _nodes							:SLL;
		private var _contents						:SLL;
		private var _bounds							:Rectangle;
		private var centerX							:int = 0;
		private var centerY							:int = 0;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function QuadtreeNodeSLL($bounds:Rectangle)
		{
			_nodes 		= new SLL();
			_contents 	= new SLL();
			_bounds 	= $bounds;
			
			centerX = _bounds.width * 0.5;
			centerY = _bounds.height * 0.5;				
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		

		/**
		 * Inserts an Entities into the Quadtree.
		 * @param	$entity
		 */
		public function insert($entity:IEntity):void
		{
			// if the entities is outside the quadtree, there's a problem.
            if (!_bounds.containsRect($entity.transform.bounds))
            {
                if (HE.isDebug)
					trace("ERROR Quadtree: $entity - " + $entity.name + " out of the bounds.");
                return;
            }					
			
			// If there are no subnodes and the node is a Leaf then create the subnodes if greater 
			// than the smallest size (tuning the node into a Branch).
            if (_nodes.isEmpty())
			{			
				// the smallest subnode has an area 
				if ((_bounds.height * _bounds.width) <= MIN_SIZE)
					return;
					
				_nodes.append(new QuadtreeNodeSLL(new Rectangle(_bounds.x, _bounds.y, centerX, centerY)));
				_nodes.append(new QuadtreeNodeSLL(new Rectangle(_bounds.left, _bounds.top + centerY, centerX, centerY)));
				_nodes.append(new QuadtreeNodeSLL(new Rectangle(_bounds.left + centerX, _bounds.top, centerX, centerY)));
				_nodes.append(new QuadtreeNodeSLL(new Rectangle(_bounds.left + centerX, _bounds.top + centerY, centerX, centerY)));
			}
			
            // for each subnode:
            // if the node contains the entity, add the item to that node and return
            // this recurses into the node that is just large enough to fit this item            
			var quadtreeNode:SLLNode = _nodes.head;
			while (quadtreeNode)
			{
				if ((quadtreeNode.val as QuadtreeNodeSLL).bounds.containsRect($entity.transform.bounds))
                {
					(quadtreeNode.val as QuadtreeNodeSLL).insert($entity);
                    return;
                }
				quadtreeNode = quadtreeNode.next;
			}	
			
            // if we make it to here, either
            // 1) none of the subnodes completely contained the entity. or
            // 2) we're at the smallest subnode size allowed 
            // add the item to this node's contents.
			
			// Add the reference o f teh quad tree to teh entity (stored in the collider
			// as that seems a good place) for fast easy removal when it moves of is deleted.
			
			$entity.collider.quadtreeNode = _contents.append($entity);	
		}
		
		
		/**
		 * Returns all the Entities within the Bounds supplied.
		 * @param	$queryBounds
		 * @return
		 */
		public function query($queryBounds:Rectangle):SLL
		{		
			var results:SLL = new SLL();
			
			// this quad contains items that are not entirely contained by
			// it's four sub-quads. Iterate through the items in this quad 
			// to see if they intersect.
			var contentNode:SLLNode = _contents.head;
			while (contentNode)
			{
				if ($queryBounds.intersects((contentNode.val as IEntity).transform.bounds))
				{
					results.append(contentNode.val);
				}
				contentNode = contentNode.next;
			}
			//contentNode.free();
			//contentNode = null;
			
			var quadtreeNode:SLLNode = _nodes.head;
			while (quadtreeNode)
			{
				var node:QuadtreeNodeSLL = quadtreeNode.val as QuadtreeNodeSLL;
				
				if (node.isEmpty())
				{
					quadtreeNode = quadtreeNode.next;
					continue;
				}
				
				// Case 1: search area completely contained by sub-quad
				// if a node completely contains the query area, go down that branch
				// and skip the remaining nodes (break this loop)				
				if (node.bounds.containsRect($queryBounds))
				{
					results.merge(node.query($queryBounds));
					break;
				}
				
				// Case 2: Sub-quad completely contained by search area 
				// if the query area completely contains a sub-quad,
				// just add all the contents of that quad and it's children 
				// to the result set. You need to continue the loop to test 
				// the other quads				
				if ($queryBounds.containsRect(node.bounds))
				{
					results.merge(node.subTreeContents());
					quadtreeNode = quadtreeNode.next;
					continue;
				}
				
				//Case 3: search area intersects with sub-quad
				//traverse into this quad, continue the loop to search other
				//quads				
				if (node.bounds.intersects($queryBounds))
				{
					results.merge(node.query($queryBounds));
				}
				
				quadtreeNode = quadtreeNode.next;
			}
			return results;
		}		
		
		
		/**
		 * Returns all the Entities within the child nodes.
		 * @return
		 */
		public function subTreeContents():SLL
		{
			var results:SLL = new SLL();
			results = results.concat(_contents);
			
			var quadtreeNode:SLLNode = _nodes.head;
			while (quadtreeNode)
			{
				results.merge((quadtreeNode.val as QuadtreeNodeSLL).subTreeContents())
				quadtreeNode = quadtreeNode.next;
			}	
			return results;
		}	
		
		
		/**
		 * Returns in the node is empty (LEAF) or if it contains other nodes (BRANCH).
		 * @return
		 */
		public function isEmpty():Boolean 
		{
			return _nodes.size() == 0;
		}	
		
		
		/**
		 * If an entity moves it is removed from the quadtreeNode and then inserted at the root.
		 * @param	$entity
		 */
		public function moved($entity:IEntity):void
		{
			remove($entity);
			insert($entity);
		}
		
		
		/**
		 * Removes the entity from its containing node.
		 * @param	$entity
		 */
		public function remove($entity:IEntity):void
		{
			// retrieves the node where the entity is stored (from the collider)
			// and removed it from teh conects of the node.
			if ($entity.collider.quadtreeNode)
			{
				var node:SLLNode = $entity.collider.quadtreeNode;				
				node.unlink();
				node.free();
				$entity.collider.quadtreeNode = null;			
			}
		}
		
		
		/**
		 * Destroys the node and subnodes.
		 */		
		public function destroy():void 
		{
			_contents.merge(subTreeContents());
			_contents.clear();
			_nodes.clear();
			_contents.clear();			
			_nodes  	= null;
			_contents  	= null;
		}
		
		/**
		 * Destroys the node and subnodes.
		 */		
		public function reset():void 
		{
			destroy();
			_nodes 		= new SLL();
			_contents 	= new SLL();			
			centerX = _bounds.width * 0.5;
			centerY = _bounds.height * 0.5;
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
		
		public function get contents():SLL			{	return _contents;}		
		public function get nodes():SLL 			{	return _nodes;	}		
		public function get bounds():Rectangle 		{	return _bounds;	}
		
	}

}