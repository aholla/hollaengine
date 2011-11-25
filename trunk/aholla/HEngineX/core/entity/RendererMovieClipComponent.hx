/**
* ...
* @author Adam
*/

package aholla.henginex.core.entity;

import aholla.henginex.HE;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.PoInt;

class RendererMovieClipComponent extends RendererComponent implements IRendererComponent
{
	protected var _display						:MovieClip;
	protected var _frame						:Int;	
	protected var _frameLabel					:String = "";	
	protected var _frameTotal					:Int;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new() 
	{
		super();
		_display = new MovieClip;
		_display.name = "rendercomponent_display";
	}		
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/		

	override public function onAdded(owner:IEntity, name:String):Void 
	{
		super.onAdded(owner, name);			
		HE.world.addEntityRender(_display);
		render();
	}
	
	override public function start():Void 
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
	
	override public function destroy():Void 
	{
		
	}		

	
	override public function drawBox(width:Int, height:Int, center:Bool = true, colour:Uint = 0xFF0000, alpha:Float = 1):Void
	{
		_display.graphics.beginFill(colour, alpha);
		_display.graphics.drawRect(0, 0, width, height);
		_display.graphics.endFill();			
	}
	
	override public function drawCircle(radius:Int, center:Bool = true, colour:Uint = 0xFF0000, alpha:Float = 1):Void
	{
		_display.graphics.beginFill(colour, alpha);
		_display.graphics.drawCircle(0, 0, radius);
		_display.graphics.endFill();			
	}
	
	override public function drawPolygon(verticies:Array, tx:Float = 0, ty:Float = 0, colour:Uint = 0xFF0000, alpha:Float = 1, lineAlpha:Float = 0):Void 
	{
		_display.graphics.lineStyle(0.5, 0, lineAlpha);
		
		_display.graphics.beginFill(colour, alpha);
		_display.graphics.moveTo(verticies[0].x + tx, verticies[0].y + ty);
		for (var i:Int = 1; i < verticies.length; i++) 
		{
			var item:PoInt = verticies[i];
			_display.graphics.lineTo(item.x + tx, item.y + ty);
		}
		_display.graphics.endFill();
	}	
	
	
	override public function onRender(canvasData:BitmapData = null):Void
	{		
		super.render(canvasData);
		if (camera.isMoving)
		{
			_display.x = Int(owner.transform.x - camera.x) + _offsetX;
			_display.y = Int(owner.transform.y - camera.y) + _offsetY;
		}
		else
		{
			_display.x = Int(owner.transform.x + _offsetX);
			_display.y = Int(owner.transform.y + _offsetY);
		}
		
		_display.rotation 	= owner.transform.rotation;
		_display.scaleX 	= owner.transform.scaleX;
		_display.scaleY 	= owner.transform.scaleY;
		_display.zIndex 	= owner.transform.zIndex;			
		
		if (!HE.isDebug)
		{
			// Give a larger bounds to each display just to be safe.
			_bounds.x 		= _display.x - (_display.width);
			_bounds.width 	= _display.x + (_display.width);
			_bounds.y 		= _display.y - (_display.height);
			_bounds.height 	= _display.y + (_display.height);
			
			if (_bounds.x > HE.SCREEN_WIDTH || _bounds.width < 0 || _bounds.y  > HE.SCREEN_HEIGHT || _bounds.height < 0)
				_display.visible = false;
			else
				_display.visible = true;
		}
	}
	
	override public function stop():Void 
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
	public function set display(sprite:MovieClip):Void		
	{ 	
		_display = null; 
		_display = MovieClip(sprite);	
		HE.world.addEntityRender(_display);
		
		if (owner)
		{
			_display.x = owner.transform.x + _offsetX;
			_display.y = owner.transform.y + _offsetY;
			_display.rotation = owner.transform.rotation;	
		}
	}
	
	
	public function get frameTotal():Int	
	{
		_frameTotal = display.totalFrames; 
		return _frameTotal; 
	}
	
	public function get frame():Int	{ return _frame; }
	public function set frame(value:Int):Void
	{ 
		_frame = value;			
		if (display)	(display as MovieClip).gotoAndStop(_frame);
	}
	
	public function get frameLabel():String	{ return _frameLabel; }
	public function set frameLabel(value:String):Void
	{
		_frameLabel = value;
		if (MovieClip(display))
		{
			MovieClip(display).gotoAndStop(_frameLabel);
			_frame = MovieClip(display).currentFrame;
		}
	}	

	
}