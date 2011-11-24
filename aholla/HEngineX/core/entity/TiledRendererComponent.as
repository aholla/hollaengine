/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity 
{	
	
	import aholla.HEngine.core.Camera;
	import aholla.HEngine.HE;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class TiledRendererComponent extends RendererComponent implements ITiledRender
	{
		public var map										:Array;
			
		private var tilesheetData							:BitmapData;
		//private var tileSheetDisplay						:Bitmap;
		private var tileSource								:BitmapData;			
		private var _y										:Number = 0;		
		private var _zIndex									:Number = 0;			
		private var _layerIndex								:Number = 0;		
		private var tileW									:int;
		private var tileH									:int;		
		private var screenW									:int;		
		private var screenH									:int;		
		private var screenColumns							:int;
		private var screenRows								:int;
		private var mapWidth								:int;
		private var mapHeight								:int;
		private var mapColumns								:int;
		private var mapRows									:int;		
		private var row										:int;
		private var col										:int;		
		private var tileIndex								:int;
		private var tileRect								:Rectangle;
		private var tilePos									:Point;
		private var tilesPerSheet							:int;			
		private var bufferRect								:Rectangle;		
		private var minCol									:int;
		private var maxCol									:int;
		private var minRow									:int;
		private var maxRow									:int;		
		//private var camera									:Camera;		
		private var isScrolling								:Boolean;		
		private var tilesheetPos							:Point;
		private var tilesheetOffset							:Point;
		
		private var isBlitted								:Boolean;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function TiledRendererComponent(isBlitted:Boolean = true) 
		{
			this.isBlitted = isBlitted;
			super();
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function initTilesheet($map:Array, $tilesheet:BitmapData, $tileW:int, $tileH:int, $x:int = 0, $y:int = 0):void
		{
			map = $map;
			tileW = $tileW;
			tileH = $tileH;
			tileSource	= $tilesheet;
			
			tilesheetPos 	= new Point($x, $y);
			tilesheetOffset = new Point(int(tilesheetPos.x / tileW), int(tilesheetPos.y / tileH));
			
			screenW = HE.SCREEN_WIDTH;
			screenH = HE.SCREEN_HEIGHT;
			tilesheetData = new BitmapData(screenW, screenH);
			
			//tileSheetDisplay = new Bitmap(tilesheetData);
			//_display.addChild(tileSheetDisplay);
			
			mapWidth = map[0].length * $tileW;
			mapHeight = map.length * $tileH;
			
			tileRect = new Rectangle();
			tilePos = new Point();
			
			tilesPerSheet = tileSource.width / $tileW;
			
			mapColumns 	= int(mapWidth / tileW);			
			mapRows 	= int(mapHeight / tileH);
			row = 0;			
			col = 0;
			
			_zIndex = (_layerIndex + 1) * _y;
			
			camera = HE.camera;
			
			bufferRect = new Rectangle(0, 0, screenW, screenH);
			
			if (mapWidth > screenW || mapHeight > screenH)
				isScrolling = true;
			
		}
		
		override public function onRender(canvasData:BitmapData = null):void
		{
			screenColumns 	= Math.ceil(screenW / tileW);
			screenRows 		= Math.ceil(screenH / tileH);
			
			minCol = int(camera.x / tileW) - tilesheetOffset.x;
            maxCol = minCol + tilesheetOffset.x + screenColumns + 1;
            minCol = Math.max(0, Math.min(mapColumns, minCol));
            maxCol = Math.max(0, Math.min(mapColumns, maxCol));			
			
            minRow = int(camera.y / tileH) - tilesheetOffset.y;
            maxRow = minRow + tilesheetOffset.y + screenRows + 1;
            minRow = Math.max(0, Math.min(mapRows, minRow));
            maxRow = Math.max(0, Math.min(mapRows, maxRow));			
			
			tilesheetData.lock();
			tilesheetData.fillRect(bufferRect, 0xFF0000);
			
			for (row = minRow; row < maxRow; row++) 
			{
				for (col = minCol; col < maxCol; col++) 
				{
					tileIndex = map[row][col];					
					
					tileRect.x = int((tileIndex % tilesPerSheet)) * tileW;
					tileRect.y = int((tileIndex / tilesPerSheet)) * tileH;					
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
		
		override public function destroy():void 
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
		
		public function get y():Number 		
		{			
			return _y;		
		}
		
		public function set y(value:Number):void
		{
			_y = value;
			//_display.y = _y;
			_zIndex = (_layerIndex + 1) *  _y;
			//_display.zIndex = _zIndex;
		}
		
		public function get layerIndex():Number 
		{
			return _layerIndex;
		}
		
		public function set layerIndex(value:Number):void 
		{
			_layerIndex = value;
		}
		
	}
}








