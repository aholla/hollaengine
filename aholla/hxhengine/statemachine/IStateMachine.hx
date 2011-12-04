/**
 * ...
 * @author Adam
 */
	
package aholla.hxhengine.statemachine;


interface IStateMachine 
{
	function changeState(newState:IState):Void
	function update():Void
	function revertState():Void
	function destroy():Void
	
	function get currState():IState;
	function get oldState():IState;
}

