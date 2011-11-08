/**
 * ...
 * @author Adam
 */
	
package aholla.HEngine.statemachine 
{
	import aholla.HEngine.core.entity.IComponent;
	import aholla.HEngine.statemachine.IState;

	public class StateMachine implements IStateMachine
	{
		private var ownerComponent					:IComponent;
		private var _currState						:IState;
		private var _oldState						:IState;
		
/*--------------------------------------------------
* PUBLIC CONSTRUCTOR
--------------------------------------------------*/
		
		public function StateMachine($ownerComponent:IComponent) 
		{
			ownerComponent = $ownerComponent;
		}
		
/*-------------------------------------------------
* PUBLIC METHODS
-------------------------------------------------*/
		
		public function changeState($newState:IState):void 
		{
			if (_oldState)
			{
				_oldState.destroy();
				_oldState = null;
			}
			
			if (_currState)
			{				
				_oldState = _currState;
				_currState.exit(ownerComponent);
			}
			
			_currState = $newState;
			_currState.enter(this, ownerComponent);
		}
		
		public function update():void 
		{
			_currState.update(ownerComponent);
		}
		
		public function revertState():void 
		{
			changeState(oldState);
		}
		
		public function destroy():void
		{
			ownerComponent = null;
			_oldState = null;
			_currState = null;
		}	
		
/*-------------------------------------------------
* PRIVATE METHODS
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		public function get currState():IState 	{		return _currState;	}		
		public function get oldState():IState 	{		return _oldState;	}
		
	}	
}