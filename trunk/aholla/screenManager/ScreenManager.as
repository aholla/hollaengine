/**
 * TODO: ScreenManager - A lot of this code seems strange. transitions seen to do crazy thing. Needs better intergration.
 * @author Adam
 * VERSION 0.0.3;
 * Changes: Transision check bool.
 * 
 * Usage: First add the "display" to the display list:
 * 				addChild(ScreenManager.inst.getDisplay);
 * 				or
 * 				ScreenManager.inst.init(DisplayObjectContainer);
 * 
 * 			Then add a screen (which implements IScreen)
 * 				ScreenManager.inst.addScreen(Iscreen);

 */

package aholla.screenManager
{
	import aholla.screenManager.transitions.ITransition;
	import aholla.screenManager.transitions.TransitionColourFade;
	import aholla.screenManager.transitions.TransitionEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class ScreenManager
	{
		private static var 	_instance				:ScreenManager;
		private static var 	_allowInstance			:Boolean;
		
		private var display							:Sprite;	
		private var screensVec						:Vector.<IScreen> 		= new Vector.<IScreen>();
		private var transitionVec					:Vector.<ITransition> 	= new Vector.<ITransition>();
		private var currentScreen					:IScreen
		private var colourOverlay					:ITransition;
		private var isTransitioning					:Boolean;
		
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

		/**
		 * Optional init method. This will add the ScreenManagers 'display' 
		 * to the displayObject provided. Alternativly, use 'ScreenManager.inst.getDisplay' 
		 * to add it manually to the display list.
		 * @param	displayObject - to which the display will be added.
		 */
		public function init(displayObject:DisplayObjectContainer):void
		{
			displayObject.addChild(display);
		}
		
		/**
		 * Adds the provided screen to the display list.
		 * @param	$screen - implements IScreen
		 * @param	$replace - removes the old screen
		 * @param	$transition - a customn tranition e.g new Transition()
		 */
		public function addScreen($screen:IScreen, $replace:Boolean = true, $transition:ITransition = null):void 
		{
			if ($transition != null) 
			{
				isTransitioning = true;
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
		
		/**
		 * Removes the provided screen.
		 * @param	$screen
		 */
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
			if (screensVec.length > 0) 
			{
				currentScreen = screensVec[screensVec.length - 1];
				display.stage.focus = display;
			}
		}
		
		/**
		 * Adds an animated colour fade coloured overlay to the screen.
		 * @param	$width
		 * @param	$height
		 * @param	$colour
		 * @param	$alpha
		 * @param	$duration
		 */
		public function addOverlayColour($width:int, $height:int, $colour:uint = 0x000000, $alpha:Number = 1, $duration:Number = 1):void
		{
			colourOverlay = new TransitionColourFade(currentScreen, false, $width, $height, $colour, $alpha, $duration);
			transitionVec.push(colourOverlay);
			
			display.addChild(colourOverlay as Sprite);
			colourOverlay.transitionIn();			
		}
		
		/**
		 * Removes the coloure doverlay
		 */
		public function removeOverlayColour():void
		{
			if (colourOverlay)
			{
				colourOverlay.addEventListener(TransitionEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete, false, 0, true);
				colourOverlay.transitionOut();
			}
		}
		
		/**
		 * Clears everything for GC.
		 */
		public function destroy():void
		{
			onTransitionOutComplete(null);
			screensVec= new Vector.<IScreen>();
			transitionVec = new Vector.<ITransition>();
			if(currentScreen)	currentScreen.unload();
			if (colourOverlay)	colourOverlay.destroy();
			currentScreen = null;
			colourOverlay = null;
		}

/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
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
			isTransitioning = false;
		}
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		public function get getDisplay():Sprite	{ return display };
		
		public function get getCurrentScreen():IScreen { return currentScreen };
		
		public function get getIsTrasnitionig():Boolean { return isTransitioning };

		
		
	}
}