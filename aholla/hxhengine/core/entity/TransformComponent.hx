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

package aholla.hxhengine.core.entity;

import aholla.hxhengine.core.entity.IEntity;
import aholla.hxhengine.HE;
import flash.geom.Point;
import flash.geom.Point;
import flash.geom.Rectangle;


class TransformComponent extends Component, implements ITransformComponent
{
	public var x(default, setX)						:Int;
	public var y(default, setY)						:Int;
	public var z									:Int;
	public var width(getWidth, setWidth)				:Int;
	public var height(getHeight, setHeight)			:Int;		
	public var zIndex								:Int;	
	public var rotation(getRotation, setRotation)		:Float;
	public var scale(getScale, setScale)			:Float;
	public var scaleX(getScaleX, setScaleX)			:Float;
	public var scaleY(getScaleY, setScaleY)			:Float;
	public var layerIndex							:Float;
	public var bounds(getBounds, null)				:Rectangle;
	public var velocity								:Point;
	public var acceleration							:Point;
	public var isDirty								:Bool;
	public var hasMoved								:Bool;
	
	private var _bounds								:Rectangle;
	private var _width								:Int;
	private var _height								:Int;
	private var _scale								:Float;
	private var _scaleX								:Float;
	private var _scaleY								:Float;
	private var _rotation							:Float;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new()
	{
		super();
		_bounds 	= new Rectangle(0, 0, 10, 10);// Give it a rectangle.
		x 			= 0;
		y 			= 0;
		z 			= 0;
		_width 		= 10;
		_height 	= 10;
		zIndex 		= 0;
		_rotation 	= 0;
		_scale 		= 1;
		_scaleX 	= 1;
		_scaleY 	= 1;		
		layerIndex 	= 0;
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
		if (_bounds.x > HE.SCREEN_WIDTH + HE.camera.x || _bounds.width < 0 || _bounds.y > HE.SCREEN_HEIGHT + HE.camera.y || _bounds.height < 0)
			return false;
		else
			return true;
	}
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/		
	
	private function checkIfDirty():Bool
	{	
		if (_rotation != 0)
			return true;	
		else if (_scale != 1)	
			return true;
		else if (_scaleX != 1)	
			return true;
		else if (_scaleY != 1)	
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

	private function setX(value:Int):Int
	{
		hasMoved = true;
		return x = value;
	}
	
	private function setY(value:Int):Int
	{
		hasMoved = true;
		return y = value;
	}
	
	private function getWidth():Int
	{
		return _width;
	}
	private function setWidth(value:Int):Int 			
	{	
		_bounds.width = value;
		_width = value;
		return _width = value;
		
	}
	
	private function getHeight():Int
	{
		return _height;
	}
	private function setHeight(value:Int):Int 			
	{	
		_bounds.height = value;
		return _height = value;
	}
	
	private function getRotation():Float
	{
		return _rotation;
	}
	private function setRotation(value:Float):Float 		
	{	
		_rotation = value;
		isDirty = checkIfDirty();
		if (owner.collider != null)	owner.collider.shape.rotation = value;
		return _rotation;
	}
	
	private function getScale():Float 						
	{	
		return _scale = (_scaleX > _scaleY) ? _scaleX: _scaleY;
	}	
	private function setScale(value:Float):Float 			
	{	
		_scaleX = value;
		_scaleY = value;
		_scale = value;
		_bounds.width 	= _width * _scaleX;
		_bounds.height 	= _height * _scaleY;
		isDirty = checkIfDirty();
		if (owner.collider != null)	owner.collider.shape.scale = value;
		return _scale;
	}	

	private function getScaleX():Float
	{
		return _scaleX;
	}	
	private function setScaleX(value:Float):Float 			
	{	
		_scaleX = value; 
		_bounds.width 	= _width * _scaleX;
		isDirty = checkIfDirty();
		if (owner.collider != null)	owner.collider.shape.scaleX = value;
		return _scaleX;
	}
	
	private function getScaleY():Float
	{
		return _scaleY;
	}
	private function setScaleY(value:Float):Float 			
	{	
		_scaleY = value;
		_bounds.height 	= _height * _scaleY;
		isDirty = checkIfDirty();
		if (owner.collider != null)	owner.collider.shape.scaleY = value;
		return _scaleY;
	}
		
	private function getBounds():Rectangle
	{
		if (owner.collider != null)
		{
			_bounds.x 		= x + owner.collider.bounds.x;
			_bounds.y 		= y + owner.collider.bounds.y;				
		}			
		return _bounds;
	}
	
	override public function toString():String 
	{
		return "[Component name=" + name + " isActive=" + isActive + " owner= " + owner+ " x=" + x + " y=" + y + " z=" + z + " zIndex=" + zIndex + " width=" + width + " height=" + height + 
					" rotation=" + rotation + " scale=" + scale + " velocity=" + velocity + " acceleration=" + acceleration + "]";
					
	}
	
}