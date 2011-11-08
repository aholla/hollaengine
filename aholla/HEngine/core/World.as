/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core 
{	
	import aholla.HEngine.core.entity.IRendererComponent;
	import aholla.HEngine.HE;
	import flash.display.Sprite;
	
	public class World extends Sprite
	{
		private var _entityRenderArr				:Array = new Array();
		public var debugLayer						:Sprite;
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function World() 
		{
			name = "world";			
			updateWorldSize();
			debugLayer = new Sprite();
			debugLayer.name = "debugLayer";
			addChild(debugLayer);
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
			//addChild(debugLayer);
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
			if (HE.isDebug)
			{
				graphics.clear();
				graphics.beginFill(0xFF0000, 0.5);
				graphics.drawRect(0, 0, HE.WORLD_WIDTH,  HE.WORLD_HEIGHT);
				graphics.endFill();
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
		
		public function get entityRenderArr():Array {	return _entityRenderArr;}
		
		
	}
}