/**
* ...
* @author Adam
* 
* Todo: Fix teh translation bugs when initializing a collider with an offset.
*/

package aholla.hxhengine.core.entity;

import aholla.hxhengine.collision.CollisionInfo;
import aholla.hxhengine.collision.shapes.IShape;
import aholla.hxhengine.core.entity.IComponent;
import aholla.hxhengine.core.entity.ITransformComponent;
import aholla.hxhengine.core.Logger;
import aholla.hxhengine.HE;
import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;
import hxs.Signal;
import hxs.Signal1;
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
	
	public var messageCollision(default, null)		:Signal1<CollisionInfo>;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new(name:String) 
	{		
		this.name = name;
		this.componentHash = new Hash<IComponent>();
		
		transform 	= new TransformComponent();
		addComponent(transform, TRANSFORM);
		
		messageCollision = new Signal1(this);
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
		
		messageCollision.dispatch(new CollisionInfo());	
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
		
		if (messageCollision != null)
		{
			messageCollision.removeAll();
			messageCollision = null;
		}
		
		HE.entityManager.removeEntity(this.name);
	}
	
	/**
	 * @inheritDoc
	 */
	public function onCollision(collisionInfo:CollisionInfo):Void
	{			
		if (isActive && collisionInfo != null)
		{
			messageCollision.dispatch(collisionInfo);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function createRendererAnimated(spritemap:Spritemap = null, isCentered:Bool = true, smoothing:Bool = false, offsetX:Int = 0, offsetY:Int = 0):Void
	{			
		checkForExistingRenderer();
		renderer = new RendererBlitComponent(isCentered, offsetX, offsetY, smoothing);
		if (spritemap != null)
		{
			cast(renderer, RendererBlitComponent).initSpriteMap(spritemap);
		}		
		addComponent(renderer, RENDERER);
	}
	
	/**
	 * @inheritDoc
	 */
	public function createRendererStatic(image:Bitmap = null, isCentered:Bool = true, smoothing:Bool = false, offsetX:Int = 0, offsetY:Int = 0):Void
	{
		checkForExistingRenderer();
		renderer = new RendererBlitComponent(isCentered, offsetX, offsetY, smoothing);		
		addComponent(renderer, RENDERER);
	}
	
	public function createRendererTiledBlitted(levelData:Array<Array<Int>>, tilesheet:Bitmap, tileWidth:Int, tileHeight:Int, offsetX:Int = 0, offsetY:Int = 0):Void
	{
		checkForExistingRenderer();		
		renderer = new TiledRendererComponent();
		cast(renderer, TiledRendererComponent).initTilesheet(levelData, tilesheet.bitmapData, tileWidth, tileHeight, offsetX, offsetY);
		addComponent(renderer, RENDERER);
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
	
	public function toString():String
	{
		return "Entity:" +name +".";
	}
	
}