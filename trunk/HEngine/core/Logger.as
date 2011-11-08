/**
 * ...
 * @author Adam
 * 
 * colours
 * 0 = grey		- log
 * 1 = black	- print
 * 2 = orange	- warn
 * 3 = red		- not used
 * 4 - pink		- error
 */

package aholla.HEngine.core 
{
	import aholla.HEngine.HE;
	import com.furusystems.dconsole2.core.style.Alphas;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.plugins.plugcollections.AllPlugins;
	import com.furusystems.dconsole2.plugins.plugcollections.BasicPlugins;
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;
	import flash.display.DisplayObjectContainer;
	
	public class Logger
	{
		public static var isDebug					:Boolean = true;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function Logger() 
		{
			
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		// GREY
		public static function log($string:String, ... rest):void
		{   
			var _str:String = new String($string);			
			for(var i:uint = 0; i < rest.length; i++)
			{
				_str += ", " + String(rest[i]);
			}			
			trace("0:" + _str);
			Logging.root.debug.apply(null, [_str]);
		}
		
		// BLACK
		public static function print($string:String, ... rest):void
		{
			var _str:String = new String($string);
			for(var i:uint = 0; i < rest.length; i++)
			{
				_str += ", " + String(rest[i]);
			}
			trace("1:" + _str);
			Logging.root.info.apply(null, [_str]);
		}
		
		// ORANGE
		public static function warn($string:String, ... rest):void
		{
			var _str:String = new String($string);
			for(var i:uint = 0; i < rest.length; i++)
			{
				_str += ", " + String(rest[i]);
			}
			trace("2:" + _str);			
			Logging.root.warn.apply(null, ["Warning:", _str]);
		}
		
		// PINK
		public static function error($string:String, ... rest):void
		{
			var _str:String = new String($string);
			for(var i:uint = 0; i < rest.length; i++)
			{
				_str += ", " + String(rest[i]);
			}
			trace("4:" + _str);
			Logging.root.error.apply(null, ["Error:", _str]);			
			//Logging.root.fatal.apply(null, [_str]);			
		}
		
		public static function init($container:DisplayObjectContainer, $password:String = "hedebug"):void
		{
			//DConsole.clearPersistentData();
			/**
			 * Add the console view to your stage. MUST BE ADDED FIRST!
			 */
			//HE.world.addChild(DConsole.view);
			$container.addChild(DConsole.view);
			
			
			
			//DConsole.view.alpha = 0.7;
			DConsole.setTitle("HEngine version " + HE.VERSION);			
			
			/**
			 * By default, the console has a fairly limited feature set
			 * To enable plugins, call registerPlugins() with class references
			 */
			DConsole.registerPlugins(BasicPlugins);
			//DConsole.registerPlugins(AllPlugins);
			/**
			 * Hide the console behind a password.
			 */
			DConsole.setMagicWord($password);			
			//enableTaggedLogger();
			
			/**
			 * While the console has a bunch of built-in stuff, you only really
			 * gain something special when you create your own commands
			 */
			DConsole.createCommand("toggleDev", onToggleDev, "HEngine", "Toggels the HE.devMode.");
			
			Logger.print("HEngine Ready.");
			//DConsole.show();		
		}
			
		public static function onToggleDev():void 
		{
			if (HE.isDebug)
				HE.isDebug = false;
			else
				HE.isDebug = true;
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		private static function enableTaggedLogger():void 
		{
						/**
			 * Before we can start logging, we need to create a logger to correctly tag our messages
			 * The tag is a string representation of the class type that created the log message
			 */
			//return;
			var L:ILogger = Logging.getLogger(HE); //Typically you'll create this as a static constant in your classes
			
			/**
			 * Printing to the console is done through the ILogger logging methods
			 * info(), error(), warn(), fatal() and debug()
			 * Debug is for your regular trace messages
			 */
			L.debug("Hello debug!");
			
			/**
			 * By default, the console will "stack" repeated messages so it doesn't get flooded
			 * It keeps a numeric tally of the number of repeated messages though
			 */
			L.debug("Hello debug!");
			
			/**
			 * Info is the next step up, and these messages describe the flow and progress of your application
			 */
			L.info("Hello info!");
			
			/**
			 * Warnings are effectively errors that aren't critical
			 * All logging methods work much like trace(), taking multiple args
			 */
			L.warn("Hello warning!", HE, 552);
			
			/**
			 * Error is obviously for when something breaks
			 * Note that each logging method input is colored differently in the output
			 */
			L.error("Hello error!");
			
			/**
			 * Fatal is when something REALLY breaks. Reserve fatal messages for conditions when
			 * your application literally can not recover.
			 */
			L.fatal("Hello fatal");
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		
	}
}