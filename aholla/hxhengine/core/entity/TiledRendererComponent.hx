/**
* ...
* @author Adam
*/

package aholla.hxhengine.core.entity;


import aholla.hxhengine.core.Camera;
import aholla.hxhengine.HE;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.geom.Point;
import flash.geom.Rectangle;

class TiledRendererComponent extends RendererComponent, implements ITiledRender
{
	public var map										:Array<Array<Int>>;
		
	private var tilesheetData							:BitmapData;
	//private var tileSheetDisplay						:Bitmap;
	private var tileSource								:BitmapData;			
	//private var _y										:Float = 0;		
	private var zIndex									:Int;			
	private var layerIndex								:Int;		
	private var tileW									:Int;
	private var tileH									:Int;		
	private var screenW									:Int;		
	private var screenH									:Int;		
	private var screenColumns							:Int;
	private var screenRows								:Int;
	private var mapWidth								:Int;
	private var mapHeight								:Int;
	private var mapColumns								:Int;
	private var mapRows									:Int;		
	private var row										:Int;
	private var col										:Int;		
	private var tileIndex								:Int;
	private var tileRect								:Rectangle;
	private var tilePos									:Point;
	private var tilesPerSheet							:Int;			
	private var bufferRect								:Rectangle;		
	private var minCol									:Int;
	private var maxCol									:Int;
	private var minRow									:Int;
	private var maxRow									:Int;		
	//private var camera									:Camera;		
	private var isScrolling								:Bool;		
	private var tilesheetPos							:Point;
	private var tilesheetOffset							:Point;
	
	private var isBlitted								:Bool;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new(isBlitted:Bool = true) 
	{
		this.isBlitted = isBlitted;
		super();
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	public function initTilesheet(map:Array<Array<Int>>, tilesheet:BitmapData, tileW:Int, tileH:Int, x:Int = 0, y:Int = 0):Void
	{
		this.map = map;
		this.tileW = tileW;
		this.tileH = tileH;
		tileSource	= tilesheet;
		
		tilesheetPos 	= new Point(x, y);
		tilesheetOffset = new Point(Std.int(tilesheetPos.x / tileW), Std.int(tilesheetPos.y / tileH));
		
		screenW = HE.SCREEN_WIDTH;
		screenH = HE.SCREEN_HEIGHT;
		tilesheetData = new BitmapData(screenW, screenH);
		
		//------------------------
		// DISPLAY LIST
		//tileSheetDisplay = new Bitmap(tilesheetData);
		//_display.addChild(tileSheetDisplay);
		//------------------------
		
		mapWidth = map[0].length * tileW;
		mapHeight = map.length * tileH;
		
		tileRect = new Rectangle();
		tilePos = new Point();
		
		tilesPerSheet = Std.int(tileSource.width / tileW);
		
		mapColumns 	= Std.int(mapWidth / tileW);			
		mapRows 	= Std.int(mapHeight / tileH);
		row = 0;			
		col = 0;
		
		layerIndex = 0;
		zIndex = 0;
		zIndex = (layerIndex + 1);// * _y;
		
		camera = HE.camera;
		
		bufferRect = new Rectangle(0, 0, screenW, screenH);
		
		if (mapWidth > screenW || mapHeight > screenH)
			isScrolling = true;
		
	}
	
	override public function onRender(canvasData:BitmapData = null):Void
	{
		screenColumns 	= Math.ceil(screenW / tileW);
		screenRows 		= Math.ceil(screenH / tileH);
		
		minCol = Std.int((camera.x / tileW) - tilesheetOffset.x);
		maxCol = Std.int(minCol + tilesheetOffset.x + screenColumns) + 1;
		minCol = Std.int(Math.max(0, Math.min(mapColumns, minCol)));
		maxCol = Std.int(Math.max(0, Math.min(mapColumns, maxCol)));			
		
		minRow = Std.int((camera.y / tileH) - tilesheetOffset.y);
		maxRow = Std.int(minRow + tilesheetOffset.y + screenRows) + 1;
		minRow = Std.int(Math.max(0, Math.min(mapRows, minRow)));
		maxRow = Std.int(Math.max(0, Math.min(mapRows, maxRow)));			
		
		tilesheetData.lock();
		tilesheetData.fillRect(bufferRect, 0xFF0000);
		
		//for (row = minRow; row < maxRow; row++) 
		row = minRow;
		for (row in minRow...maxRow) 
		{
			//for (col = minCol; col < maxCol; col++) 
			col = minCol;
			for(col in minCol...maxCol)
			{
				tileIndex = Std.int(map[row][col]);					
				
				tileRect.x = Std.int((tileIndex % tilesPerSheet)) * tileW;
				tileRect.y = Std.int((tileIndex / tilesPerSheet)) * tileH;					
				tileRect.width = tileW;
				tileRect.height = tileH;					
				tilePos.x = (col * tileW) - camera.x + tilesheetPos.x;				
				tilePos.y = (row * tileH) - camera.y + tilesheetPos.y;					
				tilesheetData.copyPixels(tileSource, tileRect, tilePos);
			}
		}
		tilesheetData.unlock();	
		
		tilePos.x = tilePos.y = 0;
		canvasData.copyPixels(tilesheetData, bufferRect, tilePos, null, null, true);
		//_display.zIndex = zIndex;
	}
	
	override public function destroy():Void 
	{
		tilesheetData.dispose();			
		//_display.removeChild(tileSheetDisplay);
		
		tileSource.dispose();
		
		tilesheetData 		= null;
		//tileSheetDisplay 	= null;
		tileSource 			= null;
		
		super.destroy();
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
	/*
	public function get y():Float 		
	{			
		return _y;		
	}
	
	public function set y(value:Float):Void
	{
		_y = value;
		//_display.y = _y;
		_zIndex = (_layerIndex + 1) *  _y;
		//_display.zIndex = _zIndex;
	}
	
	public function get layerIndex():Float 
	{
		return _layerIndex;
	}
	
	public function set layerIndex(value:Float):Void 
	{
		_layerIndex = value;
	}
	
	*/
}








