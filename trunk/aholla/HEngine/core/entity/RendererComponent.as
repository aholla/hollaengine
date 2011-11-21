/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity 
{
	import aholla.HEngine.collision.shapes.Box;
	import aholla.HEngine.collision.shapes.Circle;
	import aholla.HEngine.collision.shapes.IShape;
	import aholla.HEngine.collision.shapes.Polygon;
	import aholla.HEngine.core.Camera;
	import aholla.HEngine.core.entity.IEntity;
	import aholla.HEngine.HE;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;	
	
	public class RendererComponent extends Component implements IRendererComponent
	{			
		protected var _graphic						:Bitmap;
		protected var _bounds						:Rectangle;		
		protected var _alpha						:Number;
		protected var _offsetX						:Number;
		protected var _offsetY						:Number;
		protected var _isCentered					:Boolean;
		protected var colourTransform				:ColorTransform;
		protected var camera						:Camera; 
		protected var debugSprite					:Sprite;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function RendererComponent() 
		{
			camera = HE.camera;		
			_graphic = new Bitmap();
			_bounds = new Rectangle();			
			_offsetX = _offsetY = 1;			
			_isCentered = true;
			
			//debugAlpha = 0.8;
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		override public function onAdded($owner:IEntity, $name:String):void 
		{
			super.onAdded($owner, $name);
			HE.processManager.addRenderer(this);
		}
		
		override public function destroy():void 
		{
			HE.processManager.removeRenderer(this);
			super.destroy();
		}
		
		public function drawBox($width:int, $height:int, $colour:uint = 0xFF0000, $alpha:Number = 1):void
		{
			var sprite:Sprite = new Sprite();
			var shape:IShape = new Box($width, $height, false);
			shape.render(sprite.graphics, $colour, $alpha, $colour, 0);			
			
			_graphic.bitmapData.dispose();
			_graphic.bitmapData = new BitmapData(sprite.width, sprite.height, true, 0x00000000);
			_graphic.bitmapData.draw(sprite);			
			
			_bounds = _graphic.bitmapData.rect;
			
			if (_isCentered)
			{
				_offsetX += -_graphic.bitmapData.width * 0.5;
				_offsetY += -_graphic.bitmapData.height * 0.5;
			}			
		}
		
		public function drawCircle(radius:int, colour:uint = 0xFF0000, alpha:Number = 1):void
		{			
			var sprite:Sprite = new Sprite();			
			var shape:IShape =  new Circle(radius, radius, radius);
			shape.render(sprite.graphics, colour, alpha, colour, 0);	
			
			_graphic.bitmapData.dispose();
			_graphic.bitmapData = new BitmapData(sprite.width, sprite.height, true, 0x00000000);
			_graphic.bitmapData.draw(sprite);			
			
			_bounds = _graphic.bitmapData.rect;
			
			if (_isCentered)
			{
				_offsetX += -_graphic.bitmapData.width * 0.5;
				_offsetY += -_graphic.bitmapData.height * 0.5;
			}
		}
		
		public function drawPolygon($verticies:Array, $colour:uint = 0xFF0000, $alpha:Number = 1):void 
		{
			var sprite:Sprite = new Sprite();
			var shape:IShape =  Polygon.fromArray($verticies, 0, 0);
			shape.render(sprite.graphics, $colour, $alpha, $colour, 0);
			
			_graphic.bitmapData.dispose();
			_graphic.bitmapData = new BitmapData(sprite.width, sprite.height, true, 0x00000000);;
			_graphic.bitmapData.draw(sprite);			
			
			_bounds = _graphic.bitmapData.rect;
			
			if (_isCentered)
			{
				_offsetX += -_graphic.bitmapData.width * 0.5;
				_offsetY += -_graphic.bitmapData.height * 0.5;
			}
		}		
		
		public function render(canvasData:BitmapData = null):void 
		{
		}
		
		
		public function debugRender(canvasData:BitmapData):void 
		{
			if (owner.collider)
			{
				if (!debugSprite)
				{
					debugSprite = new Sprite();
					owner.collider.render(debugSprite);
				}
				var matrix:Matrix = new Matrix();
				matrix.translate(owner.transform.x, owner.transform.y);
				canvasData.draw(debugSprite, matrix);				
			}
		}
		
		public function play($animation:String):void
		{
		}
		
		public function stop():void 
		{			
		}
		
		public function flashColour(colour:uint = 0xFFFFFF, duration:Number = 1, alpha:Number = 1, delay:Number = 0):void
		{
			
		}
		
		public function tint(colour:uint = 0xFFFFFF, alpha:Number = 1):void
		{
			
		}		
		
		public function setGraphic(image:Bitmap, $width:int = 0, $height:int = 0):void 
		{
			var _w:int = ($width != 0) ? $width : image.width;
			var _h:int = ($height != 0) ? $height : image.height;			
			_graphic = image;			
			
			if (_isCentered)	
			{
				_offsetX = -_w * 0.5;
				_offsetY = -_h * 0.5;
				_bounds = new Rectangle(0, 0, _w, _h);
			}
			else
			{
				_bounds = new Rectangle(0, 0, _w, _h);
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
		
		//public function set graphic($graphic:Bitmap):void 	
		//{	
			//_graphic = $graphic;
			//if (_isCentered)	
			//{
				//_graphic.x = -_graphic.width * 0.5;
				//_graphic.y = -_graphic.height * 0.5;
				//_bounds = new Rectangle( -_graphic.width * 0.5, -_graphic.height * 0.5, _graphic.width, _graphic.height);
			//}
			//else
			//{
				//_bounds = new Rectangle(0, 0, _graphic.width, _graphic.height);
			//}
			//trace("set graphic")
		//}
		public function get graphic():Bitmap 				{	return _graphic; }		
		
		public function get alpha():Number 						{	return _alpha;}		
		public function set alpha($value:Number):void 			{	_alpha = $value;}
		
		public function get offsetX():Number 					{	return _offsetX;}		
		public function set offsetX($value:Number):void 		{	_offsetX = $value; }
		
		public function get offsetY():Number 					{	return _offsetY;}		
		public function set offsetY($value:Number):void 		{	_offsetY = $value; }
		
		
	}
}