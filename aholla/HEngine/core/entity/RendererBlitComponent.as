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
		private var source							:BitmapData;
		private var dest							:Point;
		private var smoothing						:Boolean;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function RendererBlitComponent(smoothing:Boolean = false) 
		{
			super();
			dest = new Point();
			_graphic = new Bitmap();
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
		
		override public function stop():void 
		{
			if (_spritemap)
			{
				_spritemap.stop();
			}
		}
		
		override public function render(canvasData:BitmapData):void 
		{
			if (_spritemap)
			{
				_spritemap.onUpdate();
				_graphic.bitmapData = _spritemap.data;
				_rect = _spritemap.cellRect;
			}
			
			dest.x = owner.transform.x;
			dest.y = owner.transform.y;
			
			if (!owner.transform.isDirty)
			{
				canvasData.copyPixels(_graphic.bitmapData, _rect, dest, null, null, true);
			}
			else
			{
				var matrix:Matrix = new Matrix();
				var colourTransform:ColorTransform = new ColorTransform();
				var clipRect:Rectangle = new Rectangle(0, 0, _rect.width, _rect.height);
				
				
				// destination
				matrix.tx = -_rect.x + dest.x;
				matrix.ty = -_rect.y + dest.y;
				clipRect.x =  dest.x;
				clipRect.y =  dest.y;
				
				// scale
				//matrix.a = owner.transform.scaleX;
				//matrix.d = owner.transform.scaleY;
				//clipRect.width 	= _rect.width * owner.transform.scaleX;
				//clipRect.height = _rect.width * owner.transform.scaleY;			
				
				
				canvasData.draw(_graphic.bitmapData, matrix, colourTransform, null, clipRect, smoothing);
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