package aholla.HEngine.core.entity 
{
	import aholla.HEngine.collision.QuadtreeNode;
	import aholla.HEngine.collision.shapes.IShape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Adam
	 */
	public interface IColliderComponent extends IComponent
	{
		function create($shape:IShape, $isCollider:Boolean = true,  $offsetX:Number = 0, $offsetY:Number = 0, $collisionGroup:String = null):void;
		function render($graphic:Sprite, $colour:uint = 0x0000FF):void;
		
		function get shape():IShape
		function set shape($shape:IShape):void
		
		function get isCollider():Boolean
		function set isCollider($value:Boolean):void
		
		function get colliderGroup():String
		function set colliderGroup($value:String):void
		
		function get offsetX():Number;
		function get offsetY():Number;
		
		/**
		 * The quadtree node the entity is in.
		 */
		function get quadtreeNode():QuadtreeNode;
		function set quadtreeNode($value:QuadtreeNode):void;
		
		
	}
	
}