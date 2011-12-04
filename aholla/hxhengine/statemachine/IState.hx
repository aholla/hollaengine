/**
* ...
* @author Adam
*/

package aholla.hxhengine.statemachine;

import aholla.hxhengine.core.entity.IComponent;

interface IState 
{
	function enter(stateMachine:IStateMachine, ownerComponent:IComponent):Void
	function update(ownerComponent:IComponent):Void
	function exit(ownerComponent:IComponent):Void
	function destroy():Void
}

