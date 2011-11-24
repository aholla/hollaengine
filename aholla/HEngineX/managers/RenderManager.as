/**
 * ...
 * @author Adam
 */

package aholla.HEngine.managers 
{
	import aholla.HEngine.core.entity.IRendererComponent;
	import aholla.HEngine.HE;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class RenderManager 
	{
		private var canvas							:Bitmap;
		private var canvasDebug						:Bitmap;
		private var canvasData						:BitmapData;
		private var canvasRect						:Rectangle;
		private var componentDict					:Dictionary;
		private var componentList					:Vector.<IRendererComponent>;
		private var sortDepths						:Boolean;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function RenderManager($sortDepths:Boolean = false) 
		{
			sortDepths = $sortDepths;
			
			canvasRect 	= new Rectangle(0, 0, HE.SCREEN_WIDTH, HE.SCREEN_HEIGHT);
			canvasData 	= new BitmapData(canvasRect.width, canvasRect.height, false, 0xFF00FF);
			canvas 		= new Bitmap(canvasData);
			canvas.name = "canvas";
			HE.world.addChildAt(canvas, 0);			
			
			componentDict = new Dictionary(true);
			componentList = new Vector.<IRendererComponent>;
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function addRenderComponent($renderComponent:IRendererComponent):void
		{		
			componentList.push($renderComponent);
			componentDict[$renderComponent] = $renderComponent;			
		}
		
		public function removeRenderComponent($renderComponent:IRendererComponent):void
		{
			var index:int = componentList.indexOf($renderComponent);
			if (index != -1)
				componentList.splice(index, 1);
			delete componentDict[$renderComponent];
		}
		
		public function onUpdate():void
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
			var len:int = componentList.length;
			for (var i:int = 0; i < len; i++) 
			{
				var _renderer:IRendererComponent = componentList[i] as IRendererComponent;
				_renderer.onRender(canvasData);
			}
			canvasData.unlock();
		}	
		
		public function destroy():void
		{
			componentList = new Vector.<IRendererComponent>;
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		private function sortDepth($renderA:IRendererComponent, $renderB:IRendererComponent):int 
		{
			return $renderA.owner.transform.zIndex - $renderB.owner.transform.zIndex;
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		
	}

}