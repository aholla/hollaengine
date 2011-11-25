/**
 *
 * @author Adam
 */
package aholla.henginex.core.entity;

import aholla.henginex.collision.QuadtreeNode;
import aholla.henginex.collision.shapes.IShape;
import aholla.henginex.core.entity.IEntity;
import aholla.henginex.HE;
import flash.display.Sprite;
import flash.geom.Rectangle;

class ColliderComponent extends Component implements IColliderComponent
{
	private var _shape							:IShape;
	private var _isCollider						:Bool;
	private var _colliderGroup					:String;
	private var _quadtreeNode					:QuadtreeNode;
	private var _offsetX						:Int;
	private var _offsetY						:Int;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
	public function new() 
	{
		_offsetX = _offsetY = 0;
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/

	override public function onAdded(owner:IEntity, name:String):Void 
	{
		super.onAdded(owner, name);
	}
	
	override public function start():Void 
	{
		setSize();
		super.start();
	}
	
	override public function destroy():Void 
	{
		HE.processManager.removeCollision(this.owner);
		_shape.destroy();
		_shape = null;
		_quadtreeNode = null;	
		super.destroy();
	}
	
	public function create(shape:IShape, isCollider:Bool = true, offsetX:Float = 0, offsetY:Float = 0, colliderGroup:String = null):Void 
	{
		_isCollider 	= isCollider;
		_colliderGroup	= colliderGroup;			
		_shape 			= shape;			
		_shape.translate(offsetX, offsetY);
		_offsetX = offsetX;
		_offsetY = offsetY;
		setSize();
	}
	
	public function render(graphic:Sprite, colour:Uint = 0x00FFFF):Void
	{			
		_shape.render(graphic.graphics, colour);		
	}		
	
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/		
	
	private function setSize():Void
	{
		_shape.rotation = owner.transform.rotation;
		_shape.scale 	= owner.transform.scale;			
		_shape.scaleX 	= owner.transform.scaleX;
		_shape.scaleY 	= owner.transform.scaleY;
		
		owner.transform.width 	= _shape.bounds.width;
		owner.transform.height 	= _shape.bounds.height;	
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/

	public function get bounds():Rectangle					{	return _shape.bounds; }
	public function get shape():IShape						{	return _shape; }		
	public function set shape(shape:IShape):Void 
	{
		_shape 	= shape;
	}
	
	public function get colliderGroup():String 				{ 	return _colliderGroup;}		
	public function set colliderGroup(value:String):Void 	{	_colliderGroup = String(value);	}
	
	public function get isCollider():Bool 				{ 	return _isCollider;	}		
	public function set isCollider(value:Bool):Void 		{ 	_isCollider = value; }
	
	public function get offsetX():Float 					{ 		return _offsetX;	}		
	public function get offsetY():Float					{ 		return _offsetY;	}		
	
	public function get quadtreeNode():QuadtreeNode 			{ return _quadtreeNode;	}
	public function set quadtreeNode(value:QuadtreeNode):Void 	{ _quadtreeNode = value;	}
	
}
