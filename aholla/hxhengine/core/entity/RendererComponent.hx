/**
* ...
* @author Adam
*/

package aholla.hxhengine.core.entity;

import aholla.hxhengine.collision.shapes.Box;
import aholla.hxhengine.collision.shapes.Circle;
import aholla.hxhengine.collision.shapes.IShape;
import aholla.hxhengine.collision.shapes.Polygon;
import aholla.hxhengine.core.Camera;
import aholla.hxhengine.core.entity.IEntity;
import aholla.hxhengine.HE;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;	

class RendererComponent extends Component, implements IRendererComponent
{			
	public var graphic(default, null)				:Bitmap;
	public var bounds								:Rectangle;		
	public var alpha(getAlpha, setAlpha)			:Float;
	public var offsetX								:Float;
	public var offsetY								:Float;
	public var isCentered							:Bool;
	public var colourTransform						:ColorTransform;
	public var camera								:Camera; 
	public var debugSprite							:Sprite;
	public var debugBuffer							:BitmapData;
	//public var map									:Spritemap;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new() 
	{
		super();
		
		camera = HE.camera;		
		graphic = new Bitmap();
		bounds = new Rectangle();			
		offsetX = offsetY = 1;			
		isCentered = true;
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
	
	public function drawBox(width:Int, height:Int, colour:UInt = 0xFF0000, alpha:Float = 1):Void
	{
		var sprite:Sprite = new Sprite();
		var shape:IShape = new Box(width, height, false);
		shape.render(sprite.graphics, colour, alpha, colour, 0);			
		drawShape(sprite);
	}
	
	public function drawCircle(radius:Int, colour:UInt = 0xFF0000, alpha:Float = 1):Void
	{			
		var sprite:Sprite = new Sprite();			
		var shape:IShape =  new Circle(radius, radius, radius);
		shape.render(sprite.graphics, colour, alpha, colour, 0);			
		drawShape(sprite);
	}
	
	public function drawPolygon(verticies:Array<Point>, colour:UInt = 0xFF0000, alpha:Float = 1):Void 
	{
		var sprite:Sprite = new Sprite();
		var shape:IShape =  Polygon.fromArray(verticies, false);
		shape.render(sprite.graphics, colour, alpha, colour, 0);
		drawShape(sprite);
	}	
	
	public function onRender(canvasData:BitmapData = null):Void 
	{
		if (HE.isDebug)
			debugRender();
	}		
	
	public function debugRender():Void 
	{
		if (owner.collider != null)
		{
			if (owner.transform.isOnscreen())
			{
				/*
				if (debugSprite == null)
				{
					debugSprite = new Sprite();
					owner.collider.render(debugSprite);	
					
					debugBuffer = new BitmapData(Std.int(debugSprite.width)+1, Std.int(debugSprite.height)+1, true, 0x00000000);						
					
					
					//trace(( - owner.collider.offsetX + (owner.collider.bounds.width * 0.5)) + " : " + owner.collider.offsetX +  " : " +(owner.collider.bounds.width * 0.5));
					//trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX " + ( - owner.collider.offsetX + (owner.collider.bounds.width * 0.5)));
						
					var debugMatrix:Matrix = new Matrix();
					debugMatrix.translate(- (owner.collider.offsetX + (owner.collider.bounds.width * 0.5)),  - owner.collider.offsetY + (owner.collider.bounds.height * 0.5));		
					debugBuffer.draw(debugSprite, debugMatrix);
				}		
				
				var debugRect:Rectangle = new Rectangle(0, 0, debugBuffer.width, debugBuffer.height);
				var debugPos:Point = new Point();
				debugPos.x = owner.transform.x - HE.camera.x + owner.collider.offsetX - (owner.collider.bounds.width * 0.5);
				debugPos.y = owner.transform.y - HE.camera.y + owner.collider.offsetY - (owner.collider.bounds.height * 0.5);
				
				HE.world.debugData.copyPixels(debugBuffer, debugRect, debugPos, null, null, true);
				//HE.world.debugData.draw(debugSprite);
				*/
				/*
				if (debugSprite == null)
				{
					debugSprite = new Sprite();
					owner.collider.render(debugSprite);						
					debugBuffer = new BitmapData(Std.int(debugSprite.width)+1, Std.int(debugSprite.height)+1, true, 0x00000000);						
					var debugMatrix:Matrix = new Matrix();
					
					//trace(( - owner.collider.offsetX + (owner.collider.bounds.width * 0.5)));
					
					debugMatrix.translate(- owner.collider.offsetX + (owner.collider.bounds.width * 0.5),  - owner.collider.offsetY + (owner.collider.bounds.height * 0.5));		
					debugBuffer.draw(debugSprite, debugMatrix);
				}		
					
				var debugRect:Rectangle = new Rectangle(0, 0, debugBuffer.width, debugBuffer.height);
				var debugPos:Point = new Point();
				debugPos.x = owner.transform.x - HE.camera.x + owner.collider.offsetX - (owner.collider.bounds.width * 0.5);
				debugPos.y = owner.transform.y - HE.camera.y + owner.collider.offsetY - (owner.collider.bounds.height * 0.5);
				
				HE.world.debugData.copyPixels(debugBuffer, debugRect, debugPos, null, null, true);
				*/
			}
			
		}
	}
	
	public function play(animation:String):Void
	{
	}
	
	public function stop():Void 
	{			
	}
	
	public function flashColour(colour:UInt = 0xFFFFFF, duration:Float = 1, alpha:Float = 1, delay:Float = 0):Void
	{
		
	}
	
	public function tint(colour:UInt = 0xFFFFFF, alpha:Float = 1):Void
	{
		
	}		
	
	public function setGraphic(image:Bitmap, width:Int = 0, height:Int = 0):Void 
	{
		var _w:Int = (width != 0) ? width : Std.int(image.width);
		var _h:Int = (height != 0) ? height : Std.int(image.height);			
		graphic = image;			
		
		if (isCentered)	
		{
			offsetX = -_w * 0.5;
			offsetY = -_h * 0.5;
			bounds = new Rectangle(0, 0, _w, _h);
		}
		else
		{
			bounds = new Rectangle(0, 0, _w, _h);
		}		
	}	
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
	
	private function drawShape(sprite:Sprite):Void
	{
		graphic.bitmapData = new BitmapData(Std.int(sprite.width), Std.int(sprite.height), true, 0x00000000);
		graphic.bitmapData.draw(sprite);			
		bounds = graphic.bitmapData.rect;			
		if (isCentered)
		{
			offsetX += -graphic.bitmapData.width * 0.5;
			offsetY += -graphic.bitmapData.height * 0.5;
		}
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/			
	
	private function getAlpha():Float
	{
		return alpha;
	}
	
	private function setAlpha(value:Float):Float
	{
		return value;
	}
	
	
}