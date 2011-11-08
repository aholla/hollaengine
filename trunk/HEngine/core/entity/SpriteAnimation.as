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
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function SpriteAnimation($name:String, $framesArr:Array, $frameRate:int, $isLoop:Boolean) 
		{
			name 		= $name;			
			framesArr 	= $framesArr;
			frameRate 	= $frameRate;
			isLoop 		= $isLoop;
			
			frameIndex		= 1;
			frameCount 		= $framesArr.length+1;
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