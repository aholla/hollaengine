/**
 * ...
 * @author Adam
 */

package aholla.henginex.managers;

import aholla.henginex.core.entity.Entity;
import aholla.henginex.core.entity.IEntity;

class EntityManager
{
	public var entityHash(default, null)			:Hash<IEntity>;
	private var count								:Int;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new()
	{
		count = 0;
		entityHash = new Hash<IEntity>();
	}		
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	/**
	 * Creates the Entity and adds it to the list.
	 * @param	name
	 * @param	isCollidable
	 * @return
	 */
	public function createEntity(name:String, isCollidable:Bool = true):IEntity 
	{
		var name:String = name.toLowerCase();
		if (entityHash.exists(name))
		{
			count++;
			name += Std.string(count);
		}
		
		var _entity:IEntity = new Entity(name);
		_entity.groupName = name;
		
		entityHash.set(_entity.hashKey, _entity);
		
		return _entity;
	}
	
	/**
	 * Removed the named entity from the list.
	 * @param	name
	 */
	public function removeEntity(name:String):Void 
	{
		if (entityHash.exists(name))
			entityHash.remove(name);
	}
	
	/**
	 * Returns the named entity from the list.
	 * @param	name
	 * @return IEntity
	 */
	public function getEntity(name:String):IEntity
	{
		if (entityHash.exists(name))
			return entityHash.get(name);
		else
			return null;
	}
	
	/**
	 * Destroys the list and the entities stored in it.
	 */
	public function destroy():Void 
	{
		for (i in entityHash)
		{
			entityHash.remove(i.hashKey);
			i.destroy();
		}
		entityHash = null;
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
