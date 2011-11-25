/**
* ...
* @author Adam
*/

package aholla.henginex.core.entity;

import aholla.henginex.core.Camera;
import aholla.henginex.core.entity.IEntity;
import aholla.henginex.core.Logger;
import aholla.henginex.HE;
import aholla.henginex.HEUtils;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.filters.ColorMatrixFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.PoInt;
import flash.geom.Rectangle;

class RendererBlitComponent extends RendererComponent implements IRendererComponent
{		
	private var _spritemap						:Spritemap;
	private var dest							:PoInt;
	private var _smoothing						:Bool;
	private var _buffer							:BitmapData;
	private var _isDirty						:Bool;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new(isCentered:Bool = true, offsetX:Int = 0, offsetY:Int = 0, smoothing:Bool = false) 
	{
		super();
		
		_isCentered = isCentered;
		_offsetX 	= offsetX;
		_offsetY 	= offsetY;
		_smoothing 	= smoothing;
		
		dest = new PoInt();	
		colourTransform = new ColorTransform();
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
* -------------------------------------------------*/		

	override public function onRender(canvasData:BitmapData = null):Void 
	{
		//_bounds is set the the spritesheet rect when it is set.
		if (owner.transform.isOnscreen())
		{
			var scaleX:Float = owner.transform.scaleX;
			var scaleY:Float = owner.transform.scaleY;			
			
			if (_spritemap)
				_spritemap.onUpdate();
			
			if (camera.isMoving)
			{
				dest.x = Int(owner.transform.x - camera.x) + (_offsetX * scaleX);
				dest.y = Int(owner.transform.y - camera.y) + (_offsetY * scaleY);
			}
			else
			{				
				dest.x = Int(owner.transform.x + (_offsetX * scaleX));
				dest.y = Int(owner.transform.y + (_offsetY * scaleY));
			}
			
			if (!_isDirty && !owner.transform.isDirty)
			{
				//trace("Copy");
				canvasData.copyPixels(_graphic.bitmapData, _bounds, dest, null, null, true);
			}
			else
			{
				//trace("DRAW");
				if (!_buffer)
					_buffer = new BitmapData(_bounds.width, _bounds.height, true, 0x00000000);
				
				_buffer.lock();
				_buffer.fillRect(_buffer.rect, 0);
				_buffer.copyPixels(_graphic.bitmapData, _bounds, new PoInt, null, null, true);
				_buffer.unlock();				
				
				var matrix:Matrix = new Matrix();				
				matrix.translate(- _bounds.width * 0.5, - _bounds.height * 0.5);
				matrix.rotate(owner.transform.rotation * HEUtils.TO_RADIANS);
				matrix.scale(scaleX, scaleY);
				matrix.translate(dest.x + ((_bounds.width * 0.5) *scaleX), dest.y + ((_bounds.width * 0.5)*scaleY));
				canvasData.draw(_buffer, matrix, colourTransform, null, null, _smoothing);
			}
			
			if (HE.isDebug)
			{
				//debugRender();
			}
		}
	}
	
	override public function play(animation:String):Void
	{
		if (_spritemap)
			_spritemap.play(animation);
	}
	
	override public function stop():Void 
	{
		if (_spritemap)
			_spritemap.stop();
	}		
	
	
	
	override public function flashColour(colour:Uint = 0xFFFFFF, duration:Float = 1, alpha:Float = 1, delay:Float = 0):Void
	{		
		_isDirty = true;
		colourTransform.color = colour;	
		colourTransform.alphaMultiplier = 0.5;
	}
	
	override public function tInt(colour:Uint = 0xFFFFFF, alpha:Float = 1):Void
	{
		_isDirty = true;
		colourTransform.color = colour;
		colourTransform.alphaMultiplier = 0.5;
	}		
	
	public function initSpritemap(spritemap:Spritemap):Void 
	{
		_spritemap 			= spritemap;
		_bounds 			= _spritemap.cellRect;
		_graphic.bitmapData = _spritemap.data;
		
		_buffer = new BitmapData(_bounds.width, _bounds.height, true, 0x00000000);
		
		if (_isCentered)
		{
			_offsetX -= Int(_spritemap.cellRect.width * 0.5);				
			_offsetY -= Int(_spritemap.cellRect.height * 0.5);
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

	override public function get alpha():Float 
	{
		return super.alpha;
	}
	
	override public function set alpha(value:Float):Void 
	{
		super.alpha = value;
		if (_alpha != 1)
		{
			colourTransform.alphaMultiplier = _alpha;
			_isDirty = true;
		}
		else
		{
			_isDirty = false;
		}
	}

}