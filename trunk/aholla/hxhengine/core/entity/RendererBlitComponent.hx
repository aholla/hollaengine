/**
* ...
* @author Adam
*/

package aholla.hxhengine.core.entity;

import aholla.hxhengine.core.Camera;
import aholla.hxhengine.core.entity.IEntity;
import aholla.hxhengine.core.Logger;
import aholla.hxhengine.HE;
import aholla.hxhengine.HEUtils;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.filters.ColorMatrixFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class RendererBlitComponent extends RendererComponent, implements IRendererComponent
{		
	private var spmap							:Spritemap;
	private var dest							:Point;
	private var smoothing						:Bool;
	private var buffer							:BitmapData;
	private var isDirty							:Bool;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new(isCentered:Bool = true, offsetX:Int = 0, offsetY:Int = 0, smoothing:Bool = false) 
	{
		super();
		
		this.isCentered = isCentered;
		this.offsetX 	= offsetX;
		this.offsetY 	= offsetY;
		this.smoothing 	= smoothing;
		
		dest = new Point();	
		colourTransform = new ColorTransform();
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
* -------------------------------------------------*/		

	override public function onRender(canvasData:BitmapData = null):Void 
	{
		//bounds is set the the spritesheet rect when it is set.
		if (owner.transform.isOnscreen())
		{
			var scaleX:Float = owner.transform.scaleX;
			var scaleY:Float = owner.transform.scaleY;			
			
			if (spmap != null)
				spmap.onUpdate();
			
			if (camera.isMoving)
			{
				dest.x = Std.int(owner.transform.x - camera.x) + (offsetX * scaleX);
				dest.y = Std.int(owner.transform.y - camera.y) + (offsetY * scaleY);
			}
			else
			{				
				dest.x = Std.int(owner.transform.x + (offsetX * scaleX));
				dest.y = Std.int(owner.transform.y + (offsetY * scaleY));
			}
			
			if (!isDirty && !owner.transform.isDirty)
			{
				//trace("Copy");
				canvasData.copyPixels(graphic.bitmapData, bounds, dest, null, null, true);
			}
			else
			{
				//trace("DRAW");
				if (buffer == null)
					buffer = new BitmapData(Std.int(bounds.width), Std.int(bounds.height), true, 0x00000000);
				
				buffer.lock();
				buffer.fillRect(buffer.rect, 0);
				buffer.copyPixels(graphic.bitmapData, bounds, new Point(), null, null, true);
				buffer.unlock();				
				
				var matrix:Matrix = new Matrix();				
				matrix.translate(- bounds.width * 0.5, - bounds.height * 0.5);
				matrix.rotate(owner.transform.rotation * HEUtils.TO_RADIANS);
				matrix.scale(scaleX, scaleY);
				matrix.translate(dest.x + ((bounds.width * 0.5) *scaleX), dest.y + ((bounds.width * 0.5)*scaleY));
				canvasData.draw(buffer, matrix, colourTransform, null, null, smoothing);
			}
			
			if (HE.isDebug)
			{
				debugRender();
			}
		}
	}
	
	override public function play(animation:String):Void
	{
		if (spmap != null)
			spmap.play(animation);
	}
	
	override public function stop():Void 
	{
		if (spmap != null)
			spmap.stop();
	}		
	
	
	
	override public function flashColour(colour:UInt = 0xFFFFFF, duration:Float = 1, alpha:Float = 1, delay:Float = 0):Void
	{		
		isDirty = true;
		colourTransform.color = colour;	
		colourTransform.alphaMultiplier = 0.5;
	}
	
	override public function tint(colour:UInt = 0xFFFFFF, alpha:Float = 1):Void
	{
		isDirty = true;
		colourTransform.color = colour;
		colourTransform.alphaMultiplier = 0.5;
	}		
	
	public function initSpriteMap(spritemap:Spritemap):Void 
	{
		this.spmap 			= spritemap;
		bounds 				= spmap.cellRect;
		graphic.bitmapData 	= spmap.data;
		
		buffer = new BitmapData(Std.int(bounds.width), Std.int(bounds.height), true, 0x00000000);
		
		if (isCentered)
		{
			offsetX -= Std.int(spmap.cellRect.width * 0.5);				
			offsetY -= Std.int(spmap.cellRect.height * 0.5);
		}
	}
	
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
	
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/		
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
	override private function setAlpha(value:Float):Float 
	{
		if (alpha != 1)
		{
			colourTransform.alphaMultiplier = alpha;
			isDirty = true;
		}
		else
		{
			isDirty = false;
		}
		return value;
	}

}