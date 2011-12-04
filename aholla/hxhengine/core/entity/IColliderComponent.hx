
/**
 * ...
 * @author Adam
 */

package aholla.hxhengine.core.entity;

import aholla.hxhengine.collision.QuadtreeNode;
import aholla.hxhengine.collision.shapes.IShape;
import nme.display.Shape;
import nme.display.Sprite;
import nme.geom.Rectangle;

interface IColliderComponent implements IComponent
{
	function create(shape:IShape, isCollider:Bool = true,  offsetX:Int = 0, offsetY:Int = 0, collisionGroup:String = null):Void;
	function render(graphic:Sprite, colour:UInt = 0x0000FF):Void;
	
	var shape:IShape;
	var isCollider:Bool;
	var colliderGroup:String;	
	var offsetX(default, null):Int;
	var offsetY(default, null):Int;	
	var quadtreeNode:QuadtreeNode;
	var bounds(getBounds, null):Rectangle;	
	
}
	