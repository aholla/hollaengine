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
	import flash.geom.Rectangle;
	
	public class RendererComponent extends Component implements IRendererComponent
	{			
		protected var _spritemap					:Spritemap;
		protected var _graphic						:Bitmap;
		protected var _rect							:Rectangle;		
		protected var _alpha						:Number;
		protected var _offsetX						:Number = 0;
		protected var _offsetY						:Number = 0;
		protected var camera						:Camera; 		
		protected var leftEdge						:int;
		protected var rightEdge						:int;
		protected var topEdge						:int;
		protected var bottomEdge					:int;
		protected var debugAlpha					:Number = 0.8;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function RendererComponent() 
		{
			camera = HE.camera;
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
		
		public function render(canvasData:BitmapData):void 
		{
		}
		
		public function play($animation:String):void
		{
			if (_spritemap)
			{
				_spritemap.play($animation);
			}
		}
		
		public function stop():void 
		{
			if (_spritemap)
			{
				_spritemap.stop();
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
		
		public function set graphic($graphic:Bitmap):void 	
		{	
			_graphic = $graphic;			
			_rect = new Rectangle(0,0, _graphic.width, _graphic.height);
		}
		public function get graphic():Bitmap 				{	return _graphic; }
		
		public function set spritemap($spritemap:Spritemap):void 	
		{	
			_spritemap = $spritemap;
			_rect = new Rectangle(0,0, $spritemap.data.width, $spritemap.data.height);
		}
		public function get spritemap():Spritemap 					{	return _spritemap;}
		
		public function get alpha():Number 						{	return _alpha;}		
		public function set alpha($value:Number):void 			{	_alpha = $value;}
		
		public function get offsetX():Number 					{	return _offsetX;}		
		public function set offsetX($value:Number):void 		{	_offsetX = $value; }
		
		public function get offsetY():Number 					{	return _offsetY;}		
		public function set offsetY($value:Number):void 		{	_offsetY = $value; }
		
		
	}
}