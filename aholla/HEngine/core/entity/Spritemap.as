/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class Spritemap 
	{
		public var data							:BitmapData;
		
		public var cellRect						:Rectangle;
		
		private var spritesheet						:Bitmap;		
		private var currentAnimation				:SpriteAnimation;
		private var animationsDict					:Dictionary;		
		private var width							:int;
		private var height							:int;
		private var columns							:int;
		private var rows							:int;
		private var frameCount						:int;			
		private var isPlaying						:Boolean;
		private var animationTick					:int;
		private var animationFramerate				:int;
		private var cellIndex						:int;		
		private var cellWidth						:int;		
		private var cellHeight						:int;		
		public var dataFlippedX						:BitmapData;
		private var dataFlippedY					:BitmapData;
		private var flippedX						:Boolean;
		private var flippedY						:Boolean;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function Spritemap($spritesheet:Bitmap, $cellWidth:int, $cellHeight:int, $flippedX:Boolean = false, $flippedY:Boolean = false) 
		{
			if (!$spritesheet)	trace(this, "Error, spritesheet supplied is null");
			
			spritesheet = $spritesheet;
			data = $spritesheet.bitmapData;
			
			cellWidth	= $cellWidth;
			cellHeight	= $cellHeight;
			if (!cellWidth)	cellWidth = spritesheet.width;
			if (!cellWidth)	cellWidth = spritesheet.height;			
			cellRect = new Rectangle(0, 0, cellWidth, cellWidth);			
			
			width 		= spritesheet.width;
			height 		= spritesheet.height;			
			columns 	= width / cellRect.width;
			rows 		= height / cellRect.height;	
			
			frameCount 	= columns * rows;			
			animationFramerate = 30;
			
			animationsDict = new Dictionary(true);	
			
			flippedX = $flippedX;
			flippedY = $flippedY;
			if (flippedX || flippedY)
				createFlippedSheet();
		}
		
		private function createFlippedSheet():void 
		{
			var matrix:Matrix = new Matrix();
			var clipRect:Rectangle = new Rectangle(20,20, cellWidth, cellHeight);
			if (flippedX)
			{
				dataFlippedX = new BitmapData(width, height);
				//matrix.a = -1;
				for (var i:int = 0; i < columns; i++) 
				{
					for (var j:int = 0; j < rows; j++) 
					{
						//matrix.translate(i * cellWidth, i * cellHeight);
						matrix.translate(10, 10);
						//dataFlippedX.draw(data, matrix, null, null, clipRect, false);						
						dataFlippedX.draw(data,  matrix, null, null, clipRect);						
						//dataFlippedX.draw(data);						
					}
					
				}
			}
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
				isPlaying = true;
				repositionRect();
			}
		}
		
		public function stop():void 
		{
			isPlaying = false;
			if (currentAnimation)
			{
				currentAnimation.frameIndex = 1;
				repositionRect();
				currentAnimation = null;
				animationTick = 0;
			}			
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
					
					if (currentAnimation.frameIndex == currentAnimation.frameCount+1)
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
			// If the positions are from a "packed" sprite sheet, parse teh cellRect here, else do the standard:
			cellRect.x = int( (currentAnimation.framesArr[currentAnimation.frameIndex-1] -1) % columns) ;		
			cellRect.y = int( (currentAnimation.framesArr[currentAnimation.frameIndex-1] -1) / columns)
			cellRect.x *= cellRect.width;
			cellRect.y *= cellRect.height;
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		
	}

}