/**
 * ...
 * @author Adam
 */

package aholla.HEngine.managers 
{
	import aholla.HEngine.core.entity.IRendererComponent;
	import aholla.HEngine.HE;
	import de.polygonal.ds.SLL;
	import de.polygonal.ds.SLLNode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class RenderManager 
	{
		private var canvas							:Bitmap;
		private var canvasDebug						:Bitmap;
		private var canvasData						:BitmapData;
		private var canvasDebugData					:BitmapData;
		private var canvasRect						:Rectangle;
		private var componentDict					:Dictionary;
		private var componentList					:SLL;
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
			componentList = new SLL();	
			
			if (HE.isDebug)
				initDebug();
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function addRenderComponent($renderComponent:IRendererComponent):void
		{
			var node:SLLNode = componentList.append($renderComponent);
			componentDict[$renderComponent] = node;			
		}
		
		public function removeRenderComponent($renderComponent:IRendererComponent):void
		{
			(componentDict[$renderComponent] as SLLNode).free();
			(componentDict[$renderComponent] as SLLNode).unlink();
			delete componentDict[$renderComponent];
		}
		
		public function onUpdate():void
		{
			if(sortDepths)
				componentList.sort(sortDepth, true);
			
			canvasData.lock();
			canvasData.fillRect(canvasRect, 0x000000);			
			var head:SLLNode = componentList.head;
			while (head)
			{
				(head.val as IRendererComponent).render(canvasData);
				head = head.next;
			}			
			canvasData.unlock();
			
			// If debug, do anotehr loop and render the debug layer.
			if (HE.isDebug)
			{
				if (!canvasDebugData)
					initDebug();
					
				canvasDebugData.lock();
				canvasDebugData.fillRect(canvasRect, 0x000000);				
				head = componentList.head;
				while (head)
				{
					(head.val as IRendererComponent).debugRender(canvasDebugData);
					head = head.next;
				}
				
				var debugPos:Point = new Point(- HE.camera.x, -HE.camera.y)
				canvasData.copyPixels(canvasDebugData, canvasRect, debugPos, null, null, true);
				canvasDebugData.unlock();
			}
		}	
		
		private function initDebug():void 
		{
			canvasDebugData = new BitmapData(canvasRect.width, canvasRect.height, true, 0xFF00FF);			
			canvasDebug = new Bitmap(canvasDebugData);
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