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
	import de.polygonal.ds.IntHashTable;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class Entity implements IEntity
	{
		private static const TRANSFORM				:String = "transform";
		private static const RENDERER				:String = "renderer";
		private static const COLLIDER				:String = "collider";
		
		private var _transform						:ITransformComponent;
		private var _collider						:ColliderComponent;	// IColliderComponent - changes for faster access to "collider.bounds";
		private var _renderer						:IRendererComponent;
		private var _id								:int;
		private var _guid							:String;
		private var _name							:String;
		private var _groupName						:String;		
		private var _componentsDict					:Dictionary;
		private var _isActive						:Boolean;
		private var _messageCollision				:Signal = new Signal();
		//private var intHashTable					:IntHashTable;
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function Entity($name:String) 
		{
			_name 		= $name;
			_componentsDict = new Dictionary(true);						
			
			_transform 	= new TransformComponent();
			addComponent(transform, TRANSFORM);
			
			//intHashTable = new IntHashTable();
			
			//intHashTable.set(
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
			if (_componentsDict[$componetName])
			{
				Logger.warn("Entity.addComponent(): Component already exists");
			}
			else
			{			
				$component.onAdded(this, $componetName);
				_componentsDict[$componetName] = $component;	
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeComponent(componentName:String):void
		{
			if (_componentsDict[componentName])
			{
				_componentsDict[componentName].destroy();
				_componentsDict[componentName] = null;
				delete _componentsDict[componentName];
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getComponent($componentName:String):IComponent
		{
			if (!_componentsDict[$componentName])
			{
				Logger.warn("Entity - getComponent: '" + $componentName + "' Component does not exist on '" + name + "'.");
				return null;
			}
			else
			{
				return _componentsDict[$componentName];
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getComponents():Dictionary
		{
			if(_componentsDict)
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
			for (var _compName:String in _componentsDict) 
			{
				_componentsDict[_compName].destroy();
				delete _componentsDict[_compName];
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
		public function createRendererAnimated(isBlitted:Boolean = true, spritemap:Spritemap = null, isCentered:Boolean = true, smoothing:Boolean = false, offsetX:Number = 0, offsetY:Number = 0):void
		{			
			checkForExistingRenderer();
			
			if (isBlitted)
			{
				_renderer = new RendererBlitComponent(isCentered, offsetX, offsetY, smoothing);
				if (spritemap)
					(_renderer as RendererBlitComponent).initSpritemap(spritemap);
			}
			else
			{
				//_renderer = new RendererMovieClipComponent();
			}
			
			addComponent(_renderer, RENDERER);
		}
		
		/**
		 * @inheritDoc
		 */
		public function createRendererStatic(isBlitted:Boolean = true, image:Bitmap = null, isCentered:Boolean = true, smoothing:Boolean = false, offsetX:Number = 0, offsetY:Number = 0):void
		{
			checkForExistingRenderer();
			
			if (isBlitted)
			{
				trace("created a bloitted renderer")
				_renderer = new RendererBlitComponent(isCentered, offsetX, offsetY, smoothing);
			}
			else
			{
				//_renderer = new RendererMovieClipComponent();
			}
			
			//if (image)
			//{
				//_renderer.setGraphic(image);
			//}
			
			addComponent(_renderer, RENDERER);
		}
		
		public function createRendererTiledBlitted(levelData:Array, tilesheet:Bitmap, tileWidth:int, tileHeight:int, offsetX:int = 0, offsetY:int = 0):void
		{
			checkForExistingRenderer();
			
			_renderer = new TiledRendererComponent();
			(_renderer as TiledRendererComponent).initTilesheet(levelData, tilesheet.bitmapData, tileWidth, tileHeight, offsetX, offsetY);
			addComponent(_renderer, RENDERER);
		}
		
		/**
		 * @inheritDoc
		 */
		public function createCollider($shape:IShape, $isCollider:Boolean = true, $offsetX:Number = 0, $offsetY:Number = 0, $collisionGroup:String = null):void
		{
			if (HE.isDebug && !_renderer)
			{
				_renderer = new RendererBlitComponent();				
				var bd:BitmapData = new BitmapData($shape.bounds.width, $shape.bounds.height, true, 0x00000000);
				_renderer.setGraphic(new Bitmap(bd));
				addComponent(_renderer, RENDERER);
			}
			
			if (!$collisionGroup && _groupName)
			{
				$collisionGroup = _groupName;
			}
			
			_collider = new ColliderComponent();
			addComponent(_collider, COLLIDER);
			
			_collider.create($shape, $isCollider, $offsetX, $offsetY, $collisionGroup);			
			HE.processManager.addCollision(this);
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		private function checkForExistingRenderer():void
		{
			if (_renderer)
			{	
				removeComponent(RENDERER);
			}
		}
		
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
		public function get collider():ColliderComponent 		{	return _collider;	}
		
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