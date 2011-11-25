
/**
 * ...
 * @author Adam
 */

package aholla.henginex.core.entity;

import aholla.henginex.collision.QuadtreeNode;
import aholla.henginex.collision.shapes.IShape;
import nme.display.Shape;
import nme.display.Sprite;

interface IColliderComponent implements IComponent
{
	function create(shape:IShape, isCollider:Bool = true,  offsetX:Float = 0, offsetY:Float = 0, collisionGroup:String = null):Void;
	function render(graphic:Sprite, colour:UInt = 0x0000FF):Void;
	
	var shape:IShape;
	var isCollider:Bool;
	var colliderGroup:String;	
	var offsetX:Float;
	var offsetY:Float;	
	var quadtreeNode:QuadtreeNode;
	
	//function get shape():IShape
	//function set shape(shape:IShape):Void
	//
	//function get isCollider():Bool
	//function set isCollider(value:Bool):Void
	//
	//function get colliderGroup():String
	//function set colliderGroup(value:String):Void
	//
	//function get offsetX():Float;
	//function get offsetY():Float;
	
	/**
	 * The quadtree node the entity is in.
	 */
	//function get quadtreeNode():QuadtreeNode;
	//function set quadtreeNode(value:QuadtreeNode):Void;
	
	
}
	