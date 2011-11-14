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
	
		public function RendererBlitComponent(smoothing:Boolean = false) 
		{
			super();
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
			if (_spritemap)
				_spritemap.onUpdate();
			
			if (camera.isMoving)
			{
				dest.x = int(owner.transform.x - camera.x) + _offsetX;
				dest.y = int(owner.transform.y - camera.y) + _offsetY;
			}
			else
			{
				dest.x = int(owner.transform.x + _offsetX);
				dest.y = int(owner.transform.y + _offsetY);
			}
			
			//dest.x = owner.transform.x - 32;
			//dest.y = owner.transform.y -32;			
			
			if (!owner.transform.isDirty)
			{
				canvasData.copyPixels(_graphic.bitmapData, _rect, dest, null, null, true);
			}
			else
			{
				var matrix:Matrix = new Matrix();
				var colourTransform:ColorTransform = new ColorTransform();
				var clipRect:Rectangle = new Rectangle(0, 0, _rect.width, _rect.height);
				
				
				var scaleX:int = owner.transform.scaleX;
				var scaleY:int = owner.transform.scaleY;
				
				// destination
				//matrix.tx = -_rect.x + dest.x;
				matrix.tx = dest.x - (_rect.x * scaleX);
				matrix.ty = dest.y - (_rect.y * scaleY);
				clipRect.x =  dest.x;
				clipRect.y =  dest.y;
				
				// scale
				matrix.a = scaleX;
				matrix.d = scaleY;
				clipRect.width 	= _rect.width * scaleX;
				clipRect.height = _rect.width * scaleY;			
				
				
				canvasData.draw(_graphic.bitmapData, matrix, colourTransform, null, clipRect, smoothing);
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
		
		public function initSpritemap(spritemap:Spritemap, isCentered:Boolean):void 
		{
			_spritemap 			= spritemap;
			_rect 				= _spritemap.cellRect;
			_graphic.bitmapData = _spritemap.data;
			
			if (isCentered)
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