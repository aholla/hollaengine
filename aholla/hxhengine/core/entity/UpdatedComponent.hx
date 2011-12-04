/**
* ...
* @author Adam
*/

package aholla.hxhengine.core.entity;

import aholla.hxhengine.core.entity.IEntity;
import aholla.hxhengine.HE;

class UpdatedComponent extends Component, implements IUpdatedComponent	
{
	private var isStarted						:Bool;
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new() 
	{
		super();
	}		
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	override public function onAdded(owner:IEntity, name:String):Void 
	{
		super.onAdded(owner, name);
	}
	
	override public function onRemove():Void
	{
		super.onRemove();
	}
	
	override public function start():Void 
	{			
		if (!isActive)
		{
			HE.processManager.addUpdatedComponent(this);
			super.start();
		}
	}
	
	override public function destroy():Void 
	{
		HE.processManager.removeUpdatedComponent(this);
		super.destroy();
	}
	
	override public function onPause():Void 
	{
		super.onPause();
	}
	
	override public function onUnPause():Void 
	{
		super.onUnPause();
	}
	
	public function onUpdate():Void 
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