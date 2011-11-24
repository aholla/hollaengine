/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity 
{
	
	public class SpriteAnimation 
	{
		public var name								:String;
		public var framesArr						:Array;
		public var frameRate						:int;
		public var frameCount						:int;
		public var frameIndex						:int;
		public var currentFrame						:int;
		public var isLoop							:Boolean;
		public var flipX							:Boolean;
		public var flipY							:Boolean;
		public var callback							:Function;
		public var callbackFrameIndex				:int;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function SpriteAnimation($name:String, $framesArr:Array, $frameRate:int, $isLoop:Boolean, $flipX:Boolean, $flipY:Boolean, $callback:Function, $callbackFrameIndex:int) 
		{
			name 		= $name;			
			framesArr 	= $framesArr;
			frameRate 	= $frameRate;
			isLoop 		= $isLoop;
			flipX		= $flipX;
			flipY		= $flipY;
			callback	= $callback;
			callbackFrameIndex = $callbackFrameIndex;
			
			frameIndex		= 1;
			frameCount 		= $framesArr.length;
			currentFrame 	= $framesArr[frameIndex-1];
		}
		
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/			
		

	}

}