/**
 * ...
 * @author Adam
 */

package aholla.screenManager.transitions 
{
	import aholla.screenManager.IScreen;
	import flash.events.Event;	
	
	public class TransitionEvent extends Event 
	{
		public static const TRANSITION_IN_COMPLETE	:String = "transition_in_complete";
		public static const TRANSITION_OUT_COMPLETE	:String = "transition_out_complete";
		
		public var screen			:IScreen;
		public var replace			:Boolean;
		public var transition		:ITransition;
		
		public function TransitionEvent(type:String, screen:IScreen, replace:Boolean, transition:ITransition, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.screen 	= screen;
			this.transition = transition;
			this.replace	= replace;
		} 
		
		public override function clone():Event 
		{ 
			return new TransitionEvent(type, screen, replace, transition, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TransitionEvent", "type", "screen", "replace", "transition", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}	
}