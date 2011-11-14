/**
 * ...
 * @author Adam
 * 
 * Todo: Fix teh translation bugs when initializing a collider with an offset.
 */

package aholla.HEngine.core.entity
{
	import aholla.HEngine.collision.CollisionInfo;
	import aholla.HEngine.collision.shapes.IShape;
	import aholla.HEngine.core.entity.IComponent;
	import aholla.HEngine.core.entity.ITransformComponent;
	import aholla.HEngine.core.Logger;
	import aholla.HEngine.HE;
	import flash.utils.Dictionary;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class Entity implements IEntity
	{
		private var _transform						:ITransformComponent;
		private var _collider						:IColliderComponent;		
		private var _renderer						:IRendererComponent;
		private var _id								:int;
		private var _guid							:String;
		private var _name							:String;
		private var _groupName						:String;		
		private var _componentsDict					:Dictionary;
		private var _isActive						:Boolean;
		private var _messageCollision				:Signal = new Signal();
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function Entity($name:String) 
		{
			_name 		= $name;
			_componentsDict = new Dictionary(true);						
			
			_transform 	= new TransformComponent();
			addComponent(transform, "transform");
		}		
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * @inheritDoc
		 */
		public function start():void
		{
			for each (var component:IComponent in _componentsDict) 
			{
				component.start();
			}
			_isActive = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addComponent($component:IComponent, $componetName:String):void
		{			
			if (componentsDict[$componetName])
			{
				Logger.warn("Entity.addComponent(): Component already exists");
			}
			else
			{			
				$component.onAdded(this, $componetName);
				componentsDict[$componetName] = $component;	
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeComponent($componetName:String):void
		{
			destroy();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getComponent($componentName:String):IComponent
		{
			if (!componentsDict[$componentName])
			{
				Logger.warn("Entity - getComponent: '" + $componentName + "' Component does not exist on '" + name + "'.");
				return null;
			}
			else
			{
				return componentsDict[$componentName];
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getComponents():Dictionary
		{
			if(componentsDict)
				return componentsDict;
			else
			{
				Logger.warn("Entity - getAllComponents: componentsDict does not exist");
				return null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{		
			for (var _compName:String in componentsDict) 
			{
				componentsDict[_compName].destroy();
				delete componentsDict[_compName];
			}
			
			_componentsDict = null;
			_isActive = false;
			
			if (_messageCollision)
				_messageCollision.removeAll();
			_messageCollision = null;
			
			HE.entityManager.removeEntity(this.name);
		}
		
		/**
		 * @inheritDoc
		 */
		public function onCollision($collisionInfo:CollisionInfo):void
		{			
			if (isActive && $collisionInfo)
			{
				_messageCollision.dispatch($collisionInfo);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function initRenderer(isBlitted:Boolean = true, spritemap:Spritemap = null, isCentered:Boolean = true):void
		{			
			if (_renderer)
			{				
				componentsDict["renderer"].destroy();
				componentsDict["renderer"] = null;
				delete componentsDict["renderer"];
			}
			
			if (isBlitted)
			{
				if (!spritemap) Logger.error(this, "The spritemap proveded to 'initRenderer()' is null.");
				_renderer = new RendererBlitComponent();
				(_renderer as RendererBlitComponent).initSpritemap(spritemap, isCentered);
			}
			else
			{
				_renderer = new RendererMovieClipComponent();
			}
				
			addComponent(_renderer, "renderer");
		}
		
		/**
		 * @inheritDoc
		 */
		public function initCollider($shape:IShape, $isCollider:Boolean = true, $offsetX:Number = 0, $offsetY:Number = 0, $collisionGroup:String = null):void
		{
			if (HE.isDebug && !_renderer)
			{
				_renderer = new RendererBlitComponent();
				addComponent(_renderer, "renderer");
			}
			
			if (!$collisionGroup && _groupName)
			{
				$collisionGroup = _groupName;
			}
			
			_collider = new ColliderComponent();
			addComponent(_collider, "collider");
			
			_collider.init($shape, $isCollider, $offsetX, $offsetY, $collisionGroup, transform.scaleX, transform.scaleY);			
			HE.processManager.addCollision(this);
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
		
		public function get id():int							{ 	return _id; }
		public function get guid():String						{ 	return _guid; }
		public function get name():String						{ 	return _name.toLowerCase(); }
		public function get groupName():String					{ 	return _groupName.toLowerCase(); }
		public function get componentsDict():Dictionary			{ 	return _componentsDict; }		
		public function get messageCollision():ISignal 			{ 	return _messageCollision; }		
		public function get isActive():Boolean 					{ 	return _isActive; }
		public function get transform():ITransformComponent 	{	return _transform;	}			
		public function get collider():IColliderComponent 		{	return _collider;	}
		
		public function set isActive($value:Boolean):void		{ 	_isActive = $value; }
		public function set id($id:int):void					{ 	_id = $id; }
		public function set guid($id:String):void				{ 	_guid = $id; }
		public function set groupName($groupName:String):void	{ 	_groupName = $groupName; }
		
		
		public function get renderer():IRendererComponent 		
		{	
			if (!_renderer) Logger.error(this, "renderer is null and needs to be created first.");
			return _renderer;
		}
		
		
		public function toString():String
		{
			return "Entity:" +name +".";
		}
		
	}
}