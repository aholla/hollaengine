/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class Spritemap 
	{
		public var data								:BitmapData;
		public var rect								:Rectangle;
		
		private var animationsDict					:Dictionary;		
		private var spritesheet						:Bitmap;
		
		private var width							:int;
		private var height							:int;
		private var columns							:int;
		private var rows							:int;
		private var frameCount						:int;
		
		private var isPlaying						:Boolean;
		private var animationTick					:int;
		private var animationFramerate				:int;
		private var cellIndex						:int;
		
		private var currentAnimation				:SpriteAnimation;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function Spritemap($spritesheet:Bitmap, $cellWidth:int, $cellHeight:int) 
		{
			spritesheet = $spritesheet;
			
			data = $spritesheet.bitmapData;
			
			rect = new Rectangle(0, 0, $cellWidth, $cellHeight);
			if (!$cellWidth)  	rect.width = spritesheet.width;
			if (!$cellHeight)  	rect.height = spritesheet.height;
			
			width 		= spritesheet.width;
			height 		= spritesheet.height;
			
			columns 	= width / rect.width;
			rows 		= height / rect.height;	
			
			frameCount 	= columns * rows;	
			
			animationFramerate = 30;
			
			animationsDict = new Dictionary(true);	
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function addAnimation($name:String, $framesArr:Array, $frameRate:int = 30, $loop:Boolean = true, $flippedX:Boolean = false, $flippedY:Boolean = false, $callBack:Function = null):void
		{
			if (animationsDict[$name])
			{
				trace("error, animation already exists");
				return;
			}
			animationsDict[$name] = new SpriteAnimation($name, $framesArr, $frameRate, $loop);			
		}
		
		public function play($animationName:String):void
		{
			currentAnimation = animationsDict[$animationName];
			if (currentAnimation)
			{
				repositionRect();
				isPlaying = true;
			}
		}
		
		public function stop():void 
		{
			if (currentAnimation)
			{
				currentAnimation.frameIndex = 1;
				repositionRect();
			}
			isPlaying = false;
		}
		
		public function onUpdate():void 
		{
			if (currentAnimation && isPlaying)
			{
				animationTick++;				
				
				if (animationTick == currentAnimation.frameRate) 
				{
					animationTick = 0;					
					currentAnimation.frameIndex ++;					
					
					if (currentAnimation.frameIndex == currentAnimation.frameCount)
					{
						if (currentAnimation.isLoop)
						{
							currentAnimation.frameIndex = 1;
						}
						else
						{
							//if theres a callball fire here.
							currentAnimation = null;
							return;
						}
					}
					
					repositionRect();
				}
			}
		}
		
		
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		private function repositionRect():void
		{
			rect.x = (int(currentAnimation.framesArr[currentAnimation.frameIndex-1] % columns) * rect.width) - rect.width;		
			rect.y = (int(currentAnimation.framesArr[currentAnimation.frameIndex-1] / columns) * rect.height);
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		
	}

}