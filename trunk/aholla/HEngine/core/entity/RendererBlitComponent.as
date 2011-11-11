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
		//private var source							:BitmapData;
		private var dest							:Point;
		private var smoothing						:Boolean;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function RendererBlitComponent(smoothing:Boolean = false) 
		{
			super();
			dest = new Point();
			//_graphic = new Bitmap();
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
			
			//trace("X", owner.name, canvasData, _graphic, _graphic.bitmapData);
			
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