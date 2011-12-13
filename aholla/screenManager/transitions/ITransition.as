/**
 * ...
 * @author Adam
  * VERSION 0.0.1;
 * 
 * All transitions need to implement this interface.
 */

package aholla.screenManager.transitions
{	
	public interface ITransition 
	{	
		function transitionIn():void
		function transitionOut():void	
		function destroy():void	
		function addEventListener (type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		function removeEventListener (type:String, listener:Function, useCapture:Boolean = false):void;
	}	
}