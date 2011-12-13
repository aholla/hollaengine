/**
 * TODO: ScreenManager - A lot of this code seems strange. transitions seen to do crazy thing. Needs better intergration.
 * @author Adam
 * VERSION 0.0.1;
 */

package aholla.screenManager
{
	import aholla.screenManager.transitions.ITransition;
	import aholla.screenManager.transitions.TransitionColourFade;
	import aholla.screenManager.transitions.TransitionEvent;
	import flash.display.Sprite;

	public class ScreenManager
	{
		//static public  const TRANSITION_COMPLETE	:String = "transition_complete"
		
		private static var 	_instance				:ScreenManager;
		private static var 	_allowInstance			:Boolean;
		
		public var display							:Sprite;		
		private var screensVec						:Vector.<IScreen> 		= new Vector.<IScreen>();
		private var transitionVec					:Vector.<ITransition> 	= new Vector.<ITransition>();
		private var currentScreen					:IScreen
		private var colourOverlay					:ITransition;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function ScreenManager() 
		{
			if (!ScreenManager._allowInstance)
			{
				throw new Error("Error: Use Core.screen_manager instead of the new keyword.");
			}
			display = new Sprite();
		}
		
		public static function get inst():ScreenManager
		{
			if (ScreenManager._instance == null)
			{
				ScreenManager._allowInstance		= true;
				ScreenManager._instance				= new ScreenManager();
				ScreenManager._allowInstance		= false;
			}
			return ScreenManager._instance;
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function addScreen($screen:IScreen, $replace:Boolean = true, $transition:ITransition = null):void 
		{
			
			if ($transition != null) 
			{
				transitionVec.push($transition);
				display.addChild($transition as Sprite);
				$transition.addEventListener(TransitionEvent.TRANSITION_IN_COMPLETE, onTransitionInComplete, false, 0, true);
				$transition.addEventListener(TransitionEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete, false, 0, true);
				$transition.transitionIn();
				return;
			}
			else
			{			
				showScreen($screen, $replace);
			}
		}
		
		
		public function removeScreen($screen:IScreen):void
		{
			var _found:Boolean; 
			for (var i:int = 0; i < screensVec.length; i++) 
			{
				
				var _screen:IScreen = screensVec[i];
				if (_screen == $screen)
				{
					display.removeChild(_screen as Sprite);
					_screen.unload();
					screensVec[i] = null;
					_found = true;
					break;
				}
			}
			if(_found)
				screensVec.splice(i, 1); 
			if (screensVec.length > 0) currentScreen = screensVec[screensVec.length - 1];
		}
		
		public function addColourOverlay($width:int, $height:int, $colour:uint = 0x000000, $alpha:Number = 1, $duration:Number = 1):void
		{
			colourOverlay = new TransitionColourFade(currentScreen, false, $width, $height, $colour, $alpha, $duration);
			transitionVec.push(colourOverlay);
			
			display.addChild(colourOverlay as Sprite);
			colourOverlay.transitionIn();			
		}
		
		public function removeColourOverlay():void
		{
			if (colourOverlay)
			{
				colourOverlay.addEventListener(TransitionEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete, false, 0, true);
				colourOverlay.transitionOut();
			}
		}
		
		public function destroy():void
		{
			onTransitionOutComplete(null);
		}

/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		private function removeAllScreens():void
		{
			for (var i:int = 0; i < screensVec.length; i++) 
			{
				screensVec[i].unload();
				display.removeChild(screensVec[i] as Sprite);
				screensVec[i] = null;
			}
			screensVec = null;
		}
		
		private function showScreen($screen:IScreen, $replace:Boolean = true):void
		{
			if ($replace)
			{			
				removeAllScreens();
				screensVec = new Vector.<IScreen>();
				screensVec.push($screen);
				
				if(!$screen.isLoaded)	$screen.load();
				display.addChild($screen as Sprite);
			}
			else
			{
				screensVec.push($screen);
				
				if (!$screen.isLoaded)	$screen.load();				
				display.addChild($screen as Sprite);
			}			
			
			currentScreen = $screen;
			
			if(display.stage)
				display.stage.focus = display.stage;
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		private function onTransitionInComplete(e:TransitionEvent):void 
		{
			showScreen(e.screen, e.replace);
			display.addChild(Sprite(e.transition));
		}
		
		private function onTransitionOutComplete(e:TransitionEvent):void 
		{
			for (var i:int = 0; i < transitionVec.length; i++) 
			{
				var _transition:ITransition = transitionVec[i];
				if (e.transition == _transition)
				{
					display.removeChild(_transition as Sprite);					
					_transition.removeEventListener(TransitionEvent.TRANSITION_IN_COMPLETE, onTransitionInComplete);
					_transition.removeEventListener(TransitionEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
					_transition.destroy();
					_transition = null;
					break;
				}				
			}
			transitionVec.splice(i, 1);
		}
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		public function get getDisplay():Sprite	{ return display };
		
		public function get getCurrentScreen():IScreen { return currentScreen };
		
	}
}