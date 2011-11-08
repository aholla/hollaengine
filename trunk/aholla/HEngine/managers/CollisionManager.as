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
	import aholla.HEngine.core.entity.Entity;
	import aholla.HEngine.core.entity.IEntity;
	import aholla.HEngine.HE;
	import de.polygonal.ds.SLL;
	import de.polygonal.ds.SLLNode;
	import flash.geom.Rectangle;


	public class CollisionManager
	{			
		public var quadtree							:QuadtreeNode; // currently public for the process manage to inform it if an entity moves.
		
		private var entityA							:IEntity;
		private var entityB							:IEntity;		
		private var collisionVec					:Vector.<IEntity>;
		private var neighboursVec					:Vector.<IEntity>;
		private var nLen							:int;
		private var iLen							:int;		
		
/*--------------------------------------------------
* PUBLIC CONSTRUCTOR
--------------------------------------------------*/
		
		public function CollisionManager() 
		{	
			collisionVec 	= new Vector.<IEntity>();
			neighboursVec 	= new Vector.<IEntity>();
			quadtree = new QuadtreeNode(new Rectangle(0, 0, HE.WORLD_WIDTH, HE.WORLD_HEIGHT));				
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
			collisionVec[collisionVec.length] = $entity;			
			quadtree.insert($entity);
		}
		
		public function removeCollision($entity:IEntity):void
		{
			quadtree.remove($entity);
			var i:int = collisionVec.indexOf($entity);			
			if(i > -1 && i < collisionVec.length)
				collisionVec[i] = null;
		}
		
		public function update():void
		{		
			iLen = collisionVec.length;			
			if (!HE.isPaused)
			{
				/*
				// TODO - need to break the transform Component out from teh rest as this loop could be long for little reward.
				i = _componentVec.length;
				while(i--)
				{
					if (_componentVec[i] is ColliderComponent)		
					{
						var _comp:ColliderComponent = _componentVec[i] as ColliderComponent;
						if (_comp.hasMoved)
						{
							collisionManager.quadtree.moved(_comp.owner);
							_comp.hasMoved = false;
						}
					}
				}
				*/
				
				
				for (var i:int = 0; i < iLen; i++) 
				{
					entityA = collisionVec[i];
					
					if (entityA)
					{						
						if (!entityA.collider.isCollider || !entityA.isActive) continue;	
						
						var entityList:SLL = quadtree.query(entityA.transform.bounds);
						if (entityList.size() > 1)
						{
							//trace(entityList.size)
							
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
					}
				}			
				entityA = null;
				entityB = null;	 
			}
			
			// remove nulls
			/*
			iLen = collisionVec.length;	
			while (iLen--)
			{
				if (!collisionVec[iLen])
				{
					trace("CollisionManager - Found Null");
					collisionVec.splice(iLen, 1);
				}
			}	
			*/
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