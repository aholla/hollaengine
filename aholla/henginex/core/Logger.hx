/**
 * ...
 * @author Adam
 * 
 * colours
 * 0 = grey		- log
 * 1 = black	- prInt
 * 2 = orange	- warn
 * 3 = red		- not used
 * 4 - pink		- error
 */

package aholla.henginex.core;

import aholla.henginex.HE;

class Logger
{
	public static var isDebug					:Bool = true;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new() 
	{
		
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	// GREY
	public static function log(string:String, rest:Array<Dynamic>):Void
	{   
		var _str:String = new String(string);			
		if (rest != null)
		{
			for(i in 0 ... rest.length)
			{
				_str += ", " + Std.string(rest[i]);
			}
		}
		trace(_str);
	}
	
	// BLACK
	public static function print(string:String, ?rest:Array<Dynamic>):Void
	{		
		var _str:String = new String(string);		
		if (rest != null)
		{
			for(i in 0... rest.length)
			{
				_str += ", " + Std.string(rest[i]);
			}
		}
		trace(_str);
	}
	
	// ORANGE
	public static function warn(string:String, ?rest:Array<Dynamic>):Void
	{
		var _str:String = new String(string);
		if (rest != null)
		{
			for(i in 0...rest.length)
			{
				_str += ", " + Std.string(rest[i]);
			}
		}
		trace(_str);
	}
	
	// PINK
	public static function error(className:Dynamic, string:String, ?rest:Array<Dynamic>):Void
	{
		var _str:String = new String(string);
		if (rest != null)
		{
			for(i in 0 ... rest.length)
			{
				_str += ", " + Std.string(rest[i]);
			}
		}
		trace(_str);			
	}
	
	public static function init(password:String = "hedebug"):Void
	{		
		Logger.print("HEngine Ready.");	
	}
		
	public static function onToggleDev():Void 
	{
		if (HE.isDebug)
			HE.isDebug = false;
		else
			HE.isDebug = true;
	}
	
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
	
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
	
	
}
	
	
	