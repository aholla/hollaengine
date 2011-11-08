/**
 * ...
 * @author ADAM
 */

package com.aholla.utils 
{
	
public class PadNum
{
	
	public static const LEFT	:String = "left";
	public static const RIGHT	:String = "right";
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
	public function PadNum() 
	{
		
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	public static function pad($num:Number, $numZeros:Number = 1, $pos:String = "left"):String
	{
		var _str		:String = "";
		var _zerosStr	:String = "";	
		
		if ($num < Math.pow(10, $numZeros)) 
		{
			for (var j:int = 0; j < $numZeros; j++) 
				_zerosStr += "0";
		}
		else
		{
			_str = String($num);
		}
		
		if ($pos == "right")
			_str = String($num) + _zerosStr;		
		else
			_str = _zerosStr + String($num);	
			
		return _str;
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
}