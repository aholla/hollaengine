/**
 * ...
 * @author Adam
 */
	
package aholla.HEngine.statemachine 
{
	
	public interface IStateMachine 
	{
		function changeState($newState:IState):void
		function update():void
		function revertState():void
		function destroy():void
		
		function get currState():IState;
		function get oldState():IState;
	}
	
}