/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core 
{
	
	import aholla.HEngine.core.entity.ITransformComponent;
	import aholla.HEngine.HE;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Camera
	{
		private var _target							:ITransformComponent;		
		private var _isMoving						:Boolean;
		private var _x								:int;
		private var _y								:int;
		private var _dx								:int;
		private var _dy								:int;
		private var _easing							:Number;
		private var _bounds							:Rectangle;
		private var cameraOffset					:Point;
		private var _position						:Point;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function Camera() 
		{
			_x = 0;
			_y = 0;
			_dx = 0;
			_dy = 0;
			_easing = 0.2;
			cameraOffset = new Point();
			_position 	 = new Point();
			cameraOffset.x = HE.SCREEN_WIDTH * 0.5;
			cameraOffset.y = HE.SCREEN_HEIGHT * 0.5;			
			updateBounds();
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * If the camera has a target, it's x & y are set to this with easing.
		 */
		public function onUpdate():void 
		{
			if (_isMoving && _target)
			{
				_dx = target.x - cameraOffset.x - _x;
				_dy = target.y - cameraOffset.y - _y;
				_x += _dx * _easing;
				_y += _dy * _easing;
				if (_bounds)	checkBounds();
			}
		}
		
		/**
		 * UpdateBounds.
		 * Creates bounds for the camera by checking the screen width against 
		 * the world width and the screen height against the world height.
		 */
		public function updateBounds():void
		{
			var worldW:int = HE.WORLD_WIDTH;
			var worldH:int = HE.WORLD_HEIGHT;
			var screenW:int = HE.SCREEN_WIDTH;
			var screenH:int = HE.SCREEN_HEIGHT;
			
			if (worldW > screenW)// World is smaller than the camera
			{
				if (worldH > screenH)
					_bounds = new Rectangle(0, 0, worldW - screenW, worldH - screenH);
				else if (worldH <= screenH)
					_bounds = new Rectangle(0, 0, worldW - screenW, 0);
			}
			else if (worldW < screenW) // World is smaller than the camera
			{
				if (worldH > screenH)
					_bounds = new Rectangle(0, 0, 0, worldH - screenH);
				else if (worldH <= screenH)
					_bounds = null;
			}			
		}
		
		public function setPosition($x:Number = 0, $y:Number = 0):void
		{
			_x = $x - cameraOffset.x;
			_y = $y - cameraOffset.y;			
			HE.processManager.forceUpdate();
		}
		
		public function setTarget(entityTransformComponent:ITransformComponent, $easing:Number = 0.2):void
		{
			_target = entityTransformComponent;	
			_easing = $easing;
			_isMoving = true;
		}
		
		public function start():void 
		{
		}
		
		public function destroy():void 
		{
			_target = null;
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/

		/**
		 * CheckBounds.
		 * If the camera has bounds set, this will limit the camera x & y
		 * when it reaches teh bounds.
		 */
		private function checkBounds():void
		{			
			if (_x < _bounds.x)
				_x = _bounds.x;
			else if (_x > _bounds.width)
				_x = _bounds.width;
			
			if (_y < _bounds.y)
				_y = _bounds.y;
			else if (_y > _bounds.height)
				_y = _bounds.height;	
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		public function get target():ITransformComponent 			{ return _target; }	
		
		/**
		 * Set the Camera target to an Entities "transform". It will then track the target.
		 * @param value:ITransformComponent - the Transform component of teh entity e.g. HE.camera.target = entityA.transform;
		 */
		//public function set target(value:ITransformComponent):void 	{_target = value;	_isMoving = true;	}
		
		public function get isMoving():Boolean 		{ return _isMoving; }			
		public function get x():Number 				{ return _x; }			
		public function get y():Number 				{ return _y; }	
		
		public function get offsetX():Number 		{ return cameraOffset.x; }	
		public function get offsetY():Number 		{ return cameraOffset.y; }	
		public function set offsetX($value:Number):void		{ cameraOffset.x += $value; }	
		public function set offsetY($value:Number):void		{ cameraOffset.y += $value; }		
		
		public function set easing($value:Number):void	{ _easing = $value; }
		
		public function get position():Point			
		{
			if (_position)
			{
				_position.x = _x;
				_position.y = _y;
				return _position;
			}
			else
			{
				return null;
			}
		}
		
	}
}