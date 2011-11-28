/**
* ...
* @author Adam
*/

package aholla.henginex.core.entity;


import aholla.henginex.core.Camera;
import aholla.henginex.HE;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.geom.PoInt;
import flash.geom.Rectangle;

class TiledRendererComponent extends RendererComponent, implements ITiledRender
{
	public var map										:Array;
		
	private var tilesheetData							:BitmapData;
	//private var tileSheetDisplay						:Bitmap;
	private var tileSource								:BitmapData;			
	private var _y										:Float = 0;		
	private var _zIndex									:Float = 0;			
	private var _layerIndex								:Float = 0;		
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
	private var tilePos									:PoInt;
	private var tilesPerSheet							:Int;			
	private var bufferRect								:Rectangle;		
	private var minCol									:Int;
	private var maxCol									:Int;
	private var minRow									:Int;
	private var maxRow									:Int;		
	//private var camera									:Camera;		
	private var isScrolling								:Bool;		
	private var tilesheetPos							:PoInt;
	private var tilesheetOffset							:PoInt;
	
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
	
	public function initTilesheet(map:Array, tilesheet:BitmapData, tileW:Int, tileH:Int, x:Int = 0, y:Int = 0):Void
	{
		map = map;
		tileW = tileW;
		tileH = tileH;
		tileSource	= tilesheet;
		
		tilesheetPos 	= new PoInt(x, y);
		tilesheetOffset = new PoInt(Int(tilesheetPos.x / tileW), Int(tilesheetPos.y / tileH));
		
		screenW = HE.SCREEN_WIDTH;
		screenH = HE.SCREEN_HEIGHT;
		tilesheetData = new BitmapData(screenW, screenH);
		
		//tileSheetDisplay = new Bitmap(tilesheetData);
		//_display.addChild(tileSheetDisplay);
		
		mapWidth = map[0].length * tileW;
		mapHeight = map.length * tileH;
		
		tileRect = new Rectangle();
		tilePos = new PoInt();
		
		tilesPerSheet = tileSource.width / tileW;
		
		mapColumns 	= Int(mapWidth / tileW);			
		mapRows 	= Int(mapHeight / tileH);
		row = 0;			
		col = 0;
		
		_zIndex = (_layerIndex + 1) * _y;
		
		camera = HE.camera;
		
		bufferRect = new Rectangle(0, 0, screenW, screenH);
		
		if (mapWidth > screenW || mapHeight > screenH)
			isScrolling = true;
		
	}
	
	override public function onRender(canvasData:BitmapData = null):Void
	{
		screenColumns 	= Math.ceil(screenW / tileW);
		screenRows 		= Math.ceil(screenH / tileH);
		
		minCol = Int(camera.x / tileW) - tilesheetOffset.x;
		maxCol = minCol + tilesheetOffset.x + screenColumns + 1;
		minCol = Math.max(0, Math.min(mapColumns, minCol));
		maxCol = Math.max(0, Math.min(mapColumns, maxCol));			
		
		minRow = Int(camera.y / tileH) - tilesheetOffset.y;
		maxRow = minRow + tilesheetOffset.y + screenRows + 1;
		minRow = Math.max(0, Math.min(mapRows, minRow));
		maxRow = Math.max(0, Math.min(mapRows, maxRow));			
		
		tilesheetData.lock();
		tilesheetData.fillRect(bufferRect, 0xFF0000);
		
		//for (row = minRow; row < maxRow; row++) 
		for (row = minRow in row ...  maxRow) 
		{
			//for (col = minCol; col < maxCol; col++) 
			for(col = minCol in col ... maxCOL)
			{
				tileIndex = map[row][col];					
				
				tileRect.x = Int((tileIndex % tilesPerSheet)) * tileW;
				tileRect.y = Int((tileIndex / tilesPerSheet)) * tileH;					
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
		//_display.zIndex = _zIndex;
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








