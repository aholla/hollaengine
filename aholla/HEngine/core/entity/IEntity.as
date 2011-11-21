/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity
{
	import aholla.HEngine.collision.CollisionInfo;
	import aholla.HEngine.collision.shapes.IShape;
	import aholla.HEngine.core.entity.IComponent;
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import org.osflash.signals.ISignal;
	
	public interface IEntity 
	{	
		/**
		 * "Starts" all the components that have been added;
		 */
		function start():void;
		
		
		/**
		 * Adds a component to the Enities component list.
		 * @param	$component - The component to be added to the entity.
		 * @param	$componetName - the name associated with the component (used for accessing it).
		 */		
		function addComponent($component:IComponent, $componetName:String):void;
		
		
		/**
		 * Removes the component from the Entity.
		 * @param	$componetName - name of teh component to be removed.
		 */
		function removeComponent($componetName:String):void;
		
		
		/**
		 * Returns the component.
		 * @param - $componentName - name of the component to return.
		 * @return - IComponent.
		 */
		function getComponent($component:String):IComponent;
		
		
		/**
		 * Returns a Dictionary of all the Entities components.
		 * @return - Dictionary.
		 */
		function getComponents():Dictionary;		
		
		
		/**
		 * Called from the HE.Processmanager when the Enity collided with anotehr Entity.
		 * @param	$collisionInfo:CollisionInfo - the information regarding the collision, direction, distance etc...
		 */		
		function onCollision($collisionInfo:CollisionInfo):void;		
		
		
		/**
		 * Returns a PropertyReference.
		 * @param	$propertyReference 
		 * @return propertyReference
		 */
		//function getPropertyReference($propertyReference:IPropertyReference):*;
		
		/**
		 * Sets a PropertyReference.
		 * @param	$propertyReference 
		 * @param	$newValue - set the value of the property reference to teh new value. 
		 * @return propertyReference
		 */		
		//function setPropertyReference($propertyReference:IPropertyReference, $newValue:*):void;	
		
		
		/**
		 * Destroys the Entities Components and then the Enitity itself.
		 */
		function destroy():void;
		
		/**
		 * Initializes an animated Renderer. If blitted is true the rendering mode will be blitting, else it will be displayList. May change this method in future.
		 * @param	isBlitted:Boolean - Set to true to use blitting and spritesheets. Set to false to use the display list.
		 * @param	spritemap:Spritemap - The spritemap class that contains the blitting info.
		 * @param	isCentered:Boolean - If the entities origin is centered, else it will be top left aligned.
		 * @param	smoothing:Boolean - If the graphic will be smoothed if manipulated.
		 * @param	offsetX:Number - the distance in pixels the render will be horizontally offset from it's Transform's x.
		 * @param	offsetY:Number - the distance in pixels the render will be vertically offset from it's Transform's y.
		 */
		function createRendererAnimated(isBlitted:Boolean = true, spritemap:Spritemap = null, isCentered:Boolean = true, smoothing:Boolean = false, offsetX:Number = 0, offsetY:Number = 0):void
		
		
		/**
		 * Initializes a static Renderer. This will sidplay an static, non-animated bitmap and can be blitted or put on teh display list.
		 * @param	isBlitted:Boolean - Set to true to use blitting and spritesheets. Set to false to use the display list.
		 * @param	image:Bitmap - The bitmap used for the renderer.
		 * @param	isCentered:Boolean - If the entities origin is centered, else it will be top left aligned.
		 * @param	smoothing:Boolean - If the graphic will be smoothed if manipulated.
		 * @param	offsetX:Number - the distance in pixels the render will be horizontally offset from it's Transform's x.
		 * @param	offsetY:Number - the distance in pixels the render will be vertically offset from it's Transform's y.
		 */
		function createRendererStatic(isBlitted:Boolean = true, image:Bitmap = null, isCentered:Boolean = true, smoothing:Boolean = false, offsetX:Number = 0, offsetY:Number = 0):void
		
		
		function createRendererTiledBlitted(levelData:Array, tilesheet:Bitmap, tileWidth:int, tileHeight:int, offsetX:int = 0, offsetY:int = 0):void
		/**
		 * Initializes the collider so the component is able for collision detection.
		 * @param	$shape:Ishape - The shape used for collision.
		 * @param	$isCollider:Boolean - if the shape is an "active" collider, it checks against other items.
		 * @param	$collisionGroup:String - a group identifier to stop collisions with similar items
		 */
		function createCollider($shape:IShape, $isCollider:Boolean = true, $offsetX:Number = 0, $offsetY:Number = 0, $collisionGroup:String = null):void		
		
		
		
		
		
		//------------------------------------
		// GETTERS/SETTERS
		
		/**
		 * The entities ID.
		 */
		function get id():int;
		
		/**
		 * Sets the entities ID.
		 */
		function set id($id:int):void;
		
		/**
		 * The entities GUID.
		 */
		function get guid():String;
		
		/**
		 * Sets the entities GUID.
		 */
		function set guid($id:String):void;
		
		/**
		 * The entities Name, used for accesing an entity via a look up.
		 */
		function get name():String;
		
		/**
		 * The group name, used for accesing an entity via a look up.
		 */
		function get groupName():String;
		
		/**
		 * The group name, used for accesing an entity via a look up.
		 */
		function set groupName($groupName:String):void;
		
		/**
		 * Returns a Dictionary of all the Entities components.
		 */
		function get componentsDict():Dictionary;
		
		/**
		 * Message is sent when a collision occurs on an entity. It dispatches a "CollisionInfo" that contains the entities in the collision. 
		 * @param $CollisionInfo:CollisionInfo
		 */
		function get messageCollision():ISignal
		
		/**
		 * If the Entity is "Active".
		 */
		function get isActive():Boolean;
		
		/**
		 * Set if the Entity is "Active".
		 */
		function set isActive($value:Boolean):void;
		
		/**
		 * The TransformComponet for the entity. This contains all the entities "spatial" properties e.g, position, with, height etc...
		 */
		function get transform():ITransformComponent;
		
		/**
		 * The RendererComponent for the Entity. It contains the visual elements for the Entity.
		 */
		function get renderer():IRendererComponent;
		
		/**
		 * Change the renderer component. Used when using the Tiled Renderer.
		 */
		//function set renderer($renderer:IRendererComponent):void
		
		/**
		 * The colliderComponent for the Entity. If set, this is where the "collision" information (shape, bounds) is stored.
		 */
		function get collider():ColliderComponent;//IColliderComponent;
	}	
	
}