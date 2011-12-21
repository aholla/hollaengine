/**
 *
 * @author Adam
 */
package aholla.hxhengine.core.entity;

import aholla.hxhengine.collision.QuadtreeNode;
import aholla.hxhengine.collision.shapes.IShape;
import aholla.hxhengine.core.entity.IEntity;
import aholla.hxhengine.HE;
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
	public var isCentered(default, null)			:Bool;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
	public function new() 
	{
		super();
		
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
	
	public function create(shape:IShape, isCollider:Bool = true, offsetX:Int = 0, offsetY:Int = 0, colliderGroup:String = null):Void 
	{
		this.shape 			= shape;			
		this.isCollider 	= isCollider;
		this.colliderGroup	= colliderGroup;			
		this.offsetX 		= offsetX;
		this.offsetY 		= offsetY;
		isCentered 			= shape.isCentered;
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
		shape.rotation 	= owner.transform.rotation;
		shape.scale 	= owner.transform.scale;			
		shape.scaleX 	= owner.transform.scaleX;
		shape.scaleY 	= owner.transform.scaleY;
		
		owner.transform.width 	= Std.int(shape.bounds.width);
		owner.transform.height 	= Std.int(shape.bounds.height);	
		
		//trace()
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
