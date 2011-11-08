/**
 * TODO: ScreenManager - A lot of this code seems strange. transitions seen to do crazy thing. Needs better intergration.
 * @author Adam
 */

package aholla.screenManager
{
	import aholla.screenManager.transitions.ITransition;
	import aholla.screenManager.transitions.TransitionEvent;
	import flash.display.Sprite;

	public class ScreenManager
	{
		private static var 	_instance				:ScreenManager;
		private static var 	_allowInstance			:Boolean;
		
		private var display							:Sprite;		
		private var screensVec						:Vector.<IScreen> 		= new Vector.<IScreen>();
		private var transitionVec					:Vector.<ITransition> 	= new Vector.<ITransition>();
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function ScreenManager() 
		{
			if (!ScreenManager._allowInstance)
			{
				throw new Error("Error: Use ScreenManager.inst instead of the new keyword.");
			}
			display = new Sprite();
		}
		
		public static function get inst():ScreenManager
		{
			if (ScreenManager._instance == null)
			{
				ScreenManager._allowInstance	= true;
				ScreenManager._instance			= new ScreenManager();
				ScreenManager._allowInstance	= false;
			}
			return ScreenManager._instance;
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function newScreen($screen:IScreen, $replace:Boolean = true, $transition:ITransition = null):void 
		{
			transitionVec.push($transition);
			
			if ($transition != null) 
			{
				display.addChild(Sprite($transition));
				$transition.addEventListener(TransitionEvent.TRANSITION_IN_COMPLETE, onTransitionInComplete, false, 0, true);
				$transition.addEventListener(TransitionEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete, false, 0, true);
				$transition.transitionIn();
				return;
			}
			else
			{			
				showScreen($screen, $replace);
			}
			
			display.stage.focus = display.stage;
		}
		
		
		public function removeScreen($screen:IScreen):void
		{
			var _found:Boolean;
			for (var i:int = 0; i < screensVec.length; i++) 
			{
				var _screen:IScreen = screensVec[i];
				if (_screen == $screen)
				{
					display.removeChild(Sprite(_screen));
					_screen.unload();
					screensVec[i] = null;
					_found = true;
					break;
				}
			}
			if(_found)
				screensVec.splice(i, 1);
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
				display.removeChild(Sprite(screensVec[i]));
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
				display.addChild(Sprite($screen));
			}
			else
			{
				screensVec.push($screen);
				display.addChild(Sprite($screen));
			}
			
			if(!$screen.isLoaded)
				$screen.load();
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
					display.removeChild(Sprite(_transition));
					
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
		
	}
}