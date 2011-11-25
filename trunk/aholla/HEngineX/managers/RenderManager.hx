/**
 * ...
 * @author Adam
 */

package aholla.henginex.managers;

import aholla.henginex.core.entity.IRendererComponent;
import aholla.henginex.HE;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

class RenderManager 
{
	private var canvas							:Bitmap;
	private var canvasDebug						:Bitmap;
	private var canvasData						:BitmapData;
	private var canvasRect						:Rectangle;
	//private var componentDict					:Dictionary;
	private var componentList					:Array<IRendererComponent>;
	private var sortDepths						:Bool;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
	public function new(sortDepths:Bool = false) 
	{
		this.sortDepths = sortDepths;
		
		canvasRect 	= new Rectangle(0, 0, HE.SCREEN_WIDTH, HE.SCREEN_HEIGHT);
		canvasData 	= new BitmapData(Std.int(canvasRect.width), Std.int(canvasRect.height), false, 0xFF00FF);
		canvas 		= new Bitmap(canvasData);
		canvas.name = "canvas";
		HE.world.addChildAt(canvas, 0);			
		
		//componentDict = new Dictionary(true);
		componentList = [];
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	public function addRenderComponent(renderComponent:IRendererComponent):Void
	{		
		componentList.push(renderComponent);
		//componentDict[renderComponent] = renderComponent;			
	}
	
	public function removeRenderComponent(renderComponent:IRendererComponent):Void
	{
		var index:Int = Lambda.indexOf(componentList, renderComponent);
		if (index != -1)
			componentList.splice(index, 1);
		//delete componentDict[renderComponent];
	}
	
	public function onUpdate():Void
	{
		if(sortDepths)
			componentList.sort(sortDepth);
		
		//if (HE.isDebug)
		//{
			//HE.world.debugData.fillRect(new Rectangle(0, 0, HE.SCREEN_WIDTH, HE.SCREEN_HEIGHT), 0x00000000);
			//HE.world.debugLayer.x = -HE.camera.x;
			//HE.world.debugLayer.y = -HE.camera.y;
		//}
		
		canvasData.lock();
		canvasData.fillRect(canvasRect, 0x000000);				
		var len:Int = componentList.length;
		//for (var i:Int = 0; i < len; i++) 
		for (i in 0...len) 
		{
			var _renderer:IRendererComponent = componentList[i];
			_renderer.onRender(canvasData);
		}
		canvasData.unlock();
	}	
	
	public function destroy():Void
	{
		componentList = [];
	}
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
	
	private function sortDepth(renderA:IRendererComponent, renderB:IRendererComponent):Int 
	{
		return renderA.owner.transform.zIndex - renderB.owner.transform.zIndex;
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
	
	
}

