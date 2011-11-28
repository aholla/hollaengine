/**
* ...
* @author Adam
*/

package aholla.henginex.core.entity;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;


class Spritemap 
{
	public var data								:BitmapData;		
	public var cellRect							:Rectangle;
	
	private var entity							:IEntity;
	private var dataOrigional					:BitmapData;
	private var dataFlipped						:BitmapData;
	private var spritesheet						:Bitmap;		
	private var currentAnimation				:SpriteAnimation;
	//private var animationsDict					:Dictionary;		
	private var width							:Int;
	private var height							:Int;
	private var columns							:Int;
	private var rows							:Int;
	private var frameCount						:Int;			
	private var isPlaying						:Bool;
	private var animationTick					:Int;
	private var animationFramerate				:Int;
	private var cellIndex						:Int;		
	private var cellWidth						:Int;		
	private var cellHeight						:Int;		
	private var flipX							:Bool;
	private var flipY							:Bool;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
	public function new(entity:IEntity, spritesheet:Bitmap, cellWidth:Int, cellHeight:Int, flipX:Bool = false, flipY:Bool = false) 
	{
		//this.entity = entity;
		//if (spritesheet == null)	trace(this, "Error, spritesheet supplied is null");
		//
		//this.spritesheet = spritesheet;			
		//
		//this.cellWidth	= cellWidth;
		//this.cellHeight	= cellHeight;
		//
		//if (cellWidth == null)	cellWidth = Std.int(spritesheet.width);
		//if (cellWidth == null)	cellWidth = Std.int(spritesheet.height);			
		//cellRect = new Rectangle(0, 0, cellWidth, cellWidth);			
		//
		//width 		= Std.int(spritesheet.width);
		//height 		= Std.int(spritesheet.height);			
		//columns 	= Std.int(width / cellRect.width);
		//rows 		= Std.int(height / cellRect.height);	
		//
		//frameCount 	= columns * rows;			
		//animationFramerate = 30;
		//
		//data = new BitmapData(spritesheet.bitmapData.width, spritesheet.bitmapData.height, true, 0x00000000);
		//dataOrigional = data = spritesheet.bitmapData;	
		//
		//animationsDict = new Dictionary(true);	
		//
		//flipX = flipX;
		//flipY = flipY;
		//if (flipX || flipY)
			//createFlippedSheet();
	}		
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	public function addAnimation(name:String, framesArr:Array<Int>, frameRate:Int = 30, loop:Bool = true, flipX:Bool = false, flipY:Bool = false, returnCall:String -> Void = null, returnCallFrameIndex:Int = 0):Void
	{
		//if (animationsDict[name])
		//{
			//trace("error, animation already exists");
			//return;
		//}
		//animationsDict[name] = new SpriteAnimation(name, framesArr, frameRate, loop, flipX, flipY, returnCall, returnCallFrameIndex);			
	}
	
	public function play(animationName:String):Void
	{
		//currentAnimation = animationsDict[animationName];
		//if (currentAnimation)
		//{
			//isPlaying = true;
			//if (currentAnimation.flipX || currentAnimation.flipY)
			//{
				// quick check to see if it has been set up correctly and if not, set it up.
				//if (!dataFlipped)
				//{
					//if (flipX != currentAnimation.flipX)	flipX = currentAnimation.flipX;						
					//if (flipY != currentAnimation.flipY)	flipY = currentAnimation.flipY;
					//createFlippedSheet();
				//}
				//data = dataFlipped;
			//}
			//else
				//data = dataOrigional;
			//repositionRect();
		//}
	}
	
	public function stop():Void 
	{
		//isPlaying = false;
		//if (currentAnimation)
		//{
			//currentAnimation.frameIndex = 1;
			//repositionRect();
			//currentAnimation = null;
			//animationTick = 0;
		//}			
	}
	
