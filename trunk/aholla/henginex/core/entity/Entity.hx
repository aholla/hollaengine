/**
* ...
* @author Adam
* 
* Todo: Fix teh translation bugs when initializing a collider with an offset.
*/

package aholla.henginex.core.entity;

import aholla.henginex.collision.CollisionInfo;
import aholla.henginex.collision.shapes.IShape;
import aholla.henginex.core.entity.IComponent;
import aholla.henginex.core.entity.ITransformComponent;
import aholla.henginex.core.Logger;
import aholla.henginex.HE;
import nme.display.Bitmap;
import nme.display.BitmapData;

class Entity implements IEntity
{
	private inline static var TRANSFORM				:String = "transform";
	private inline static var RENDERER				:String = "renderer";
	private inline static var COLLIDER				:String = "collider";
	
	public var transform(default, null)				:ITransformComponent;
	public var collider(default, null)				:IColliderComponent;	// IColliderComponent - changes for faster access to "collider.bounds";
	public var renderer(default, null)				:IRendererComponent;
	
	public var hashKey(getHashKey, null)			:String;
	public var id									:Int;
	public var guid									:String;
	public var isActive								:Bool;
	public var groupName							:String;
	
	public var name(default, null)					:String;
	public var componentHash(default, null)			:Hash<IComponent>;
	
	//private var _messageCollision					:Signal = new Signal();
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new(name:String) 
	{		
		this.name = name;
		this.componentHash = new Hash<IComponent>();
		
		transform 	= new TransformComponent();
		addComponent(transform, TRANSFORM);
	}		
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	/**
	 * @inheritDoc
	 */
	public function start():Void
	{
		for (component in componentHash)
		{
			component.start();
		}
		isActive = true;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addComponent(component:IComponent, componentName:String):Void
	{			
		var _tempHashKey:String = name + "_" + componentName;
		if (!componentHash.exists(_tempHashKey))
		{
			componentHash.set(_tempHashKey, component);
			component.onAdded(this, componentName);
		}
		else
		{
			Logger.warn("Entity.addComponent(): Component already exists");
		}
		
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeComponent(componentName:String):Void
	{
		var _tempHashKey:String = name + "_" + componentName;
		if (componentHash.exists(_tempHashKey))
		{
			componentHash.get(_tempHashKey).destroy();
			componentHash.remove(_tempHashKey);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function getComponent(componentName:String):IComponent
	{
		var _tempHashKey:String = name + "_" + componentName;
		return componentHash.get(_tempHashKey);
	}
	
	/**
	 * @inheritDoc
	 */
	public function getComponents():Hash<IComponent>
	{
		return componentHash;
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroy():Void
	{		
		for (i in componentHash.keys())
		{
			componentHash.remove(i);
		}
		
		componentHash = null;
		isActive = false;
		
		//if (_messageCollision)
			//_messageCollision.removeAll();
		//_messageCollision = null;
		
		HE.entityManager.removeEntity(this.name);
	}
	
	/**
	 * @inheritDoc
	 */
	public function onCollision(collisionInfo:CollisionInfo):Void
	{			
		//if (isActive && collisionInfo)
		//{
			//_messageCollision.dispatch(collisionInfo);
		//}
	}
	
	/**
	 * @inheritDoc
	 */
	public function createRendererAnimated(isBlitted:Bool = true, spritemap:Spritemap = null, isCentered:Bool = true, smoothing:Bool = false, offsetX:Int = 0, offsetY:Int = 0):Void
	{			
		checkForExistingRenderer();
		
		if (isBlitted)
		{
			renderer = new RendererBlitComponent(isCentered, offsetX, offsetY, smoothing);
			if (spritemap != null)
			{
				//cast(
				//(renderer as RendererBlitComponent).initSpritemap(spritemap);
			}
		}
		else
		{
			/*renderer = new RendererMovieClipComponent();*/
		}
		
		addComponent(renderer, RENDERER);
	}
	
	/**
	 * @inheritDoc
	 */
	public function createRendererStatic(isBlitted:Bool = true, image:Bitmap = null, isCentered:Bool = true, smoothing:Bool = false, offsetX:Int = 0, offsetY:Int = 0):Void
	{
		checkForExistingRenderer();
		
		if (isBlitted)
		{
			renderer = new RendererBlitComponent(isCentered, offsetX, offsetY, smoothing);
		}
		else
		{
			 /*renderer = new RendererMovieClipComponent();*/
		}
		addComponent(renderer, RENDERER);
	}
	
	public function createRendererTiledBlitted(levelData:Array<Int>, tilesheet:Bitmap, tileWidth:Int, tileHeight:Int, offsetX:Int = 0, offsetY:Int = 0):Void
	{
		checkForExistingRenderer();
		
		renderer = new TiledRendererComponent();
		
		trace(Std.is(renderer, TiledRendererComponent));
		//cast(renderer.ini
		//(renderer as TiledRendererComponent).initTilesheet(levelData, tilesheet.bitmapData, tileWidth, tileHeight, offsetX, offsetY);
		//cast(renderer, ITiledRender)..initTilesheet(levelData, tilesheet.bitmapData, tileWidth, tileHeight, offsetX, offsetY);
		
		//cast(
		//addComponent(renderer, RENDERER);
	}
	
	/**
	 * @inheritDoc
	 */
	public function createCollider(shape:IShape, isCollider:Bool = true, offsetX:Int = 0, offsetY:Int = 0, collisionGroup:String = null):Void
	{
		if (HE.isDebug && renderer == null)
		{
			renderer = new RendererBlitComponent();				
			var bd:BitmapData = new BitmapData(Std.int(shape.bounds.width), Std.int(shape.bounds.height), true, 0x00000000);
			renderer.setGraphic(new Bitmap(bd));
			addComponent(renderer, RENDERER);
		}
		
		if (collisionGroup == null && groupName != null)
		{
			collisionGroup = groupName;
		}
		
		collider = new ColliderComponent();
		addComponent(collider, COLLIDER);
		
		collider.create(shape, isCollider, offsetX, offsetY, collisionGroup);			
		HE.processManager.addCollision(this);
	}
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
	
	private function checkForExistingRenderer():Void
	{
		if (renderer != null)
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

	private function getHashKey():String
	{
		return name;
	}
	
/*
	public function get id():Int							{ 	return _id; }
	public function get guid():String						{ 	return _guid; }
	public function get name():String						{ 	return _name.toLowerCase(); }
	public function get groupName():String					{ 	return _groupName.toLowerCase(); }
	public function get componentsDict():Dictionary			{ 	return _componentsDict; }		
	public function get messageCollision():ISignal 			{ 	return _messageCollision; }		
	public function get isActive():Bool 					{ 	return _isActive; }
	public function get transform():ITransformComponent 	{	return transform;	}			
	public function get collider():ColliderComponent 		{	return collider;	}
	
	public function set isActive(value:Bool):Void		{ 	_isActive = value; }
	public function set id(id:Int):Void					{ 	_id = id; }
	public function set guid(id:String):Void				{ 	_guid = id; }
	public function set groupName(groupName:String):Void	{ 	_groupName = groupName; }
	
	
	public function get renderer():IRendererComponent 		
	{	
		if (!renderer) Logger.error(this, "renderer is null and needs to be created first.");
		return renderer;
	}
	
	
	public function toString():String
	{
		return "Entity:" +name +".";
	}
	*/
	
}