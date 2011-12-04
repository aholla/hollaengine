/**
* ...
* @author Adam
*/

package aholla.hxhengine.managers;
	
import aholla.hxhengine.core.Camera;
import aholla.hxhengine.core.entity.IComponent;
import aholla.hxhengine.core.entity.IEntity;
import aholla.hxhengine.core.entity.IRendererComponent;
import aholla.hxhengine.core.entity.IUpdatedComponent;
import aholla.hxhengine.HE;
import flash.events.Event;
import nme.events.Event;
//import flash.utils.Dictionary;

class ProcessManager
{	
	public var isPaused							:Bool;
	
	private var inputManager					:InputManager;
	private var collisionManager				:CollisionManager;		
	private var renderManager					:RenderManager;
	private var componentList					:Array<IComponent>;
	private var updatedComponentList			:Array<IUpdatedComponent>;	
	private var componentHash					:Hash<IComponent>;	
	private var updatedComponentHash			:Hash<IUpdatedComponent>;	
	private var camera							:Camera;	
	private var sortDepths						:Bool;		
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new(sortDepths:Bool = false) 
	{		
		this.sortDepths	= sortDepths;			
		isPaused = true;		
		camera= HE.camera;			
		
		inputManager 		= new InputManager();
		collisionManager 	= new CollisionManager();
		renderManager 		= new RenderManager(sortDepths);
		
		componentHash 		= new Hash<IComponent>();
		updatedComponentHash= new Hash<IUpdatedComponent>();
		
		componentList 			= [];
		updatedComponentList 	= [];		

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
		componentList.push(component);
		componentHash.set(component.hashKey, component);
	}
	
	/**
	 * Remove COMPONENT from the process.
	 * @param	updatedComponent
	 */ 
	public function removeComponent(component:IComponent):Void
	{
		var index:Int = Lambda.indexOf(componentList, component);
		if (index != -1)
			componentList.splice(index, 1);
		componentHash.remove(component.hashKey);
	}
	
	/**
	 * Add UPDATED Component to the process.
	 * @param	updatedComponent:IUpdatedComponent
	 */
	public function addUpdatedComponent(updatedComponent:IUpdatedComponent):Void
	{
		//TODO; should probably add some checking to see if component already exists.			
		updatedComponentList.push(updatedComponent);
		updatedComponentHash.set(updatedComponent.hashKey, updatedComponent);
	}	
	
	/**
	 * Remove UPDATED Component from the process.
	 * @param	updatedComponent:IUpdatedComponent
	 */
	public function removeUpdatedComponent(updatedComponent:IUpdatedComponent):Void
	{	
		var index:Int = Lambda.indexOf(updatedComponentList, updatedComponent);
		if (index != -1)
			updatedComponentList.splice(index, 1);
		updatedComponentHash.remove(updatedComponent.hashKey);
	}		
	
	/**
	 * Add RENDERER to the process.
	 * @param	renderer:IRendererComponent
	 */ 
	public function addRenderer(renderer:IRendererComponent):Void
	{
		renderManager.addRenderComponent(renderer);
	}
	
	/**
	 * Remove RENDERER from the process.
	 * @param	renderer:IRendererComponent
	 */
	public function removeRenderer(renderer:IRendererComponent):Void
	{
		renderManager.removeRenderComponent(renderer);
	}
	
	/**
	 * Add COLLSION Component to the process.
	 * @param	entity:IEntity.
	 */
	public function addCollision(entity:IEntity):Void
	{
		collisionManager.addCollision(entity);
	}	
	
	/**
	 * Remove COLLISION from the process.
	 * @param	entity:IEntity.
	 */
	public function removeCollision(entity:IEntity):Void
	{	
		collisionManager.removeCollision(entity);
	}		
	
	/**
	 * Calls "start" on all components.
	 */
	public function start():Void
	{
		isPaused = false;
		for (i in 0...componentList.length) 
		{
			var _component:IComponent = componentList[i];
			_component.onUnPause();
		}			
	}
	
	/**
	 * Paused all components.
	 */
	public function pause():Void
	{
		isPaused = true;
		for (i in 0...componentList.length) 
		{
			var _component:IComponent = componentList[i];
			_component.onPause();
		}			
	}
	
	/**
	 * Unpauses all components.
	 */
	public function unPause():Void
	{
		isPaused = false;
		for (i in 0...componentList.length)
		{
			var _component:IComponent = componentList[i];
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
		collisionManager.updateWorldSize();
	}		
	
	/**
	 * Destroys the processmanager.
	 */
	public function destroy():Void 
	{
		isPaused = true;
		
		inputManager.destroy();
		inputManager = null;
		
		HE.world.removeEventListener(Event.ENTER_FRAME, onUpdate);			
		
		collisionManager.destroy();
		collisionManager = null;			
		
		camera.destroy();
		camera = null;		
		
		componentList = [];		
		updatedComponentList = [];
		
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
			for (i in 0...updatedComponentList.length) 
			{
				var _updatedComponent:IUpdatedComponent = updatedComponentList[i];
				_updatedComponent.onUpdate();					
			}
			collisionManager.onUpdate();				
			renderManager.onUpdate();
			camera.onUpdate();
		}
		inputManager.update();			
	}
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
	
	
}
