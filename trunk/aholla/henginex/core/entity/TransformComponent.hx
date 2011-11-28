/**
* ...
* @author Adam
* 
* TRANSFORM COMPONENT.
* This is a "data" component that contains all teh relevant date required by an Entity 
* regarding its transform properties, ie size, postition rotation etc...
*
* Other components access and modify these properties so it does not need to "onUpdate".
*/

package aholla.henginex.core.entity;

import aholla.henginex.core.entity.IEntity;
import aholla.henginex.HE;
import flash.geom.Point;
import flash.geom.Rectangle;

//class TransformComponent extends Component, implements ITransformComponent, implements IComponent
class TransformComponent extends Component, implements ITransformComponent
{
	public var x									:Int;
	public var y									:Int;
	public var z									:Int;
	public var width								:Int;
	public var height								:Int;		
	public var zIndex								:Int;	
	public var rotation								:Float;
	public var scale								:Float;
	public var scaleX								:Float;
	public var scaleY								:Float;
	public var layerIndex							:Float;
	public var bounds								:Rectangle;
	public var velocity								:Point;
	public var acceleration							:Point;
	public var isDirty								:Bool;
	public var hasMoved								:Bool;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new()
	{
		super();
		
		x 			= 0;
		y 			= 0;
		z 			= 0;
		width 		= 0;
		height 		= 0;
		zIndex 		= 0;
		rotation 	= 0;
		scale 		= 1;
		scaleX 		= 1;
		scaleY 		= 1;
		layerIndex 	= 0;
		bounds 		= new Rectangle(0, 0, 1, 1);// Give it a rectangle.
		velocity 		= new Point();
		acceleration 	= new Point();
	}
	
// ----------------------------------------------------
// PUBLIC FUNCTIONS
// ----------------------------------------------------
	
	override public function onAdded(owner:IEntity, name:String):Void 
	{
		super.onAdded(owner, name);
	}
	
	override public function start():Void 
	{
		isDirty = checkIfDirty();
		super.start();
	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
	
	public function isOnscreen():Bool
	{
		if (bounds.x > HE.SCREEN_WIDTH + HE.camera.x || bounds.width < 0 || bounds.y > HE.SCREEN_HEIGHT + HE.camera.y || bounds.height < 0)
			return false;
		else
			return true;
	}
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/		
	
	private function checkIfDirty():Bool
	{	
		if (rotation != 0)
			return true;	
		else if (scale != 1)	
			return true;
		else if (scaleX != 1)	
			return true;
		else if (scaleY != 1)	
			return true;
		else
			return false;
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/

	override public function toString():String 
	{
		return "[Component name=" + name + " isActive=" + isActive + " owner= " + owner+ " x=" + x + " y=" + y + " z=" + z + " zIndex=" + zIndex + " width=" + width + " height=" + height + 
					" rotation=" + rotation + " scale=" + scale + " velocity=" + velocity + " acceleration=" + acceleration + "]";
					
	}
	
}