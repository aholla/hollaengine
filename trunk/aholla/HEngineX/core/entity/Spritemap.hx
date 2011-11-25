/**
* ...
* @author Adam
*/

package aholla.henginex.core.entity;

import com.furusystems.dconsole2.core.errors.NotImplementedError;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.PoInt;
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
	private var animationsDict					:Dictionary;		
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
		entity = entity;
		if (!spritesheet)	trace(this, "Error, spritesheet supplied is null");
		
		spritesheet = spritesheet;			
		
		cellWidth	= cellWidth;
		cellHeight	= cellHeight;
		if (!cellWidth)	cellWidth = spritesheet.width;
		if (!cellWidth)	cellWidth = spritesheet.height;			
		cellRect = new Rectangle(0, 0, cellWidth, cellWidth);			
		
		width 		= spritesheet.width;
		height 		= spritesheet.height;			
		columns 	= width / cellRect.width;
		rows 		= height / cellRect.height;	
		
		frameCount 	= columns * rows;			
		animationFramerate = 30;
		
		data = new BitmapData(spritesheet.bitmapData.width, spritesheet.bitmapData.height, true, 0x00000000)
		dataOrigional = data = spritesheet.bitmapData;	
		
		animationsDict = new Dictionary(true);	
		
		flipX = flipX;
		flipY = flipY;
		if (flipX || flipY)
			createFlippedSheet();
	}		
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	public function addAnimation(name:String, framesArr:Array, frameRate:Int = 30, loop:Bool = true, flipX:Bool = false, flipY:Bool = false, callback:Function = null, callbackFrameIndex:Int = 0):Void
	{
		if (animationsDict[name])
		{
			trace("error, animation already exists");
			return;
		}
		animationsDict[name] = new SpriteAnimation(name, framesArr, frameRate, loop, flipX, flipY, callback, callbackFrameIndex);			
	}
	
	public function play(animationName:String):Void
	{
		currentAnimation = animationsDict[animationName];
		if (currentAnimation)
		{
			isPlaying = true;
			if (currentAnimation.flipX || currentAnimation.flipY)
			{
				// quick check to see if it has been set up correctly and if not, set it up.
				if (!dataFlipped)
				{
					if (flipX != currentAnimation.flipX)	flipX = currentAnimation.flipX;						
					if (flipY != currentAnimation.flipY)	flipY = currentAnimation.flipY;
					createFlippedSheet();
				}
				data = dataFlipped;
			}
			else
				data = dataOrigional;
			repositionRect();
		}
	}
	
	public function stop():Void 
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
	
	public function onUpdate():Void
	{
		if (isPlaying && currentAnimation)
		{
			animationTick++;				
			
			if (animationTick == currentAnimation.frameRate) 
			{
				animationTick = 0;	
				currentAnimation.frameIndex ++;
				
				// check for callback
				if (currentAnimation.callbackFrameIndex != 0 && currentAnimation.callbackFrameIndex == currentAnimation.frameIndex)
				{
					doCallback(currentAnimation.callback);						
				}
				
				// reset
				if (currentAnimation.frameIndex == currentAnimation.frameCount+1)
				{
					if (currentAnimation.callback != null && currentAnimation.callbackFrameIndex == 0)
					{
						doCallback(currentAnimation.callback);	
					}
					
					if (currentAnimation.isLoop)
					{
						currentAnimation.frameIndex = 1;
					}
					else
					{
						currentAnimation = null;
						return;
					}
				}					
				repositionRect();
			}
		}
	}		
	
	public function destroy():Void
	{
		if (data)
		{
			data.dispose();
			data = null;
		}
		
		if (dataOrigional)
		{
			dataOrigional.dispose();
			dataOrigional = null;
		}
		
		if (dataFlipped)
		{
			dataFlipped.dispose();
			dataFlipped = null;
		}
		
		spritesheet = null;		
		entity = null;
		currentAnimation = null;
		animationsDict = new Dictionary(true);
	}
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
	
	private function repositionRect():Void
	{
		// If the positions are from a "packed" sprite sheet, parse teh cellRect here, else do the standard:
		cellRect.x = Int( (currentAnimation.framesArr[currentAnimation.frameIndex - 1] -1) % columns);			
		cellRect.y = Int( (currentAnimation.framesArr[currentAnimation.frameIndex - 1] -1) / columns);
		cellRect.x *= cellRect.width;
		cellRect.y *= cellRect.height;
	}
	
	private function createFlippedSheet():Void 
	{
		var i:Int, j:Int;
		var matrix	:Matrix = new Matrix();
		var clipRect:Rectangle = new Rectangle(0, 0, cellWidth, cellHeight);			
		var destPos	:PoInt = new PoInt();			
		var tempBmd	:BitmapData = new BitmapData(data.width, data.height, data.transparent, 0x00000000);
		dataFlipped = new BitmapData(data.width, data.height, data.transparent, 0x00000000);
		
		if (flipX && flipY)
		{
			matrix.scale(-1, -1);
			matrix.translate(data.width, data.height);				
			tempBmd.draw(data, matrix, null, null, null, false);
			
			for (i = 0; i < columns; i++) 
			{
				for (j = 0; j < rows; j++) 
				{
					destPos.x = i * cellWidth;
					destPos.y = j * cellHeight;
					clipRect.x = ((columns - i) - 1) * cellWidth;
					clipRect.y = ((rows - j) - 1) * cellHeight;
					dataFlipped.copyPixels(tempBmd, clipRect, destPos, null, null, true);						
				}
				
			}
		}
		else if (flipX)
		{
			matrix.scale(-1, 1);
			matrix.translate(data.width, 0);
			tempBmd.draw(data, matrix, null, null, null, false);	
			
			for (i = 0; i < columns; i++) 
			{
				for (j = 0; j < rows; j++) 
				{
					destPos.x = i * cellWidth;
					destPos.y = j * cellHeight;					
					clipRect.x = ((columns - i)-1) * cellWidth;
					clipRect.y = j * cellHeight;						
					dataFlipped.copyPixels(tempBmd, clipRect, destPos, null, null, true);						
				}
				
			}
		}
		else if (flipY)
		{
			matrix.scale(1, -1);
			matrix.translate(0, data.height);				
			tempBmd.draw(data, matrix, null, null, null, false);				
			
			for (i = 0; i < columns; i++) 
			{
				for (j = 0; j < rows; j++) 
				{
					destPos.x = i * cellWidth;
					destPos.y = j * cellHeight;
					clipRect.x = i * cellWidth;
					clipRect.y = ((rows - j) - 1) * cellHeight;
					dataFlipped.copyPixels(tempBmd, clipRect, destPos, null, null, true);						
				}
				
			}
		}
	}
	
	private function doCallback(callback:Function):Void 
	{
		if (callback.length >= 1)	
			callback(entity);
		else
			trace(this, "There is an error in your callback");
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
	
	

}