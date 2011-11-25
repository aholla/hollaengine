/**
* ...
* @author Adam
*/

package aholla.henginex.core.entity;


class SpriteAnimation 
{
	public var name								:String;
	public var framesArr						:Array;
	public var frameRate						:Int;
	public var frameCount						:Int;
	public var frameIndex						:Int;
	public var currentFrame						:Int;
	public var isLoop							:Bool;
	public var flipX							:Bool;
	public var flipY							:Bool;
	public var callback							:Function;
	public var callbackFrameIndex				:Int;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
	public function new(name:String, framesArr:Array, frameRate:Int, isLoop:Bool, flipX:Bool, flipY:Bool, callback:Function, callbackFrameIndex:Int) 
	{
		name 		= name;			
		framesArr 	= framesArr;
		frameRate 	= frameRate;
		isLoop 		= isLoop;
		flipX		= flipX;
		flipY		= flipY;
		callback	= callback;
		callbackFrameIndex = callbackFrameIndex;
		
		frameIndex		= 1;
		frameCount 		= framesArr.length;
		currentFrame 	= framesArr[frameIndex-1];
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