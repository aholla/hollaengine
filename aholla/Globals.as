package aholla
{
	
import flash.display.DisplayObject;
import flash.display.Stage;
	
public class Globals 
{
	public static var stage				:Stage;
	public static var root				:DisplayObject;
	public static var stageWidth		:Number;
	public static var stageHeight		:Number;
	public static var stageCenterX		:Number;
	public static var stageCenterY		:Number;
	public static var xml				:XML;
	public static var localMode			:Boolean;
	public static var devMode			:Boolean;
	
	public static var path				:String;
	public static var pathParent		:String;
	
	public static var PI				:Number = 3.1415926535897932384626433832795;
	public static var TO_RADIANS		:Number = 0.01745329251994329576923690768489;
	public static var TO_DEGREES		:Number = 57.295779513082320876798154814105;

/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function Globals() 
	{
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	public static function init($root:DisplayObject, $width:int = 0, $height:int = 0):void
	{
		Globals.root 			= $root;
		Globals.stage 			= $root.stage;
		Globals.path 			= $root.loaderInfo.url.substr(0, $root.loaderInfo.url.lastIndexOf("/")) + "/";
		
		if ($width > 0)
		{
			Globals.stageWidth 		= $width;
			Globals.stageCenterX 	= $width * 0.5;
		}
		else
		{
			Globals.stageWidth 		= Globals.stage.stageWidth;
			Globals.stageCenterX 	= Globals.stage.stageWidth * 0.5;
		}
		
		if ($height > 0)
		{
			Globals.stageHeight		= $height;
			Globals.stageCenterY 	= $height * 0.5;
		}
		else
		{
			Globals.stageHeight		= Globals.stage.stageHeight;
			Globals.stageCenterY 	= Globals.stage.stageHeight * 0.5;
		}
		
		Globals.localMode 		= new RegExp("file://").test(Globals.stage.loaderInfo.url);
		Globals.stage.stageFocusRect = false;
		
		trace("Gloabls.localMode:", Globals.localMode);
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






