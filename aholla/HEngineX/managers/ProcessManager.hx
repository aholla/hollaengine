/**
* ...
* @author Adam
*/

package aholla.henginex.managers;
	
import aholla.henginex.core.Camera;
import aholla.henginex.core.entity.IComponent;
import aholla.henginex.core.entity.IEntity;
import aholla.henginex.core.entity.IRendererComponent;
import aholla.henginex.core.entity.IUpdatedComponent;
import aholla.henginex.HE;
import flash.events.Event;
import nme.events.Event;
//import flash.utils.Dictionary;

class ProcessManager
{	
	public var isPaused							:Bool;
	
	private var _inputManager					:InputManager;
	private var _collisionManager				:CollisionManager;		
	private var _renderManager					:RenderManager;
	private var _componentList					:Array<IComponent>;
	private var _updatedComponentList			:Array<IUpdatedComponent>;	
	
	//private var _componentDict					:Dictionary;
	//private var _updatedComponentDict			:Dictionary;
	
	private var componentHash					:Hash<IComponent>;
	
	private var camera							:Camera;	
	private var _sortDepths						:Bool;		
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new(sortDepths:Bool = false) 
	{		
		_sortDepths	= sortDepths;			
		isPaused = true;		
		camera= HE.camera;			
		
		_inputManager 		= new InputManager();
		_collisionManager 	= new CollisionManager();
		_renderManager 		= new RenderManager(_sortDepths);
		
		_componentList 			= [];
		_updatedComponentList 	= [];
		
		componentHash = new Hash();
		
		
		//_componentDict			= new Dictionary(true);
		//_updatedComponentDict	= new Dictionary(true);
		
		HE.world.addEventListener(Event.ENTER_FRAME, onUpdate, false, 0, true);
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/

	/**
	 * Add COMPONENT to the process. Used to pause ALL components.
	 * @param	updatedComponent
	 */
	public function addComponent(component:IComponent):Void
	{
		//TODO; should probably add some checking to see if component already exists.			
		_componentList.push(component);
		//_componentDict[component] = component;
		
		componentHash.set(component.hashID, component);
	}
	
	/**
	 * Remove COMPONENT from the process.
	 * @param	updatedComponent
	 */ 
	public function removeComponent(component:IComponent):Void
	{
		//var index:Int = _componentList.indexOf(component);
		var index:Int = Lambda.indexOf(_componentList, component);
		if (index != -1)
			_componentList.splice(index, 1);
		//delete _updatedComponentDict[component];
	}
	
	/**
	 * Add UPDATED Component to the process.
	 * @param	updatedComponent:IUpdatedComponent
	 */
	public function addUpdatedComponent(updatedComponent:IUpdatedComponent):Void
	{
		//TODO; should probably add some checking to see if component already exists.			
		_updatedComponentList.push(updatedComponent);
		//_updatedComponentDict[updatedComponent] = updatedComponent;
	}	
	
	/**
	 * Remove UPDATED Component from the process.
	 * @param	updatedComponent:IUpdatedComponent
	 */
	public function removeUpdatedComponent(updatedComponent:IUpdatedComponent):Void
	{	
		//var index:Int = _updatedComponentList.indexOf(updatedComponent);
		var index:Int = Lambda.indexOf(_updatedComponentList, updatedComponent);
		if (index != -1)
			_updatedComponentList.splice(index, 1);
		//delete _updatedComponentDict[updatedComponent];
	}		
	
	/**
	 * Add RENDERER to the process.
	 * @param	renderer:IRendererComponent
	 */ 
	public function addRenderer(renderer:IRendererComponent):Void
	{
		_renderManager.addRenderComponent(renderer);
	}
	
	/**
	 * Remove RENDERER from the process.
	 * @param	renderer:IRendererComponent
	 */
	public function removeRenderer(renderer:IRendererComponent):Void
	{
		_renderManager.removeRenderComponent(renderer);
	}
	
	/**
	 * Add COLLSION Component to the process.
	 * @param	entity:IEntity.
	 */
	public function addCollision(entity:IEntity):Void
	{
		_collisionManager.addCollision(entity);
	}	
	
	/**
	 * Remove COLLISION from the process.
	 * @param	entity:IEntity.
	 */
	public function removeCollision(entity:IEntity):Void
	{	
		_collisionManager.removeCollision(entity);
	}		
	
	/**
	 * Calls "start" on all components.
	 */
	public function start():Void
	{
		isPaused = false;
		for (i in 0..._componentList.length) 
		{
			var _component:IComponent = _componentList[i];
			_component.onUnPause();
		}			
	}
	
	/**
	 * Paused all components.
	 */
	public function pause():Void
	{
		isPaused = true;
		for (i in 0..._componentList.length) 
		{
			var _component:IComponent = _componentList[i];
			_component.onPause();
		}			
	}
	
	/**
	 * Unpauses all components.
	 */
	public function unPause():Void
	{
		isPaused = false;
		for (i in 0..._componentList.length)
		{
			var _component:IComponent = _componentList[i];
			_component.onUnPause();
		}			
	}
	
	/**
	 * Forces an update on all components.
	 */
	public function forceUpdate():Void
	{
		if (isPaused)
		{
			isPaused = false;
			onUpdate(null);
			isPaused = true;
		}
		else
		{
			onUpdate(null);
		}
	}
	
	/**
	 * Updates the world size for collision detection.
	 */
	public function updateWorldSize():Void 
	{
		_collisionManager.updateWorldSize();
	}		
	
	/**
	 * Destroys the processmanager.
	 */
	public function destroy():Void 
	{
		isPaused = true;
		
		_inputManager.destroy();
		_inputManager = null;
		
		HE.world.removeEventListener(Event.ENTER_FRAME, onUpdate);			
		
		_collisionManager.destroy();
		_collisionManager = null;			
		
		camera.destroy();
		camera = null;		
		
		_componentList = [];		
		_updatedComponentList = [];
		
		//_componentDict = new Dictionary();
		//_updatedComponentDict = new Dictionary();
		
	}
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/


/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	/**
	 * Updates all the components. First update, then depths, then renders. Then adjustes the quality if required.
	 * @param	e
	 */
	public function onUpdate(e:Event):Void 
	{
		if (!isPaused)
		{	
			for (i in 0..._updatedComponentList.length) 
			{
				var _updatedComponent:IUpdatedComponent = _updatedComponentList[i];
				_updatedComponent.onUpdate();					
			}
			_collisionManager.onUpdate();				
			_renderManager.onUpdate();
			camera.onUpdate();
		}
		_inputManager.update();			
	}
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
	
	
}
