/**
* ...
* @author Adam
*/

package aholla.hxhengine.core;

import aholla.hxhengine.core.entity.IRendererComponent;
import aholla.hxhengine.HE;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;

class World extends Sprite
{
	public var entityRenderArr(default, null)		:Array<IRendererComponent>;
	public var debugLayer(default, null)			:Sprite;
	public var debugData(default, null)				:BitmapData;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new() 
	{
		super();
		
		entityRenderArr = [];
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
	 * @param	renderer
	 */
	public function addEntityRender(renderer:IRendererComponent):Void
	{
		//addChild(renderer);			
		//if (entityRenderArr.indexOf(renderer) == -1)
		//{
			//entityRenderArr[entityRenderArr.length] = renderer;
		//}
		//addChild(debugLayer);
	}
	
	/**
	 * Remove the displayobject from teh array and from the stage.
	 * @param	renderer
	 */
	public function removeEntityRender(renderer:IRendererComponent):Void
	{
		//if (renderer)
		//{
			//if(contains(renderer))
				//removeChild(renderer);
			//entityRenderArr.splice(entityRenderArr.indexOf(renderer), 1);
		//}
	}
	
	/**
	 * Clears teh array of displayobjects and removed the holder from the stage.
	 */
	public function destroy():Void 
	{				
		while (numChildren > 0)
		{
			removeChildAt(0);
		}			
		entityRenderArr = [];
	}
	
	/**
	 * Clears the display objects in the array.
	 */
	public function restart():Void 
	{
		while (numChildren > 0)
		{
			removeChildAt(0);
		}
		entityRenderArr = [];
	}
	
	/**
	 * Draws a rectangle in the background.
	 */
	public function updateWorldSize():Void 
	{
		if (HE.isDebug)
		{
			graphics.clear();
			graphics.beginFill(0xFF0000, 1);
			graphics.drawRect(0, 0, HE.SCREEN_WIDTH,  HE.SCREEN_HEIGHT);
			graphics.endFill();
			
			if (debugData != null)
			{
				debugData.dispose();
				debugData = new BitmapData(HE.SCREEN_WIDTH, HE.SCREEN_HEIGHT, true, 0xFFFFFFF);
			}
		}
	}
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
	
	private function initDebugLayer():Void 
	{
		debugLayer = new Sprite();
		debugLayer.name = "debugLayer";
		addChild(debugLayer);
	}
	
	private function initDebugData():Void 
	{
		debugData = new BitmapData(HE.SCREEN_WIDTH, HE.SCREEN_HEIGHT, true, 0xFFFFFFF);
		addChild(new Bitmap(debugData));
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/		
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
	
	
}
