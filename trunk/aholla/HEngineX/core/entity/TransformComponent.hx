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

class TransformComponent extends Component implements ITransformComponent implements IComponent
{
	private var _x								:Float;
	private var _y								:Float;
	private var _z								:Float;
	private var _width							:Float;
	private var _height							:Float;		
	private var _zIndex							:Float;	
	private var _rotation						:Float;
	private var _scale							:Float;
	private var _scaleX							:Float;
	private var _scaleY							:Float;
	private var _layerIndex						:Float;
	private var _bounds							:Rectangle;
	private var _velocity						:Point;
	private var _acceleration					:Point;
	private var _isDirty						:Bool;
	private var _hasMoved						:Bool;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new()
	{
		_x 				= 0;
		_y 				= 0;
		_z 				= 0;
		_width 			= 0;
		_height 		= 0;
		_zIndex 		= 0;
		_rotation 		= 0;
		_scale 			= 1;
		_scaleX 		= 1;
		_scaleY 		= 1;
		_layerIndex 	= 0;
		_bounds 		= new Rectangle(0, 0, 1, 1);// Give it a rectangle.
		_velocity 		= new Point();
		_acceleration 	= new Point();
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
		_isDirty = checkIfDirty();
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

	public function get x():Float 							{	return _x; }		
	public function set x(value:Float):Void 				
	{	
		if (_x != value)
		{
			_x = value;
			_hasMoved = true;
		}
	}
	
	public function get y():Float 							{	return _y; }		
	public function set y(value:Float):Void 				
	{	
		if (_y != value)
		{
			_y = value; 
			_zIndex = (layerIndex + 1) * _y;
			_hasMoved = true;
		}
	}
	
	public function get z():Float 							{ 	return _z; }		
	public function set z(value:Float):Void 				{	_z = value;		}
	
	public function get zIndex():Float 					{ 	_zIndex = (layerIndex + 1) * _y;	return _zIndex; }		
	public function set zIndex(value:Float):Void 			{	_zIndex = value;		}		
	
	public function get width():Float 						{ return _width; }		
	public function set width(value:Float):Void 			
	{	
		_width = _bounds.width = value;
	}
	
	public function get height():Float 					{	return _height; }		
	public function set height(value:Float):Void 			
	{	
		_height = _bounds.height = value;
	}
	
	public function get rotation():Float 					{	return _rotation; }		
	public function set rotation(value:Float):Void 		
	{	
		_rotation = value;
		_isDirty = checkIfDirty();
		if (owner.collider)	owner.collider.shape.rotation = value;
	}
	
	public function get scale():Float 						
	{	
		_scale = (_scaleX > _scaleY) ? _scaleX: _scaleY;
		return _scale;
	}		
	public function set scale(value:Float):Void 			
	{	
		_scale = _scaleX = _scaleY = value;
		_bounds.width 	= _width * scaleX;
		_bounds.height 	= _height * scaleY;
		_isDirty = checkIfDirty();
		if (owner.collider)	owner.collider.shape.scale = value;
	}	
	
	public function get scaleX():Float 						{	return _scaleX; 	}		
	public function set scaleX(value:Float):Void 			
	{	
		_scaleX = value; 
		_bounds.width 	= _width * scaleX;
		_bounds.height 	= _height * scaleY;
		_isDirty = checkIfDirty();
		if (owner.collider)	owner.collider.shape.scaleX = value;
	}
	
	public function get scaleY():Float 						{	return _scaleY; 	}		
	public function set scaleY(value:Float):Void 			
	{	
		_scaleY = value;
		_bounds.width 	= _width * scaleX;
		_bounds.height 	= _height * scaleY;
		_isDirty = checkIfDirty();
		if (owner.collider)	owner.collider.shape.scaleY = value;
	}
	
	public function get velocity():Point 					{ 	return _velocity; }	
	public function set velocity(value:Point):Void 			{	_velocity = value;}
	
	public function get acceleration():Point 				{ 	return _acceleration; }	
	public function set acceleration(value:Point):Void 		{	_acceleration = value;}	
	
	public function get layerIndex():Float 				{	return _layerIndex;	}		
	public function set layerIndex(value:Float):Void 		{	_layerIndex = value; }	
	
	public function get bounds():Rectangle
	{
		if (owner.collider)
		{
			_bounds.x 		= _x + owner.collider.bounds.x;
			_bounds.y 		= _y + owner.collider.bounds.y;				
		}			
		return _bounds;
	}
	public function set bounds(rect:Rectangle):Void	{	_bounds = rect;	}
	
	public function get hasMoved():Bool 				{	return _hasMoved;	}
	public function set hasMoved(value:Bool):Void 	{	_hasMoved = value;	}
	
	public function get isDirty():Bool 				{	return _isDirty;	}
	public function set isDirty(value:Bool):Void 	{	_isDirty = value;	}
	
	override public function toString():String 
	{
		return "[Component name=" + name + " isActive=" + isActive + " owner= " + owner+ " x=" + x + " y=" + y + " z=" + z + " zIndex=" + zIndex + " width=" + width + " height=" + height + 
					" rotation=" + rotation + " scale=" + scale + " velocity=" + velocity + " acceleration=" + acceleration + "]";
					
	}
	
	

}