/**
 * The collision manager stores the entities that need testing for colliding.
 * It uses a quadtree to find out which entities need to be tested. Then it tests 
 * them for collision using SATCollision and finally if there is a collision, 
 * inform the entities involved.
 * @author Adam
 */
	
package aholla.HEngine.managers 
{
	import aholla.HEngine.collision.CollisionInfo;
	import aholla.HEngine.collision.QuadtreeNode;
	import aholla.HEngine.collision.SATCollision;
	import aholla.HEngine.core.entity.ColliderComponent;
	import aholla.HEngine.core.entity.Entity;
	import aholla.HEngine.core.entity.IEntity;
	import aholla.HEngine.HE;
	import de.polygonal.ds.SLL;
	import de.polygonal.ds.SLLNode;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;


	public class CollisionManager
	{			
		public var quadtree							:QuadtreeNode; // currently public for the process manage to inform it if an entity moves.
		
		private var entityA							:IEntity;
		private var entityB							:IEntity;		
		private var collisionVec					:Vector.<IEntity>;
		private var neighboursVec					:Vector.<IEntity>;
		private var nLen							:int;
		private var iLen							:int;	
		
		private var collisionList					:SLL;
		private var collisionDict					:Dictionary;
		
/*--------------------------------------------------
* PUBLIC CONSTRUCTOR
--------------------------------------------------*/
		
		public function CollisionManager() 
		{	
			collisionVec 	= new Vector.<IEntity>();
			neighboursVec 	= new Vector.<IEntity>();
			quadtree = new QuadtreeNode(new Rectangle(0, 0, HE.WORLD_WIDTH, HE.WORLD_HEIGHT));	
			
			collisionList = new SLL();
			collisionDict = new Dictionary(true);
		}
		
/*-------------------------------------------------
* PUBLIC METHODS
-------------------------------------------------*/
		
		/**
		 * Adds an Entity to the collision list that is check each frame for collision. 
		 * The Entity is added to the quadtree for spacial management.
		 * @param	$entity:IEntity
		 */
		public function addCollision($entity:IEntity):void
		{
			//collisionVec[collisionVec.length] = $entity;			
			collisionList.append($entity);
			collisionDict[$entity] = $entity
			
			trace("addCollision", $entity)
			quadtree.insert($entity);
		} 
		
		public function removeCollision($entity:IEntity):void
		{
			quadtree.remove($entity);
			//var i:int = collisionVec.indexOf($entity);			
			//if(i > -1 && i < collisionVec.length)
				//collisionVec[i] = null;
			var node:SLLNode = (collisionDict[$entity] as SLLNode);
			if (node)
			{
				node.free();
				node.unlink();
				delete collisionDict[$entity];
			}			
		}
		
		public function onUpdate():void
		{		
			iLen = collisionVec.length;		
			if (!HE.isPaused)
			{
				// first update quadtree
				var node:SLLNode = collisionList.head;
				while (node)
				{
					entityA = (node.val as IEntity);
					if (entityA.transform.hasMoved)
					{
						quadtree.moved(entityA);
						entityA.transform.hasMoved = false;
					}
					node = node.next;
				}
				
				node  = collisionList.head;
				while (node)
				{
					entityA = (node.val as IEntity);	
					
					trace(entityA.transform.bounds)
					
					if (!entityA.collider.isCollider || !entityA.isActive) 
					{
						node = node.next;
						continue;	
					}
					
					var entityList:SLL = quadtree.query(entityA.transform.bounds);					
					if (entityList.size() > 1)
					{
						var entityItem:SLLNode = entityList.head;
						while (entityItem)
						{
							entityB = entityItem.val as Entity;							
							
							if (entityB)
							{
								if (entityA == entityB || !entityB || !entityB.isActive || !entityB.collider.isActive || !entityA)	
								{
									entityItem = entityItem.next;
									continue;
								}
								
								if (entityA.collider.colliderGroup == entityB.collider.colliderGroup)
								{
									entityItem = entityItem.next;
									continue;
								}
								else
								{
									testCollision(entityA, entityB);
								}
							}
							entityItem = entityItem.next;
						}
					}					
					node = node.next;
				}
			}

		}
		
		public function destroy():void 
		{
			collisionVec.length = 0;
			neighboursVec.length = 0;
			
			collisionVec = null;
			neighboursVec = null;
			
			quadtree.destroy();
			quadtree = null;
			
			entityA = null;
			entityB = null;			
		}
		
		public function updateWorldSize():void 
		{			
			quadtree.destroy();
			quadtree = null;
			quadtree = new QuadtreeNode(new Rectangle(0, 0, HE.WORLD_WIDTH, HE.WORLD_HEIGHT));
		}
		
/*-------------------------------------------------
* PRIVATE METHODS
-------------------------------------------------*/
		
		
		private function testCollision($entityA:IEntity, $entityB:IEntity):void
		{	
			$entityA.collider.shape.x = $entityA.transform.x;
			$entityA.collider.shape.y = $entityA.transform.y;
			$entityB.collider.shape.x = $entityB.transform.x;
			$entityB.collider.shape.y = $entityB.transform.y;
			
			var collisionInfo:CollisionInfo = SATCollision.test($entityA, $entityB);			
			if (collisionInfo) 
			{	
				if($entityA)	$entityA.onCollision(collisionInfo);
				if($entityB)	$entityB.onCollision(collisionInfo);
			}
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		
	}	
}