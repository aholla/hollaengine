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
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class RendererBlitComponent extends RendererComponent implements IRendererComponent
	{		
		private var _spritemap						:Spritemap;
		private var dest							:Point;
		private var smoothing						:Boolean;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function RendererBlitComponent($offsetX:int = 0, $offsetY:int = 0, smoothing:Boolean = false) 
		{
			super();
			_offsetX = $offsetX;
			_offsetY = $offsetY;
			dest = new Point();
			this.smoothing = smoothing;
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
		override public function drawBox($width:int, $height:int, $colour:uint = 0xFF0000, $alpha:Number = 1):void
		{
			
		}
		
		override public function drawCircle($radius:int, $colour:uint = 0xFF0000, $alpha:Number = 1):void
		{			
			
		}
		
		override public function drawPolygon($verticies:Array, $tx:Number = 0, $ty:Number = 0, $colour:uint = 0xFF0000, $alpha:Number = 1, $lineAlpha:Number = 0):void 
		{
			
		}
		
		override public function render(canvasData:BitmapData = null):void 
		{
			//_rect is set the the spritesheet rect when it is set.
			
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
				canvasData.copyPixels(_graphic.bitmapData, _rect, dest, null, null, true);
			}
			else
			{
				//trace("DRAW");
				buffer.lock();
				buffer.fillRect(buffer.rect, 0);
				buffer.copyPixels(_graphic.bitmapData, _rect, new Point, null, null, true);
				buffer.unlock();				
				
				var matrix:Matrix = new Matrix();				
				matrix.translate(- _rect.width * 0.5, - _rect.height * 0.5);
				matrix.rotate(owner.transform.rotation * HEUtils.TO_RADIANS);
				matrix.scale(scaleX, scaleY);
				matrix.translate(dest.x + ((_rect.width * 0.5) *scaleX), dest.y + ((_rect.width * 0.5)*scaleY));
				canvasData.draw(buffer, matrix, null, null, null, false);
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
		
		private var buffer		:BitmapData;
		//private var bufferRect	:BitmapData;
		
		public function initSpritemap(spritemap:Spritemap, isCentered:Boolean):void 
		{
			_spritemap 			= spritemap;
			_rect 				= _spritemap.cellRect;
			_graphic.bitmapData = _spritemap.data;
			
			buffer = new BitmapData(_rect.width, _rect.height, true, 0x00000000);
			//bufferRect = buffer.rect;
			
			if (isCentered)
			{
				_offsetX -= int(_spritemap.cellRect.width * 0.5);				
				_offsetY -= int(_spritemap.cellRect.height * 0.5);
			}
		}
		
		public function flash(colour:uint = 0xFFFFFF, duration:Number = 1, alpha:Number = 1, delay:Number = 0):void
		{
			
		}
		
		public function tint(colour:uint = 0xFFFFFF, alpha:Number = 1):void
		{
			
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