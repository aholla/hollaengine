/**
 * ...
 * @author Adam
 */
	
package aholla.henginex.statemachine;

import aholla.henginex.core.entity.IComponent;
import aholla.henginex.statemachine.IState;

class StateMachine implements IStateMachine
{
	private var ownerComponent					:IComponent;
	private var _currState						:IState;
	private var _oldState						:IState;
	
/*--------------------------------------------------
* PUBLIC CONSTRUCTOR
--------------------------------------------------*/
	
	public function new(ownerComponent:IComponent) 
	{
		ownerComponent = ownerComponent;
	}
	
/*-------------------------------------------------
* PUBLIC METHODS
-------------------------------------------------*/
	
	public function changeState(newState:IState):Void 
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
		
		_currState = newState;
		_currState.enter(this, ownerComponent);
	}
	
	public function update():Void 
	{
		_currState.update(ownerComponent);
	}
	
	public function revertState():Void 
	{
		changeState(oldState);
	}
	
	public function destroy():Void
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
