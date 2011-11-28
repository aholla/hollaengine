/**
* The collision manager stores the entities that need testing for colliding.
* It uses a quadtree to find out which entities need to be tested. Then it tests 
* them for collision using SATCollision and finally if there is a collision, 
* inform the entities involved.
* @author Adam
*/

package aholla.henginex.managers ;

//import aholla.henginex.collision.QuadtreeNode;
import aholla.henginex.core.entity.IEntity;

//import aholla.henginex.collision.CollisionInfo;
//import aholla.henginex.collision.QuadtreeNode;
//import aholla.henginex.collision.SATCollision;
//import aholla.henginex.core.entity.IEntity;
//import aholla.henginex.HE;
//import flash.geom.Rectangle;
//import flash.utils.Dictionary;


class CollisionManager
{			
	//public var quadtree							:QuadtreeNode; // currently public for the process manage to inform it if an entity moves.
	
	//private var collisionDict					:Dictionary;
	private var collisionList					:Array<IEntity>;
	
/*--------------------------------------------------
* PUBLIC CONSTRUCTOR
--------------------------------------------------*/
	
	public function new() 
	{				
		//quadtree 		= new QuadtreeNode(new Rectangle(0, 0, HE.WORLD_WIDTH, HE.WORLD_HEIGHT));				
		//collisionList 	= new Vector.<IEntity>;
		//collisionDict 	= new Dictionary(true);
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
		//collisionList.push(entity)
		//collisionDict[entity] = entity;
		//quadtree.insert(entity);
	} 
	
	public function removeCollision(entity:IEntity):Void
	{
		//quadtree.remove(entity);
		//delete collisionDict[entity];		
	}
	
	public function onUpdate():Void
	{	
		//if (!HE.isPaused)
		//{
			//var i:Int;				
			//var len:Int;
			//var _entityA:IEntity;
			//var _entityB:IEntity;
			//
			///* first update quadtree*/
			//len = collisionList.length;
			//for (i = 0; i < len; i++) 
			//{
				//_entityA = collisionList[i] as IEntity;
				//if (_entityA.transform.hasMoved)
				//{
					//quadtree.moved(_entityA);
					//_entityA.transform.hasMoved = false;
				//}					
			//}
			//
			//len = collisionList.length;
			//for (i = 0; i < len; i++) 
			//{
				//_entityA = collisionList[i] as IEntity;
				//
				//if (!_entityA.collider.isCollider || !_entityA.isActive) 
					//continue;
				//
				//var neighbourList:Vector.<IEntity> = quadtree.query(_entityA.transform.bounds);
				//var nLen:Int = neighbourList.length;
				//if (nLen > 1)
				//{
					//for (var j:Int = 0; j < nLen; j++) 
					//{
						//_entityB = neighbourList[j] as IEntity;
						//if (_entityB)
						//{
							//if (_entityA == _entityB || !_entityB || !_entityB.isActive || !_entityB.collider.isActive || !_entityA)
								//continue;
							//
							//if (_entityA.collider.colliderGroup == _entityB.collider.colliderGroup)
								//continue;									
							//else
								//testCollision(_entityA, _entityB);
						//}
					//}
				//}
			//}
		//}
	}
	
	public function destroy():Void
	{
		//quadtree.destroy();
		//quadtree = null;		
	}
	
	public function updateWorldSize():Void
	{			
		//quadtree.destroy();
		//quadtree = null;
		//quadtree = new QuadtreeNode(new Rectangle(0, 0, HE.WORLD_WIDTH, HE.WORLD_HEIGHT));
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
		//var collisionInfo:CollisionInfo = SATCollision.test(entityA, entityB);			
		//if (collisionInfo) 
		//{	
			//if(entityA)	entityA.onCollision(collisionInfo);
			//if(entityB)	entityB.onCollision(collisionInfo);
		//}
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
	
	

}