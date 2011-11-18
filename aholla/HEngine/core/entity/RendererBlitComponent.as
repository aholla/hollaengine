/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity 
{
	import aholla.HEngine.core.Camera;
	import aholla.HEngine.core.entity.IEntity;
	import aholla.HEngine.core.Logger;
	import aholla.HEngine.HE;
	import aholla.HEngine.HEUtils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class RendererBlitComponent extends RendererComponent implements IRendererComponent
	{		
		private var _spritemap						:Spritemap;
		private var dest							:Point;
		private var _smoothing						:Boolean;
		private var _buffer							:BitmapData;		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function RendererBlitComponent(isCentered:Boolean = true, offsetX:int = 0, offsetY:int = 0, smoothing:Boolean = false) 
		{
			super();
			
			_isCentered = isCentered;
			_offsetX 	= offsetX;
			_offsetY 	= offsetY;
			_smoothing 	= smoothing;
			
			dest = new Point();	
			colourTransform = new ColorTransform();
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
* -------------------------------------------------*/		
	
		override public function render(canvasData:BitmapData = null):void 
		{
			//_bounds is set the the spritesheet rect when it is set.
			
			var scaleX:Number = owner.transform.scaleX;
			var scaleY:Number = owner.transform.scaleY;			
			
			if (_spritemap)
				_spritemap.onUpdate();
			
			if (camera.isMoving)
			{
				dest.x = int(owner.transform.x - camera.x) + (_offsetX * scaleX);
				dest.y = int(owner.transform.y - camera.y) + (_offsetY * scaleY);
			}
			else
			{				
				dest.x = int(owner.transform.x + (_offsetX * scaleX));
				dest.y = int(owner.transform.y + (_offsetY * scaleY));
			}
			
			
			
			if (!owner.transform.isDirty)
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
				_buffer.copyPixels(_graphic.bitmapData, _bounds, new Point, null, null, true);
				_buffer.unlock();				
				
				var matrix:Matrix = new Matrix();				
				matrix.translate(- _bounds.width * 0.5, - _bounds.height * 0.5);
				matrix.rotate(owner.transform.rotation * HEUtils.TO_RADIANS);
				matrix.scale(scaleX, scaleY);
				matrix.translate(dest.x + ((_bounds.width * 0.5) *scaleX), dest.y + ((_bounds.width * 0.5)*scaleY));
				canvasData.draw(_buffer, matrix, colourTransform, null, null, _smoothing);
			}
		}
		
		override public function play($animation:String):void
		{
			if (_spritemap)
				_spritemap.play($animation);
		}
		
		override public function stop():void 
		{
			if (_spritemap)
				_spritemap.stop();
		}		
		
		
		
		override public function flashColour(colour:uint = 0xFFFFFF, duration:Number = 1, alpha:Number = 1, delay:Number = 0):void
		{		
			owner.transform.isDirty = true;
			colourTransform.color = colour;	
			colourTransform.alphaMultiplier = 0.5;
		}
		
		override public function tint(colour:uint = 0xFFFFFF, alpha:Number = 1):void
		{
			owner.transform.isDirty = true;
			colourTransform.color = colour;
			colourTransform.alphaMultiplier = 0.5;
		}		
		
		public function initSpritemap(spritemap:Spritemap):void 
		{
			_spritemap 			= spritemap;
			_bounds 				= _spritemap.cellRect;
			_graphic.bitmapData = _spritemap.data;
			
			_buffer = new BitmapData(_bounds.width, _bounds.height, true, 0x00000000);
			
			if (_isCentered)
			{
				_offsetX -= int(_spritemap.cellRect.width * 0.5);				
				_offsetY -= int(_spritemap.cellRect.height * 0.5);
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

	}
}