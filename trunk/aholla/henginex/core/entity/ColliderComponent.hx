/**
 *
 * @author Adam
 */
package aholla.henginex.core.entity;

import aholla.henginex.collision.QuadtreeNode;
import aholla.henginex.collision.shapes.IShape;
import aholla.henginex.core.entity.IEntity;
import aholla.henginex.HE;
import nme.display.Sprite;
import nme.geom.Rectangle;

class ColliderComponent extends Component, implements IColliderComponent
{
	public var bounds(getBounds, null)				:Rectangle;
	public var shape								:IShape;
	public var isCollider							:Bool;
	public var colliderGroup						:String;
	public var quadtreeNode							:QuadtreeNode;
	public var offsetX(default, null)				:Int;
	public var offsetY(default, null)				:Int;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
	public function new() 
	{
		bounds = new Rectangle(0, 0, 1, 1);
		offsetX = offsetY = 0;
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
		shape.destroy();
		shape = null;
		quadtreeNode = null;	
		super.destroy();
	}
	
	public function create(shape:IShape, isCollider:Bool = true, offsetX:Float = 0, offsetY:Float = 0, colliderGroup:String = null):Void 
	{
		this.isCollider 	= isCollider;
		this.colliderGroup	= colliderGroup;			
		this.shape 			= shape;			
		this.offsetX 		= offsetX;
		this.offsetY 		= offsetY;
		shape.translate(offsetX, offsetY);
		setSize();
	}
	
	public function render(graphic:Sprite, colour:UInt = 0x00FFFF):Void
	{			
		shape.render(graphic.graphics, colour);		
	}	
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/		
	
	private function setSize():Void
	{
		shape.rotation = owner.transform.rotation;
		shape.scale 	= owner.transform.scale;			
		shape.scaleX 	= owner.transform.scaleX;
		shape.scaleY 	= owner.transform.scaleY;
		
		owner.transform.width 	= shape.bounds.width;
		owner.transform.height 	= shape.bounds.height;	
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/

	private function getBounds():Rectangle					
	{	
		return shape.bounds; 
	}



	
}
