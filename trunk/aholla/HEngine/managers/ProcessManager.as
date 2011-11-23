/**
 * ...
 * @author Adam
 */

package aholla.HEngine.managers
{	
	import aholla.HEngine.core.Camera;
	import aholla.HEngine.core.entity.IComponent;
	import aholla.HEngine.core.entity.IEntity;
	import aholla.HEngine.core.entity.IRendererComponent;
	import aholla.HEngine.core.entity.IUpdatedComponent;
	import aholla.HEngine.HE;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class ProcessManager
	{	
		private var _inputManager					:InputManager;
		private var _collisionManager				:CollisionManager;		
		private var _renderManager					:RenderManager;
		private var _componentList					:Vector.<IComponent>;
		private var _updatedComponentList			:Vector.<IUpdatedComponent>;		
		private var _componentDict					:Dictionary;
		private var _updatedComponentDict			:Dictionary;		
		private var camera							:Camera;
		private var _isPaused						:Boolean;
		private var _sortDepths						:Boolean;		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function ProcessManager($sortDepths:Boolean = false) 
		{		
			_sortDepths	= $sortDepths;			
			isPaused = true;		
			camera= HE.camera;			
			
			_inputManager 		= new InputManager();
			_collisionManager 	= new CollisionManager();
			_renderManager 		= new RenderManager(_sortDepths);
			
			_componentList 			= new Vector.<IComponent>;
			_updatedComponentList 	= new Vector.<IUpdatedComponent>;
			
			_componentDict			= new Dictionary(true);
			_updatedComponentDict	= new Dictionary(true);
			
			HE.world.addEventListener(Event.ENTER_FRAME, onUpdate, false, 0, true);
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/

		/**
		 * Add COMPONENT to the process. Used to pause ALL components.
		 * @param	$updatedComponent
		 */
		public function addComponent($component:IComponent):void
		{
			//TODO; should probably add some checking to see if component already exists.			
			_componentList.push($component);
			_componentDict[$component] = $component;
		}
		
		/**
		 * Remove COMPONENT from the process.
		 * @param	$updatedComponent
		 */ 
		public function removeComponent($component:IComponent):void
		{
			var index:int = _componentList.indexOf($component);
			if (index != -1)
				_componentList.splice(index, 1);
			delete _updatedComponentDict[$component];
		}
		
		/**
		 * Add UPDATED Component to the process.
		 * @param	$updatedComponent:IUpdatedComponent
		 */
		public function addUpdatedComponent($updatedComponent:IUpdatedComponent):void
		{
			//TODO; should probably add some checking to see if component already exists.			
			_updatedComponentList.push($updatedComponent);
			_updatedComponentDict[$updatedComponent] = $updatedComponent;
		}	
		
		/**
		 * Remove UPDATED Component from the process.
		 * @param	$updatedComponent:IUpdatedComponent
		 */
		public function removeUpdatedComponent($updatedComponent:IUpdatedComponent):void
		{	
			var index:int = _updatedComponentList.indexOf($updatedComponent);
			if (index != -1)
				_updatedComponentList.splice(index, 1);
			delete _updatedComponentDict[$updatedComponent];
		}		
		
		/**
		 * Add RENDERER to the process.
		 * @param	$renderer:IRendererComponent
		 */ 
		public function addRenderer($renderer:IRendererComponent):void
		{
			_renderManager.addRenderComponent($renderer);
		}
		
		/**
		 * Remove RENDERER from the process.
		 * @param	$renderer:IRendererComponent
		 */
		public function removeRenderer($renderer:IRendererComponent):void
		{
			_renderManager.removeRenderComponent($renderer);
		}
		
		/**
		 * Add COLLSION Component to the process.
		 * @param	$entity:IEntity.
		 */
		public function addCollision($entity:IEntity):void
		{
			_collisionManager.addCollision($entity);
		}	
		
		/**
		 * Remove COLLISION from the process.
		 * @param	$entity:IEntity.
		 */
		public function removeCollision($entity:IEntity):void
		{	
			_collisionManager.removeCollision($entity);
		}		
		
		/**
		 * Calls "start" on all components.
		 */
		public function start():void
		{
			isPaused = false;			
			var len:int = _componentList.length;
			for (var i:int = 0; i < len; i++) 
			{
				var _component:IComponent = _componentList[i] as IComponent;
				_component.onUnPause();
			}			
		}
		
		/**
		 * Paused all components.
		 */
		public function pause():void
		{
			isPaused = true;
			var len:int = _componentList.length;
			for (var i:int = 0; i < len; i++) 
			{
				var _component:IComponent = _componentList[i] as IComponent;
				_component.onPause();
			}			
		}
		
		/**
		 * Unpauses all components.
		 */
		public function unPause():void
		{
			isPaused = false;
			var len:int = _componentList.length;
			for (var i:int = 0; i < len; i++) 
			{
				var _component:IComponent = _componentList[i] as IComponent;
				_component.onUnPause();
			}			
		}
		
		/**
		 * Forces an update on all components.
		 */
		public function forceUpdate():void
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
		public function updateWorldSize():void 
		{
			_collisionManager.updateWorldSize();
		}		
		
		/**
		 * Destroys the processmanager.
		 */
		public function destroy():void 
		{
			isPaused = true;
			
			_inputManager.destroy();
			_inputManager = null;
			
			HE.world.removeEventListener(Event.ENTER_FRAME, onUpdate);			
			
			_collisionManager.destroy();
			_collisionManager = null;			
			
			camera.destroy();
			camera = null;		
			
			_componentList = new Vector.<IComponent>;			
			_updatedComponentList	= new Vector.<IComponent>;
			
			_componentDict = new Dictionary();
			_updatedComponentDict = new Dictionary();
			
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
		public function onUpdate(e:Event):void 
		{
			if (!isPaused)
			{	
				var len:int = _updatedComponentList.length;
				for (var i:int = 0; i < len; i++) 
				{
					var _updatedComponent:IUpdatedComponent = _updatedComponentList[i] as IUpdatedComponent;
					_updatedComponent.onUpdate();					
				}
				//_collisionManager.onUpdate();				
				_renderManager.onUpdate();
				camera.onUpdate();
			}
			_inputManager.update();			
		}
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		public function get isPaused():Boolean { return _isPaused; }		
		public function set isPaused(value:Boolean):void 
		{
			_isPaused = value;
		}		
		//public function get collisionManager():CollisionManager 				{	return _collisionManager;	}
		
		
	}
}