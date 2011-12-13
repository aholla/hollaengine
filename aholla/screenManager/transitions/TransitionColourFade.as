/**
 * ...
 * @author Adam
  * VERSION 0.0.1;
 */

package aholla.screenManager.transitions
{
	import aholla.screenManager.IScreen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TransitionColourFade extends Sprite implements ITransition
	{
		private var screen							:IScreen;
		private var replace							:Boolean;
		
		private var colour							:Sprite;
		private var duration						:Number;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function TransitionColourFade($screen:IScreen, $replace:Boolean, $width:int, $height:int, $colour:uint = 0x000000, $alpha:Number = 1, $duration:Number = 1) 
		{
			this.screen 	= $screen;
			this.replace 	= $replace;
			
			duration = $duration;
			
			colour = new Sprite();		
			colour.graphics.beginFill($colour, $alpha);
			colour.graphics.drawRect(0, 0, $width, $height);
			colour.graphics.endFill();
			colour.alpha = 0;
			addChild(colour);
		}		
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function transitionIn():void 
		{
			TweenNano.to(colour, duration, {alpha:1, onComplete:transitionInComplete});
		}
		
		public function transitionOut():void 
		{
			TweenNano.to(colour, duration, {alpha:0, onComplete:transitionOutComplete});
		}
		
		public function destroy():void
		{
			TweenNano.killTweensOf(colour);
			if (colour)
			{
				removeChild(colour);
				colour = null;
			}			
			this.screen = null;
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		private function transitionInComplete():void 
		{
			dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_IN_COMPLETE, screen, replace, this, true));
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