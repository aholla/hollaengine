/**
 * ...
 * @author Adam
 */

package aholla.henginex.managers;

import aholla.henginex.core.entity.IEntity;

//import aholla.henginex.core.entity.Entity;
//import aholla.henginex.core.entity.IEntity;
//import aholla.henginex.core.Logger;
//import flash.utils.Dictionary;

class EntityManager
{
	//private var _entityDict						:Dictionary = new Dictionary(true);
	private var _count							:Int;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new()
	{
		_count = 0;
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
		//if (_entityDict)
		//{
			//var name:String = name.toLowerCase();
			//if (_entityDict[name])
			//{
				//_count++;
				//name += String(_count);
			//}
			//
			//var _entity:IEntity = new Entity(name);
			//_entityDict[name] = _entity;
			//_entity.groupName = name;
			//return _entity;
		//}
		//else
		//{
			//Logger.warn("EntityManger - createEntity: entityDict does not exist, means it has been destroyed");
			return null;
		//}
	}
	
	/**
	 * Removed the named entity from the list.
	 * @param	name
	 */
	public function removeEntity(name:String):Void 
	{
		//var _name:String = name.toLowerCase();			
		//if (_entityDict[_name])
		//{
			//_entityDict[_name] = null;
			//delete _entityDict[_name];
		//}
	}
	
	/**
	 * Returns the named entity from the list.
	 * @param	name
	 * @return IEntity
	 */
	public function getEntity(name:String):IEntity
	{
		//var _name:String = name.toLowerCase();
		//if (_entityDict[_name])
		//{
			//return _entityDict[_name];
		//}
		//else
		//{
			//Logger.error(this, "HE.EntityManager - getEntity: Entity not found." + name);
			return null;
		//}
	}
	
	/**
	 * Destroys the list and the entities stored in it.
	 */
	public function destroy():Void 
	{
		//for (var key:Object in _entityDict) 
		//{
			//_entityDict[key].destroy();
			//delete _entityDict[key];
		//}
		//_entityDict = null;
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
	
	//public function get entityDict():Dictionary	{ return _entityDict };
	//public function get entityDict():*	{ return _entityDict };
	
}