	public function onUpdate():Void
	{
		//if (isPlaying && currentAnimation)
		//{
			//animationTick++;				
			//
			//if (animationTick == currentAnimation.frameRate) 
			//{
				//animationTick = 0;	
				//currentAnimation.frameIndex ++;
				//
				// check for returnCall
				//if (currentAnimation.returnCallFrameIndex != 0 && currentAnimation.returnCallFrameIndex == currentAnimation.frameIndex)
				//{
					//doCallback(currentAnimation.returnCall);						
				//}
				//
				// reset
				//if (currentAnimation.frameIndex == currentAnimation.frameCount+1)
				//{
					//if (currentAnimation.returnCall != null && currentAnimation.returnCallFrameIndex == 0)
					//{
						//doCallback(currentAnimation.returnCall);	
					//}
					//
					//if (currentAnimation.isLoop)
					//{
						//currentAnimation.frameIndex = 1;
					//}
					//else
					//{
						//currentAnimation = null;
						//return;
					//}
				//}					
				//repositionRect();
			//}
		//}
	}		
	
	public function destroy():Void
	{
		//if (data)
		//{
			//data.dispose();
			//data = null;
		//}
		//
		//if (dataOrigional)
		//{
			//dataOrigional.dispose();
			//dataOrigional = null;
		//}
		//
		//if (dataFlipped)
		//{
			//dataFlipped.dispose();
			//dataFlipped = null;
		//}
		//
		//spritesheet = null;		
		//entity = null;
		//currentAnimation = null;
		//animationsDict = new Dictionary(true);
	}
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
	
	private function repositionRect():Void
	{
		// If the positions are from a "packed" sprite sheet, parse teh cellRect here, else do the standard:
		//cellRect.x = Int( (currentAnimation.framesArr[currentAnimation.frameIndex - 1] -1) % columns);			
		//cellRect.y = Int( (currentAnimation.framesArr[currentAnimation.frameIndex - 1] -1) / columns);
		//cellRect.x *= cellRect.width;
		//cellRect.y *= cellRect.height;
	}
	
	private function createFlippedSheet():Void 
	{
		//var i:Int, j:Int;
		//var matrix	:Matrix = new Matrix();
		//var clipRect:Rectangle = new Rectangle(0, 0, cellWidth, cellHeight);			
		//var destPos	:Point = new Point();			
		//var tempBmd	:BitmapData = new BitmapData(data.width, data.height, data.transparent, 0x00000000);
		//dataFlipped = new BitmapData(data.width, data.height, data.transparent, 0x00000000);
		//
		//if (flipX && flipY)
		//{
			//matrix.scale(-1, -1);
			//matrix.translate(data.width, data.height);				
			//tempBmd.draw(data, matrix, null, null, null, false);
			//
			//for(i in 0 ... columns)
			//{
				//for(j in 0 ... rows)
				//{
					//destPos.x = i * cellWidth;
					//destPos.y = j * cellHeight;
					//clipRect.x = ((columns - i) - 1) * cellWidth;
					//clipRect.y = ((rows - j) - 1) * cellHeight;
					//dataFlipped.copyPixels(tempBmd, clipRect, destPos, null, null, true);						
				//}
				//
			//}
		//}
		//else if (flipX)
		//{
			//matrix.scale(-1, 1);
			//matrix.translate(data.width, 0);
			//tempBmd.draw(data, matrix, null, null, null, false);	
			//
			//for(i in 0 ... columns)
			//{
				//for(j in 0 ... rows)
				//{
					//destPos.x = i * cellWidth;
					//destPos.y = j * cellHeight;					
					//clipRect.x = ((columns - i)-1) * cellWidth;
					//clipRect.y = j * cellHeight;						
					//dataFlipped.copyPixels(tempBmd, clipRect, destPos, null, null, true);						
				//}
				//
			//}
		//}
		//else if (flipY)
		//{
			//matrix.scale(1, -1);
			//matrix.translate(0, data.height);				
			//tempBmd.draw(data, matrix, null, null, null, false);				
			//
			//for(i in 0 ... columns)
			//{
				//for(j in 0 ... rows)
				//{
					//destPos.x = i * cellWidth;
					//destPos.y = j * cellHeight;
					//clipRect.x = i * cellWidth;
					//clipRect.y = ((rows - j) - 1) * cellHeight;
					//dataFlipped.copyPixels(tempBmd, clipRect, destPos, null, null, true);						
				//}
				//
			//}
		//}
	}
	
	private function doCallback(returnCall:String -> Void):Void 
	{
		//if (returnCall.length >= 1)	
			//returnCall(entity);
		//else
			//trace(this, "There is an error in your returnCall");
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
	
	

}