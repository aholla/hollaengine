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
import de.polygonal.ds.Hashable;
import de.polygonal.ds.HashKey;
import de.polygonal.ds.IntHashTable;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.utils.Dictionary;
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

class Entity implements IEntity, Hashable
{
	private static const TRANSFORM				:String = "transform";
	private static const RENDERER				:String = "renderer";
	private static const COLLIDER				:String = "collider";
	
	private var transform(default, null)			:ITransformComponent;
	private var collider(default, null)				:ColliderComponent;	// IColliderComponent - changes for faster access to "collider.bounds";
	private var renderer(default, null)				:IRendererComponent;
	private var _id									:Int;
	private var _guid								:String;
	private var _name								:String;
	private var _groupName							:String;		
	//private var _componentsDict						:Dictionary;
	private var _isActive							:Bool;
	//private var _messageCollision					:Signal = new Signal();
	//private var IntHashTable						:IntHashTable;
	
	public var key									:Int;
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new(name:String) 
	{
		key = HashKey.next();
		
		_name 		= name;
		//_componentsDict = new Dictionary(true);						
		
		transform 	= new TransformComponent();
		addComponent(transform, TRANSFORM);
		
		//IntHashTable = new IntHashTable();
		
		//IntHashTable.set(
	}		
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	/**
	 * @inheritDoc
	 */
	public function start():Void
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
	public function addComponent(component:IComponent, componetName:String):Void
	{			
		//if (_componentsDict[componetName])
		//{
			//Logger.warn("Entity.addComponent(): Component already exists");
		//}
		//else
		//{			
			//component.onAdded(this, componetName);
			//_componentsDict[componetName] = component;	
		//}
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeComponent(componentName:String):Void
	{
		//if (_componentsDict[componentName])
		//{
			//_componentsDict[componentName].destroy();
			//_componentsDict[componentName] = null;
			//delete _componentsDict[componentName];
		//}
	}
	
	/**
	 * @inheritDoc
	 */
	public function getComponent(componentName:String):IComponent
	{
		//if (!_componentsDict[componentName])
		//{
			//Logger.warn("Entity - getComponent: '" + componentName + "' Component does not exist on '" + name + "'.");
			//return null;
		//}
		//else
		//{
			//return _componentsDict[componentName];
		//}
	}
	
	/**
	 * @inheritDoc
	 */
	public function getComponents():Dictionary
	{
		//if(_componentsDict)
			//return componentsDict;
		//else
		//{
			//Logger.warn("Entity - getAllComponents: componentsDict does not exist");
			//return null;
		//}
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroy():Void
	{		
		//for (var _compName:String in _componentsDict) 
		//{
			//_componentsDict[_compName].destroy();
			//delete _componentsDict[_compName];
		//}
		//
		//_componentsDict = null;
		//_isActive = false;
		//
		//if (_messageCollision)
			//_messageCollision.removeAll();
		//_messageCollision = null;
		//
		//HE.entityManager.removeEntity(this.name);
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
	public function createRendererAnimated(isBlitted:Bool = true, spritemap:Spritemap = null, isCentered:Bool = true, smoothing:Bool = false, offsetX:Float = 0, offsetY:Float = 0):Void
	{			
		//checkForExistingRenderer();
		//
		//if (isBlitted)
		//{
			//renderer = new RendererBlitComponent(isCentered, offsetX, offsetY, smoothing);
			//if (spritemap)
				//(renderer as RendererBlitComponent).initSpritemap(spritemap);
		//}
		//else
		//{
		//	/*renderer = new RendererMovieClipComponent();*/
		//}
		//
		//addComponent(renderer, RENDERER);
	}
	
	/**
	 * @inheritDoc
	 */
	public function createRendererStatic(isBlitted:Bool = true, image:Bitmap = null, isCentered:Bool = true, smoothing:Bool = false, offsetX:Float = 0, offsetY:Float = 0):Void
	//{
		//checkForExistingRenderer();
		//
		//if (isBlitted)
		//{
			//trace("created a bloitted renderer")
			//renderer = new RendererBlitComponent(isCentered, offsetX, offsetY, smoothing);
		//}
		//else
		//{
			// /*renderer = new RendererMovieClipComponent();*/
		//}
		//addComponent(renderer, RENDERER);
	}
	
	public function createRendererTiledBlitted(levelData:Array, tilesheet:Bitmap, tileWidth:Int, tileHeight:Int, offsetX:Int = 0, offsetY:Int = 0):Void
	{
		checkForExistingRenderer();
		
		renderer = new TiledRendererComponent();
		(renderer as TiledRendererComponent).initTilesheet(levelData, tilesheet.bitmapData, tileWidth, tileHeight, offsetX, offsetY);
		addComponent(renderer, RENDERER);
	}
	
	/**
	 * @inheritDoc
	 */
	public function createCollider(shape:IShape, isCollider:Bool = true, offsetX:Float = 0, offsetY:Float = 0, collisionGroup:String = null):Void
	{
		//if (HE.isDebug && !renderer)
		//{
			//renderer = new RendererBlitComponent();				
			//var bd:BitmapData = new BitmapData(shape.bounds.width, shape.bounds.height, true, 0x00000000);
			//renderer.setGraphic(new Bitmap(bd));
			//addComponent(renderer, RENDERER);
		//}
		//
		//if (!collisionGroup && _groupName)
		//{
			//collisionGroup = _groupName;
		//}
		//
		//collider = new ColliderComponent();
		//addComponent(collider, COLLIDER);
		//
		//collider.create(shape, isCollider, offsetX, offsetY, collisionGroup);			
		//HE.processManager.addCollision(this);
	}
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
	
	private function checkForExistingRenderer():Void
	{
		if (renderer)
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