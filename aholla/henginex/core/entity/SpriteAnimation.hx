/**
* ...
* @author Adam
*/

package aholla.henginex.core.entity;


class SpriteAnimation 
{
	public var name								:String;
	public var framesArr						:Array<Int>;
	public var frameRate						:Int;
	public var frameCount						:Int;
	public var frameIndex						:Int;
	public var currentFrame						:Int;
	public var isLoop							:Bool;
	public var flipX							:Bool;
	public var flipY							:Bool;
	public var returnCall						:String -> Void;
	public var returnCallFrameIndex				:Int;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
	public function new(name:String, framesArr:Array<Int>, frameRate:Int, isLoop:Bool, flipX:Bool, flipY:Bool, returnCall:String -> Void, returnCallFrameIndex:Int) 
	{
		this.name 		= name;			
		this.framesArr 	= framesArr;
		this.frameRate 	= frameRate;
		this.isLoop 	= isLoop;
		this.flipX		= flipX;
		this.flipY		= flipY;
		this.returnCall	= returnCall;
		this.returnCallFrameIndex = returnCallFrameIndex;
		
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