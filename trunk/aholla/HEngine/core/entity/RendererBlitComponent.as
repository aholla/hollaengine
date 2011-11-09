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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class RendererBlitComponent extends RendererComponent implements IRendererComponent
	{			
		private var source							:BitmapData;
		private var dest							:Point;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function RendererBlitComponent() 
		{
			super();
			dest = new Point();
			_graphic = new Bitmap();
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
			
			// TODO: RendererBlitComponent - check positions to see if it needs to be rendered or not			
			canvasData.copyPixels(_graphic.bitmapData, _rect, dest, null, null, true);
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