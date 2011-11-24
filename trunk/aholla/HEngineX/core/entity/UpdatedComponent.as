/**
 * ...
 * @author Adam
 */

package aholla.HEngine.core.entity  
{
	import aholla.HEngine.core.entity.IEntity;
	import aholla.HEngine.HE;
	
	public class UpdatedComponent extends Component implements IUpdatedComponent	
	{
		private var isStarted						:Boolean;
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function UpdatedComponent() 
		{
		}		
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		override public function onAdded($owner:IEntity, $name:String):void 
		{
			super.onAdded($owner, $name);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
		}
		
		override public function start():void 
		{			
			if (!isActive)
			{
				HE.processManager.addUpdatedComponent(this);
				super.start();
			}
		}
		
		override public function destroy():void 
		{
         	HE.processManager.removeUpdatedComponent(this);
			super.destroy();
		}
		
		override public function onPause():void 
		{
			super.onPause();
		}
		
		override public function onUnPause():void 
		{
			super.onUnPause();
		}
		
		public function onUpdate():void 
		{
			
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
		
		
	}
}