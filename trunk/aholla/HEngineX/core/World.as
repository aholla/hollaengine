/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core 
{	
	import aholla.HEngine.core.entity.IRendererComponent;
	import aholla.HEngine.HE;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class World extends Sprite
	{
		private var _entityRenderArr				:Array = new Array();
		private var _debugLayer						:Sprite;
		private var _debugData						:BitmapData;
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function World() 
		{
			name = "world";			
			updateWorldSize();
			
			if (HE.isDebug)
			{
				initDebugLayer();
				initDebugData();				
			}
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Add the entites display object to the world/stage. Also adds it to an 
		 * arrary so the ProcessManager can process the depths if needed.
		 * @param	$renderer
		 */
		public function addEntityRender($renderer:*):void
		{
			//addChild($renderer);			
			//if (_entityRenderArr.indexOf($renderer) == -1)
			//{
				//_entityRenderArr[_entityRenderArr.length] = $renderer;
			//}
			//addChild(_debugLayer);
		}
		
		/**
		 * Remove the displayobject from teh array and from the stage.
		 * @param	$renderer
		 */
		public function removeEntityRender($renderer:*):void
		{
			//if ($renderer)
			//{
				//if(contains($renderer))
					//removeChild($renderer);
				//_entityRenderArr.splice(_entityRenderArr.indexOf($renderer), 1);
			//}
		}
		
		/**
		 * Clears teh array of displayobjects and removed the holder from the stage.
		 */
		public function destroy():void 
		{				
			while (numChildren > 0)
			{
				removeChildAt(0);
			}			
			_entityRenderArr = [];
		}
		
		/**
		 * Clears the display objects in the array.
		 */
		public function restart():void 
		{
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			_entityRenderArr = [];
		}
		
		/**
		 * Draws a rectangle in the background.
		 */
		public function updateWorldSize():void 
		{
			trace(this, "updateWorldSize");
			if (HE.isDebug)
			{
				graphics.clear();
				graphics.beginFill(0xFF0000, 1);
				graphics.drawRect(0, 0, HE.SCREEN_WIDTH,  HE.SCREEN_HEIGHT);
				graphics.endFill();
				
				if (_debugData)
				{
					_debugData.dispose();
					_debugData = new BitmapData(HE.SCREEN_WIDTH, HE.SCREEN_HEIGHT, true, 0x00000000);
				}
			}
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		private function initDebugLayer():void 
		{
			_debugLayer = new Sprite();
			_debugLayer.name = "_debugLayer";
			addChild(_debugLayer);
		}
		
		private function initDebugData():void 
		{
			_debugData = new BitmapData(HE.SCREEN_WIDTH, HE.SCREEN_HEIGHT, true, 0x00000000);
			addChild(new Bitmap(_debugData));
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		public function get entityRenderArr():Array {	return _entityRenderArr;}
		
		public function get debugLayer():Sprite 
		{
			if (!_debugLayer)
				initDebugLayer();
			return _debugLayer;
		}
		
		public function get debugData():BitmapData 
		{
			if (!_debugData)
				initDebugData();
			return _debugData;
		}
		

		
		
	}
}