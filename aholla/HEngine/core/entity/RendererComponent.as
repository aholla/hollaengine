/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity 
{
	import aholla.HEngine.core.Camera;
	import aholla.HEngine.core.entity.IEntity;
	import aholla.HEngine.HE;
	import com.greensock.motionPaths.RectanglePath2D;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class RendererComponent extends Component implements IRendererComponent
	{			
		protected var _graphic						:Bitmap;
		protected var _rect							:Rectangle;		
		protected var _alpha						:Number;
		protected var _offsetX						:Number;
		protected var _offsetY						:Number;
		protected var camera						:Camera; 
		private var debugSprite						:Sprite;
		
		protected var leftEdge						:int;
		protected var rightEdge						:int;
		protected var topEdge						:int;
		protected var bottomEdge					:int;
		protected var debugAlpha					:Number;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function RendererComponent() 
		{
			camera = HE.camera;
			_graphic = new Bitmap();
			_graphic.bitmapData = new BitmapData(10, 10, true, 0x00000000);			
			_rect = _graphic.bitmapData.rect;
			_offsetX = _offsetY = 0;
			debugAlpha = 0.8;
			debugSprite =  new Sprite();
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		override public function onAdded($owner:IEntity, $name:String):void 
		{
			super.onAdded($owner, $name);
			HE.processManager.addRenderer(this);
		}
		
		public function drawBox($width:int, $height:int, $colour:uint = 0xFF0000, $alpha:Number = 1):void
		{
			
		}
		
		public function drawCircle($radius:int, $colour:uint = 0xFF0000, $alpha:Number = 1):void
		{			
			
		}
		
		public function drawPolygon($verticies:Array, $tx:Number = 0, $ty:Number = 0, $colour:uint = 0xFF0000, $alpha:Number = 1, $lineAlpha:Number = 0):void 
		{
			
		}		
		
		public function render(canvasData:BitmapData = null):void 
		{
		}
		
		
		public function debugRender(canvasData:BitmapData):void 
		{
			if (owner.collider)
			{
				debugSprite.graphics.clear();
				owner.collider.render(debugSprite);
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
		
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/			
		
		public function set graphic($graphic:Bitmap):void 	
		{	
			_graphic = $graphic;		
			_rect = new Rectangle(0,0, _graphic.width, _graphic.height);
		}
		public function get graphic():Bitmap 				{	return _graphic; }		
		
		public function get alpha():Number 						{	return _alpha;}		
		public function set alpha($value:Number):void 			{	_alpha = $value;}
		
		public function get offsetX():Number 					{	return _offsetX;}		
		public function set offsetX($value:Number):void 		{	_offsetX = $value; }
		
		public function get offsetY():Number 					{	return _offsetY;}		
		public function set offsetY($value:Number):void 		{	_offsetY = $value; }
		
		
	}
}