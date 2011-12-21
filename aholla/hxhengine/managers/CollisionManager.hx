/**
* The collision manager stores the entities that need testing for colliding.
* It uses a quadtree to find out which entities need to be tested. Then it tests 
* them for collision using SATCollision and finally if there is a collision, 
* inform the entities involved.
* @author Adam
*/

package aholla.hxhengine.managers ;

//import aholla.hxhengine.collision.QuadtreeNode;
import aholla.hxhengine.collision.CollisionInfo;
import aholla.hxhengine.collision.QuadtreeNode;
import aholla.hxhengine.collision.SATCollision;
import aholla.hxhengine.core.entity.IEntity;
import aholla.hxhengine.HE;
import nme.geom.Rectangle;


class CollisionManager
{			
	public var quadtree								:QuadtreeNode; // currently public for the process manage to inform it if an entity moves.
	private var collisionList						:Array<IEntity>;
	private var collisionHash						:Hash<IEntity>;
	
/*--------------------------------------------------
* PUBLIC CONSTRUCTOR
--------------------------------------------------*/
	
	public function new() 
	{				
		quadtree 		= new QuadtreeNode(new Rectangle(0, 0, HE.WORLD_WIDTH, HE.WORLD_HEIGHT));				
		collisionList 	= new Array<IEntity>();
		collisionHash 	= new Hash<IEntity>();
	}
	
/*-------------------------------------------------
* PUBLIC METHODS
-------------------------------------------------*/
	
	/**
	 * Adds an Entity to the collision list that is check each frame for collision. 
	 * The Entity is added to the quadtree for spacial management.
	 * @param	entity:IEntity
	 */
	public function addCollision(entity:IEntity):Void
	{
		collisionList.push(entity);
		collisionHash.set(entity.hashKey, entity);
		quadtree.insert(entity);
	} 
	
	public function removeCollision(entity:IEntity):Void
	{
		quadtree.remove(entity);
		collisionHash.remove(entity.hashKey);	
	}
	
	public function onUpdate():Void
	{	
		if (!HE.isPaused)
		{
			var i:Int;				
			var len:Int;
			var _entityA:IEntity;
			var _entityB:IEntity;
			
			/* first update quadtree*/
			len = collisionList.length;
			for (i in 0...len) 
			{
				_entityA = collisionList[i];				
				if (_entityA.transform.hasMoved)
				{
					quadtree.moved(_entityA);
					_entityA.transform.hasMoved = false;
				}					
			}
			
			len = collisionList.length;
			for (i in 0...len) 
			{
				_entityA = collisionList[i];
				
				if (!_entityA.collider.isCollider || !_entityA.isActive) 
					continue;
				
				var neighbourList:Array<IEntity> = quadtree.query(_entityA.transform.bounds);
				
				var nLen:Int = neighbourList.length;
				
				trace(nLen);
				
				if (nLen > 1)
				{
					for (j in 0...len)
					{
						_entityB = neighbourList[j];
						if (_entityB != null)
						{
							if (_entityA == _entityB || _entityB == null || !_entityB.isActive || !_entityB.collider.isActive || _entityA == null)
								continue;
							
							if (_entityA.collider.colliderGroup == _entityB.collider.colliderGroup)
								continue;									
							else
								testCollision(_entityA, _entityB);
						}
					}
				}
			}
		}
	}
	
	public function destroy():Void
	{
		quadtree.destroy();
		quadtree = null;		
	}
	
	public function updateWorldSize():Void
	{			
		quadtree.destroy();
		quadtree = null;
		quadtree = new QuadtreeNode(new Rectangle(0, 0, HE.WORLD_WIDTH, HE.WORLD_HEIGHT));
	}
	
/*-------------------------------------------------
* PRIVATE METHODS
-------------------------------------------------*/
	
	
	private function testCollision(entityA:IEntity, entityB:IEntity):Void
	{	
		//entityA.collider.shape.x = entityA.transform.x;
		//entityA.collider.shape.y = entityA.transform.y;
		//entityB.collider.shape.x = entityB.transform.x;
		//entityB.collider.shape.y = entityB.transform.y;
		//
		var collisionInfo:CollisionInfo = SATCollision.test(entityA, entityB);			
		if (collisionInfo != null) 
		{	
			if(entityA != null)	entityA.onCollision(collisionInfo);
			if(entityB != null)	entityB.onCollision(collisionInfo);
		}
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
	
	

}