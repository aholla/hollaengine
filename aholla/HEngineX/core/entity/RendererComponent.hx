/**
* ...
* @author Adam
*/

package aholla.henginex.core.entity;

import aholla.henginex.collision.shapes.Box;
import aholla.henginex.collision.shapes.Circle;
import aholla.henginex.collision.shapes.IShape;
import aholla.henginex.collision.shapes.Polygon;
import aholla.henginex.core.Camera;
import aholla.henginex.core.entity.IEntity;
import aholla.henginex.HE;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.PoInt;
import flash.geom.Rectangle;	

class RendererComponent extends Component implements IRendererComponent
{			
	protected var _graphic						:Bitmap;
	protected var _bounds						:Rectangle;		
	protected var _alpha						:Float;
	protected var _offsetX						:Float;
	protected var _offsetY						:Float;
	protected var _isCentered					:Bool;
	protected var colourTransform				:ColorTransform;
	protected var camera						:Camera; 
	protected var debugSprite					:Sprite;
	protected var debugBuffer					:BitmapData;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new() 
	{
		camera = HE.camera;		
		_graphic = new Bitmap();
		_bounds = new Rectangle();			
		_offsetX = _offsetY = 1;			
		_isCentered = true;
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	override public function onAdded(owner:IEntity, name:String):Void 
	{
		super.onAdded(owner, name);
		HE.processManager.addRenderer(this);
	}
	
	override public function destroy():Void 
	{
		HE.processManager.removeRenderer(this);
		super.destroy();
	}
	
	public function drawBox(width:Int, height:Int, colour:Uint = 0xFF0000, alpha:Float = 1):Void
	{
		var sprite:Sprite = new Sprite();
		var shape:IShape = new Box(width, height, false);
		shape.render(sprite.graphics, colour, alpha, colour, 0);			
		drawShape(sprite);
	}
	
	public function drawCircle(radius:Int, colour:Uint = 0xFF0000, alpha:Float = 1):Void
	{			
		var sprite:Sprite = new Sprite();			
		var shape:IShape =  new Circle(radius, radius, radius);
		shape.render(sprite.graphics, colour, alpha, colour, 0);			
		drawShape(sprite);
	}
	
	public function drawPolygon(verticies:Array, colour:Uint = 0xFF0000, alpha:Float = 1):Void 
	{
		var sprite:Sprite = new Sprite();
		var shape:IShape =  Polygon.fromArray(verticies, false);
		shape.render(sprite.graphics, colour, alpha, colour, 0);
		drawShape(sprite);
	}	
	
	public function onRender(canvasData:BitmapData = null):Void 
	{
	}		
	
	public function debugRender():Void 
	{
		if (owner.collider)
		{
			if (owner.transform.isOnscreen())
			{
				if (!debugSprite)
				{
					debugSprite = new Sprite();
					owner.collider.render(debugSprite);						
					debugBuffer = new BitmapData(debugSprite.width+1, debugSprite.height+1, true, 0x00000000);						
					var debugMatrix:Matrix = new Matrix();
					debugMatrix.translate(- owner.collider.offsetX + (owner.collider.bounds.width * 0.5),  - owner.collider.offsetY + (owner.collider.bounds.height * 0.5));		
					debugBuffer.draw(debugSprite, debugMatrix);
				}		
				
				var debugRect:Rectangle = new Rectangle(0, 0, debugBuffer.width, debugBuffer.height);
				var debugPos:PoInt = new PoInt();
				debugPos.x = owner.transform.x - HE.camera.x + owner.collider.offsetX - (owner.collider.bounds.width * 0.5);
				debugPos.y = owner.transform.y - HE.camera.y + owner.collider.offsetY - (owner.collider.bounds.height * 0.5);
				
				HE.world.debugData.copyPixels(debugBuffer, debugRect, debugPos, null, null, true);
			}
		}
	}
	
	public function play(animation:String):Void
	{
	}
	
	public function stop():Void 
	{			
	}
	
	public function flashColour(colour:Uint = 0xFFFFFF, duration:Float = 1, alpha:Float = 1, delay:Float = 0):Void
	{
		
	}
	
	public function tInt(colour:Uint = 0xFFFFFF, alpha:Float = 1):Void
	{
		
	}		
	
	public function setGraphic(image:Bitmap, width:Int = 0, height:Int = 0):Void 
	{
		var _w:Int = (width != 0) ? width : image.width;
		var _h:Int = (height != 0) ? height : image.height;			
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
	
	private function drawShape(sprite:Sprite):Void
	{
		_graphic.bitmapData = new BitmapData(sprite.width, sprite.height, true, 0x00000000);;
		_graphic.bitmapData.draw(sprite);			
		_bounds = _graphic.bitmapData.rect;			
		if (_isCentered)
		{
			_offsetX += -_graphic.bitmapData.width * 0.5;
			_offsetY += -_graphic.bitmapData.height * 0.5;
		}
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/			
	
	public function get graphic():Bitmap 					{	return _graphic; }		
		
	public function get alpha():Float 						{	return _alpha;}		
	public function set alpha(value:Float):Void 			{	_alpha = value;}
	
	public function get offsetX():Float 					{	return _offsetX;}		
	public function set offsetX(value:Float):Void 		{	_offsetX = value; }
	
	public function get offsetY():Float 					{	return _offsetY;}		
	public function set offsetY(value:Float):Void 		{	_offsetY = value; }
	
	
}