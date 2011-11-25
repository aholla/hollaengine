/**
* ...
* @author Adam
*/

package aholla.henginex.core;

import aholla.henginex.core.entity.ITransformComponent;
import aholla.henginex.HE;
import flash.geom.Point;
import flash.geom.Rectangle;

class Camera
{
	public var target(default, null)				:ITransformComponent;		
	public var isMoving(default, null)				:Bool;
	public var x									:Float;
	public var y									:Float;
	private var dx									:Float;
	private var dy									:Float;
	private var easing								:Float;
	private var bounds								:Rectangle;
	private var cameraOffset						:Point;
	private var position(getPosition, null)			:Point;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new() 
	{
		x 	= 0.0;
		y 	= 0.0;
		dx 	= 0.0;
		dy 	= 0.0;
		easing = 0.2;
		cameraOffset = new Point();
		position 	 = new Point();
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
	public function onUpdate():Void 
	{
		if (isMoving && target != null)
		{
			dx = target.x - cameraOffset.x - x;
			dy = target.y - cameraOffset.y - y;
			x += dx * easing;
			y += dy * easing;
			if (bounds != null)	checkBounds();
		}
	}
	
	/**
	 * UpdateBounds.
	 * Creates bounds for the camera by checking the screen width against 
	 * the world width and the screen height against the world height.
	 */
	public function updateBounds():Void
	{
		var worldW:Int = HE.WORLD_WIDTH;
		var worldH:Int = HE.WORLD_HEIGHT;
		var screenW:Int = HE.SCREEN_WIDTH;
		var screenH:Int = HE.SCREEN_HEIGHT;
		
		if (worldW > screenW)// World is smaller than the camera
		{
			if (worldH > screenH)
				bounds = new Rectangle(0, 0, worldW - screenW, worldH - screenH);
			else if (worldH <= screenH)
				bounds = new Rectangle(0, 0, worldW - screenW, 0);
		}
		else if (worldW < screenW) // World is smaller than the camera
		{
			if (worldH > screenH)
				bounds = new Rectangle(0, 0, 0, worldH - screenH);
			else if (worldH <= screenH)
				bounds = null;
		}			
	}
	
	public function setPosition(x:Float = 0, y:Float = 0):Void
	{
		x = x - cameraOffset.x;
		y = y - cameraOffset.y;			
		HE.processManager.forceUpdate();
	}
	
	public function setTarget(entityTransformComponent:ITransformComponent, easing:Float = 0.2):Void
	{
		target = entityTransformComponent;	
		this.easing = easing;
		isMoving = true;
	}
	
	public function start():Void 
	{
	}
	
	public function destroy():Void 
	{
		target = null;
	}
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/

	/**
	 * CheckBounds.
	 * If the camera has bounds set, this will limit the camera x & y
	 * when it reaches teh bounds.
	 */
	private function checkBounds():Void
	{			
		if (x < bounds.x)
			x = bounds.x;
		else if (x > bounds.width)
			x = bounds.width;
		
		if (y < bounds.y)
			y = bounds.y;
		else if (y > bounds.height)
			y = bounds.height;	
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
	private function getPosition():Point
	{
		position.x = x;
		position.y = y;
		return position;
	}
	
}
