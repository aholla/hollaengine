/**
 * ...
 * @author Adam
 */

package aholla.henginex.core.entity;

import aholla.henginex.collision.CollisionInfo;


interface IEntity
{	
	/**
	 * "Starts" all the components that have been added;
	 */
	function start():Void;
	
	
	/**
	 * Adds a component to the Enities component list.
	 * @param	component - The component to be added to the entity.
	 * @param	componetName - the name associated with the component (used for accessing it).
	 */		
	function addComponent(component:IComponent, componetName:String):Void;
	
	
	/**
	 * Removes the component from the Entity.
	 * @param	componetName - name of teh component to be removed.
	 */
	function removeComponent(componetName:String):Void;
	
	
	/**
	 * Returns the component.
	 * @param - componentName - name of the component to return.
	 * @return - IComponent.
	 */
	function getComponent(component:String):IComponent;
	
	
	/**
	 * Returns a Dictionary of all the Entities components.
	 * @return - Dictionary.
	 */
	//function getComponents():Dictionary;		
	
	
	/**
	 * Called from the HE.Processmanager when the Enity collided with anotehr Entity.
	 * @param	collisionInfo:CollisionInfo - the information regarding the collision, direction, distance etc...
	 */		
	function onCollision(collisionInfo:CollisionInfo):Void;		
	
	
	
	/**
	 * Destroys the Entities Components and then the Enitity itself.
	 */
	function destroy():Void;
	
	/**
	 * Initializes an animated Renderer. If blitted is true the rendering mode will be blitting, else it will be displayList. May change this method in future.
	 * @param	isBlitted:Bool - Set to true to use blitting and spritesheets. Set to false to use the display list.
	 * @param	spritemap:Spritemap - The spritemap class that contains the blitting info.
	 * @param	isCentered:Bool - If the entities origin is centered, else it will be top left aligned.
	 * @param	smoothing:Bool - If the graphic will be smoothed if manipulated.
	 * @param	offsetX:Float - the distance in pixels the render will be horizontally offset from it's Transform's x.
	 * @param	offsetY:Float - the distance in pixels the render will be vertically offset from it's Transform's y.
	 */
	//function createRendererAnimated(isBlitted:Bool = true, spritemap:Spritemap = null, isCentered:Bool = true, smoothing:Bool = false, offsetX:Float = 0, offsetY:Float = 0):Void
	
	
	/**
	 * Initializes a static Renderer. This will sidplay an static, non-animated bitmap and can be blitted or put on teh display list.
	 * @param	isBlitted:Bool - Set to true to use blitting and spritesheets. Set to false to use the display list.
	 * @param	image:Bitmap - The bitmap used for the renderer.
	 * @param	isCentered:Bool - If the entities origin is centered, else it will be top left aligned.
	 * @param	smoothing:Bool - If the graphic will be smoothed if manipulated.
	 * @param	offsetX:Float - the distance in pixels the render will be horizontally offset from it's Transform's x.
	 * @param	offsetY:Float - the distance in pixels the render will be vertically offset from it's Transform's y.
	 */
	//function createRendererStatic(isBlitted:Bool = true, image:Bitmap = null, isCentered:Bool = true, smoothing:Bool = false, offsetX:Float = 0, offsetY:Float = 0):Void
	
	
	//function createRendererTiledBlitted(levelData:Array, tilesheet:Bitmap, tileWidth:Int, tileHeight:Int, offsetX:Int = 0, offsetY:Int = 0):Void
	/**
	 * Initializes the collider so the component is able for collision detection.
	 * @param	shape:Ishape - The shape used for collision.
	 * @param	isCollider:Bool - if the shape is an "active" collider, it checks against other items.
	 * @param	collisionGroup:String - a group identifier to stop collisions with similar items
	 */
	//function createCollider(shape:IShape, isCollider:Bool = true, offsetX:Float = 0, offsetY:Float = 0, collisionGroup:String = null):Void		
	
	
	
	
	
	//------------------------------------
	// GETTERS/SETTERS
	
	var id:Int;
	var guid:Int;
	var name:String;
	var groupname:String;
	var componentHash:Hash<IComponent>;
	var transform:ITransformComponent;
	var renderer:IRendererComponent;
	var collider:IColliderComponent;
	/**
	 * The entities ID.
	 */
	//function get id():Int;
	
	
	/**
	 * Sets the entities ID.
	 */
	//function set id(id:Int):Void;
	
	/**
	 * The entities GUID.
	 */
	//function get guid():String;
	
	/**
	 * Sets the entities GUID.
	 */
	//function set guid(id:String):Void;
	
	/**
	 * The entities Name, used for accesing an entity via a look up.
	 */
	//function get name():String;
	
	/**
	 * The group name, used for accesing an entity via a look up.
	 */
	//function get groupName():String;
	
	/**
	 * The group name, used for accesing an entity via a look up.
	 */
	//function set groupName(groupName:String):Void;
	
	/**
	 * Returns a Dictionary of all the Entities components.
	 */
	//function get componentsDict():Dictionary;
	
	/**
	 * Message is sent when a collision occurs on an entity. It dispatches a "CollisionInfo" that contains the entities in the collision. 
	 * @param CollisionInfo:CollisionInfo
	 */
	//function get messageCollision():ISignal
	
	/**
	 * If the Entity is "Active".
	 */
	//function get isActive():Bool;
	
	/**
	 * Set if the Entity is "Active".
	 */
	//function set isActive(value:Bool):Void;
	
	/**
	 * The TransformComponet for the entity. This contains all the entities "spatial" properties e.g, position, with, height etc...
	 */
	//function get transform():ITransformComponent;
	
	
	/**
	 * The RendererComponent for the Entity. It contains the visual elements for the Entity.
	 */
	//function get renderer():IRendererComponent;
	
	
	/**
	 * The colliderComponent for the Entity. If set, this is where the "collision" information (shape, bounds) is stored.
	 */
	//function get collider():ColliderComponent;//IColliderComponent;
}	

