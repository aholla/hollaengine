/**
 * ...
 * @author Adam
 */

package  aholla.screenManager.transitions
{
	import aholla.screenManager.IScreen;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TransitionFadeIn extends Sprite implements ITransition
	{
		private var screen							:IScreen;
		private var replace							:Boolean;
		private var duration						:Number;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function TransitionFadeIn($screen:IScreen, $replace:Boolean, $duration:Number = 1) 
		{
			this.screen = $screen;
			this.replace = $replace;
			
			duration = $duration;
			screen.alpha = 0;
		}		
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function transitionIn():void 
		{
			dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_IN_COMPLETE, screen, replace, this));	
			TweenNano.to(screen, duration, {alpha:1, onComplete:transitionOutComplete});
		}
		
		public function transitionOut():void 
		{
		}
		
		public function destroy():void
		{
			TweenNano.killTweensOf(screen);
			this.screen = null;		
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		private function transitionInComplete():void 
		{
			dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_IN_COMPLETE, screen, replace, this));
		}
		
		private function transitionOutComplete():void 
		{
			dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_OUT_COMPLETE, screen, replace, this));
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/		

/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		
	}
}