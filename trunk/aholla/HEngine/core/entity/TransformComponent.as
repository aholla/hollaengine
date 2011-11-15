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

package aholla.HEngine.core.entity
{
	import aholla.HEngine.core.entity.IEntity;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class TransformComponent extends Component implements ITransformComponent
	{
		private var _x								:Number;
		private var _y								:Number;
		private var _z								:Number;
		private var _width							:Number;
		private var _height							:Number;		
		private var _zIndex							:Number;	
		private var _rotation						:Number;
		private var _scale							:Number;
		private var _scaleX							:Number;
		private var _scaleY							:Number;
		private var _layerIndex						:Number;
		private var _bounds							:Rectangle;
		private var _velocity						:Point;
		private var _acceleration					:Point;
		private var _isDirty						:Boolean;
		private var _hasMoved						:Boolean;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function TransformComponent()
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
			_bounds 		= new Rectangle();
			_velocity 		= new Point();
			_acceleration 	= new Point();
		}
		
// ----------------------------------------------------
// PUBLIC FUNCTIONS
// ----------------------------------------------------
		
		override public function onAdded($owner:IEntity, $name:String):void 
		{
			super.onAdded($owner, $name);
		}
		
		override public function start():void 
		{
			_isDirty = checkIfDirty();
			super.start();
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/		
		
		private function checkIfDirty():Boolean
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

		public function get x():Number 							{	return _x; }		
		public function set x(value:Number):void 				
		{	
			if (_x != value)
			{
				_x = value;
				_hasMoved = true;
			}
		}
		
		public function get y():Number 							{	return _y; }		
		public function set y(value:Number):void 				
		{	
			if (_y != value)
			{
				_y = value; 
				_zIndex = (layerIndex + 1) * _y;
				_hasMoved = true;
			}
		}
		
		public function get z():Number 							{ 	return _z; }		
		public function set z(value:Number):void 				{	_z = value;		}
		
		public function get zIndex():Number 					{ 	_zIndex = (layerIndex + 1) * _y;	return _zIndex; }		
		public function set zIndex(value:Number):void 			{	_zIndex = value;		}		
		
		public function get width():Number 						{ return _width; }		
		public function set width(value:Number):void 			
		{	
			_width = value;
			_bounds.width = _width;
		}
		
		public function get height():Number 					{	return _height; }		
		public function set height(value:Number):void 			
		{	
			_height = value;
			_bounds.height = _height;
		}
		
		public function get rotation():Number 					{	return _rotation; }		
		public function set rotation(value:Number):void 		
		{	
			_rotation = value;
			_isDirty = checkIfDirty();
		}
		
		public function get scale():Number 						
		{	
			_scale = (_scaleX > _scaleY) ? _scaleX: _scaleY;
			return _scale;
		}		
		public function set scale(value:Number):void 			
		{	
			_scale = _scaleX = _scaleY = value; 
			_width *= value; 
			_height *= value; 
			_bounds.height = _height;
			if (owner.collider)	owner.collider.shape.scale = value;
			_isDirty = checkIfDirty();
		}	
		
		public function get scaleX():Number 						{	return _scaleX; 	}		
		public function set scaleX(value:Number):void 			
		{	
			_scaleX = value; 
			_width *= value;
			_bounds.height = _width;
			if (owner.collider)	owner.collider.shape.scaleX = value;
			_isDirty = checkIfDirty();
		}
		
		public function get scaleY():Number 						{	return _scaleY; 	}		
		public function set scaleY(value:Number):void 			
		{	
			_scaleY = value;  _height *= value; 
			if (owner.collider)	owner.collider.shape.scaleY = value;
			_isDirty = checkIfDirty();
		}
		
		public function get velocity():Point 					{ 	return _velocity; }	
		public function set velocity(value:Point):void 			{	_velocity = value;}
		
		public function get acceleration():Point 				{ 	return _acceleration; }	
		public function set acceleration(value:Point):void 		{	_acceleration = value;}	
		
		public function get layerIndex():Number 				{	return _layerIndex;	}		
		public function set layerIndex(value:Number):void 		{	_layerIndex = value; }	
		
		public function get bounds():Rectangle
		{
			if (owner.collider)
			{
				_bounds.x 		= _x + owner.collider.bounds.x;
				_bounds.y 		= _y + owner.collider.bounds.y;				
			}
			return _bounds;
		}
		public function set bounds($rect:Rectangle):void	{	_bounds = $rect;	}
		
		public function get hasMoved():Boolean 				{	return _hasMoved;	}
		public function set hasMoved(value:Boolean):void 	{	_hasMoved = value;	}
		
		public function get isDirty():Boolean 				{	return _isDirty;	}
		public function set isDirty(value:Boolean):void 	{	_isDirty = value;	}
		
		override public function toString():String 
		{
			return "[Component name=" + name + " isActive=" + isActive + " owner= " + owner+ " x=" + x + " y=" + y + " z=" + z + " zIndex=" + zIndex + " width=" + width + " height=" + height + 
						" rotation=" + rotation + " scale=" + scale + " velocity=" + velocity + " acceleration=" + acceleration + "]";
						
		}
		
		
	}
}