/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity 
{
	import aholla.HEngine.HE;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class RendererMovieClipComponent extends RendererComponent implements IRendererComponent
	{
		protected var _display						:MovieClip;
		protected var _frame						:int;	
		protected var _frameLabel					:String = "";	
		protected var _frameTotal					:int;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function RendererMovieClipComponent() 
		{
			super();
			_display = new MovieClip;
			_display.name = "rendercomponent_display";
		}		
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/		

		override public function onAdded($owner:IEntity, $name:String):void 
		{
			super.onAdded($owner, $name);			
			HE.world.addEntityRender(_display);
			render();
		}
		
		override public function start():void 
		{
			super.start();
			render();
			if (HE.isDebug && owner.collider)
			{					
				var _graphic:Sprite = new Sprite;
				_graphic.name = "debug_sprite";
				_graphic.alpha = debugAlpha;
				owner.collider.render(_graphic, 0x00FFFF);
				_display.addChild(_graphic);
			}
			HE.processManager.addRenderer(this);
			isActive = true;
		}
		
		override public function destroy():void 
		{
			
		}		

		
		override public function drawBox($width:int, $height:int, $colour:uint = 0xFF0000, $alpha:Number = 1):void
		{
			_display.graphics.beginFill($colour, $alpha);
			_display.graphics.drawRect(0, 0, $width, $height);
			_display.graphics.endFill();			
		}
		
		override public function drawCircle($radius:int, $colour:uint = 0xFF0000, $alpha:Number = 1):void
		{
			_display.graphics.beginFill($colour, $alpha);
			_display.graphics.drawCircle(0, 0, $radius);
			_display.graphics.endFill();			
		}
		
		override public function drawPolygon($verticies:Array, $tx:Number = 0, $ty:Number = 0, $colour:uint = 0xFF0000, $alpha:Number = 1, $lineAlpha:Number = 0):void 
		{
			_display.graphics.lineStyle(0.5, 0, $lineAlpha);
			
			_display.graphics.beginFill($colour, $alpha);
			_display.graphics.moveTo($verticies[0].x + $tx, $verticies[0].y + $ty);
			for (var i:int = 1; i < $verticies.length; i++) 
			{
				var item:Point = $verticies[i];
				_display.graphics.lineTo(item.x + $tx, item.y + $ty);
			}
			_display.graphics.endFill();
		}	
		
		
		override public function render(canvasData:BitmapData = null):void
		{		
			super.render(canvasData);
			if (camera.isMoving)
			{
				_display.x = int(owner.transform.x - camera.x) + _offsetX;
				_display.y = int(owner.transform.y - camera.y) + _offsetY;
			}
			else
			{
				_display.x = int(owner.transform.x + _offsetX);
				_display.y = int(owner.transform.y + _offsetY);
			}
			
			_display.rotation 	= owner.transform.rotation;
			_display.scaleX 	= owner.transform.scaleX;
			_display.scaleY 	= owner.transform.scaleY;
			_display.zIndex 	= owner.transform.zIndex;			
			
			if (!HE.isDebug)
			{
				// Give a larger bounds to each display just to be safe.
				leftEdge 	= _display.x - (_display.width);
				rightEdge 	= _display.x + (_display.width);
				topEdge 	= _display.y - (_display.height);
				bottomEdge 	= _display.y + (_display.height);
				
				if (leftEdge > HE.SCREEN_WIDTH || rightEdge < 0 || topEdge  > HE.SCREEN_HEIGHT || bottomEdge < 0)
					_display.visible = false;
				else
					_display.visible = true;
			}
		}
		
		override public function stop():void 
		{
			super.stop();
			_display.stop();
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

		public function get display():MovieClip 				{ return _display; }
		public function set display($sprite:MovieClip):void		
		{ 	
			_display = null; 
			_display = MovieClip($sprite);	
			HE.world.addEntityRender(_display);
			
			if (owner)
			{
				_display.x = owner.transform.x + _offsetX;
				_display.y = owner.transform.y + _offsetY;
				_display.rotation = owner.transform.rotation;	
			}
		}
		
		
		public function get frameTotal():int	
		{
			_frameTotal = display.totalFrames; 
			return _frameTotal; 
		}
		
		public function get frame():int	{ return _frame; }
		public function set frame($value:int):void
		{ 
			_frame = $value;			
			if (display)	(display as MovieClip).gotoAndStop(_frame);
		}
		
		public function get frameLabel():String	{ return _frameLabel; }
		public function set frameLabel($value:String):void
		{
			_frameLabel = $value;
			if (MovieClip(display))
			{
				MovieClip(display).gotoAndStop(_frameLabel);
				_frame = MovieClip(display).currentFrame;
			}
		}	
	
		
	}
}