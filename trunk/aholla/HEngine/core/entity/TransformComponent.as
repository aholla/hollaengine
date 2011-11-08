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
		private var _width							:Number = 0;
		private var _height							:Number = 0;
		private var _x								:Number = 0;
		private var _y								:Number = 0;
		private var _z								:Number = 0;
		private var _bounds							:Rectangle;
		private var _zIndex							:Number = 0;	
		private var _rotation						:Number = 0;
		private var _scale							:Number = 1;
		private var _scaleX							:Number = 1;
		private var _scaleY							:Number = 1;
		private var _layerIndex						:Number = 0;		
		private var _velocity						:Point = new Point();
		private var _acceleration					:Point = new Point();	
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function TransformComponent()
		{
			_bounds = new Rectangle();
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
			if (owner.collider)
			{
				owner.collider.shape.scaleX = _scaleX;
				owner.collider.shape.scaleY = _scaleY;
			}
			super.start();
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/		
		
		
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
				if (owner.collider)
				{
					owner.collider.hasMoved = true
				}
			}
		}
		
		public function get y():Number 							{	return _y; }		
		public function set y(value:Number):void 				
		{	
			if (_y != value)
			{
				_y = value; 
				_zIndex = (layerIndex + 1) * _y;
				if (owner.collider)
				{
					owner.collider.hasMoved = true;
				}
			}
		}
		
		public function get z():Number 							{ 	return _z; }		
		public function set z(value:Number):void 				{	_z = value;		}
		
		public function get zIndex():Number 					{ 	_zIndex = (layerIndex + 1) * _y;	return _zIndex; }		
		//public function get zIndex():Number 					{ 	return _zIndex; }		
		public function set zIndex(value:Number):void 			{	_zIndex = value;		}		
		
		public function get width():Number 						{ return _width; }		
		public function set width(value:Number):void 			{	_width = value;		}
		
		public function get height():Number 					{	return _height; }		
		public function set height(value:Number):void 			{	_height = value;}
		
		public function get rotation():Number 					{	return _rotation; }		
		public function set rotation(value:Number):void 		{	_rotation = value;	}
		
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
			if (owner.collider)
			{
				owner.collider.shape.scale = value;
			}
		}	
		
		public function get scaleX():Number 						{	return _scaleX; 	}		
		public function set scaleX(value:Number):void 			
		{	
			_scaleX = value; 
			_width *= value;
			if (owner.collider)
			{
				owner.collider.shape.scaleX = value;
			}
		}
		
		public function get scaleY():Number 						{	return _scaleY; 	}		
		public function set scaleY(value:Number):void 			
		{	
			_scaleY = value;  _height *= value; 
			if (owner.collider)
			{
				owner.collider.shape.scaleY = value;
			}
		}
		
		public function get velocity():Point 					{ 	return _velocity; }	
		public function set velocity(value:Point):void 			{	_velocity = value;}
		
		public function get acceleration():Point 				{ 	return _acceleration; }	
		public function set acceleration(value:Point):void 		{	_acceleration = value;}	
		
		public function get layerIndex():Number 				{	return _layerIndex;	}		
		public function set layerIndex(value:Number):void 		{	_layerIndex = value; }	
		
		public function get bounds():Rectangle
		{
			if (owner)
			{
				if (owner.collider)
				{
					_bounds.x 		= _x + (owner.collider.offsetX * scaleX);
					_bounds.y 		= _y + (owner.collider.offsetY * scaleY);
					_bounds.width 	= _width * scaleX;
					_bounds.height 	= _height * scaleY;
				}
				else
				{
					_bounds.x 		= _x;
					_bounds.y 		= _y;
					_bounds.width 	= _width * scaleX;
					_bounds.height 	= _height * scaleY;
				}
			}
			return _bounds;
		}
		
		override public function toString():String 
		{
			return "[Component name=" + name + " isActive=" + isActive + " owner= " + owner+ " x=" + x + " y=" + y + " z=" + z + " zIndex=" + zIndex + " width=" + width + " height=" + height + 
						" rotation=" + rotation + " scale=" + scale + " velocity=" + velocity + 
						" acceleration=" + acceleration + "]";
		}
		
		
	}
}