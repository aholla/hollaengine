/**
* ...
* @author Adam
*/

package aholla.HEngine.statemachine 
{
	import aholla.HEngine.core.entity.IComponent;
	
	public interface IState 
	{
		function enter($stateMachine:IStateMachine, $ownerComponent:IComponent):void
		function update($ownerComponent:IComponent):void
		function exit($ownerComponent:IComponent):void
		function destroy():void
	}
	
}