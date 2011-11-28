
/**
 * ...
 * @author Adam
 */

package aholla.henginex.core.entity;

import aholla.henginex.collision.QuadtreeNode;
import aholla.henginex.collision.shapes.IShape;
import nme.display.Shape;
import nme.display.Sprite;
import nme.geom.Rectangle;

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
	var bounds:Rectangle;	
	
}
	