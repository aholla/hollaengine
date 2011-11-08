package com.aholla.utils
{
	
import flash.text.TextField;
import flash.text.TextFormat;

public class AutoText
{
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function AutoText()
	{
		
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	public static function setText(txt:TextField, cont:String):void
	{
		var maxWidth:Number 	= Math.floor(txt.width) - 2;
		var maxHeight:Number 	= Math.floor(txt.height) - 2;
		var format:TextFormat 	= txt.getTextFormat();
		var baseSize:int 		= Number(format.size);
		
		txt.text = cont;		

		if(txt.multiline == false)
		{
			baseSize += 1;
			format.size = baseSize;
			txt.setTextFormat(format);
			txt.wordWrap = false;
		}
		else
		{
			txt.wordWrap = true;
		}		
		
		while(txt.textWidth > maxWidth || txt.textHeight > maxHeight)
		{
			txt.y += 0.5
			baseSize -= 1;
			format.size = baseSize;
			txt.setTextFormat(format);
		}		
	}
	
	
	public static function setHtml(txt:TextField, cont:String):void
	{
		txt.htmlText = cont;
		
		var maxWidth:Number 	= Math.floor(txt.width) - 2;
		var maxHeight:Number 	= Math.floor(txt.height);
		var format:TextFormat 	= txt.getTextFormat();
		var baseSize:int 		= Number(format.size);		
		
		if(txt.multiline == false)
		{
			baseSize += 1;
			format.size = baseSize;
			txt.setTextFormat(format);
			txt.wordWrap = false;
		}
		else
		{
			txt.wordWrap = true;
		}		
		
		while(txt.textWidth > maxWidth || txt.textHeight > maxHeight)
		{
			txt.y += 0.5
			baseSize -= 1;
			format.size = baseSize;
			txt.setTextFormat(format);
		}
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