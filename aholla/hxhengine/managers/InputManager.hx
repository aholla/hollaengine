/**
* The InputManager can be used in num2 way, calling methods and passing in varibles to check.
* Or by checking static varibles.
* 
* To check if a Key is down, check if the static Bool is true;
* eg: if(InputManger.SPACE)
* 		doSomething();
* 
* OR:
* if(HE.inputManager.isKeyDown("key")
* 		doSomething();
* 
* 
* Same for the mouse.
* 
* TODO - justPressed - fires once
* 
* @author Adam
*/

package aholla.hxhengine.managers;

import aholla.hxhengine.HE;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.events.Event;
import nme.events.EventDispatcher;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;

class InputManager extends EventDispatcher
{
	public var screen								:Sprite;
	
	public var mouseScreenPos(default, null)		:Point;
	public var mouseWorldPos(default, null)			:Point;
	public var isMouseDown(default, null)			:Bool;
	public var isMouseClicked(default, null)		:Bool;
	
	public static var MOUSE_UP						:Bool = false;
	public static var MOUSE_DOWN					:Bool = false;
	public static var MOUSE_CLICKED					:Bool = false;		
	
	public inline static var num0_KEY				:Int = 48;
	public inline static var num1_KEY				:Int = 49;
	public inline static var num2_KEY				:Int = 50;
	public inline static var num3_KEY				:Int = 51;
	public inline static var num4_KEY				:Int = 52;
	public inline static var num5_KEY				:Int = 53;
	public inline static var num6_KEY				:Int = 54;
	public inline static var num7_KEY				:Int = 55;
	public inline static var num8_KEY				:Int = 56;
	public inline static var num9_KEY				:Int = 57;		
	public inline static var A_KEY				:Int = 65;
	public inline static var B_KEY				:Int = 66;
	public inline static var C_KEY				:Int = 67;
	public inline static var D_KEY				:Int = 68;
	public inline static var E_KEY				:Int = 69;
	public inline static var F_KEY				:Int = 70;
	public inline static var G_KEY				:Int = 71;
	public inline static var H_KEY				:Int = 72;
	public inline static var I_KEY				:Int = 73;
	public inline static var J_KEY				:Int = 74;
	public inline static var K_KEY				:Int = 75;
	public inline static var L_KEY				:Int = 76;
	public inline static var M_KEY				:Int = 77;
	public inline static var N_KEY				:Int = 78;
	public inline static var O_KEY				:Int = 79;
	public inline static var P_KEY				:Int = 80;
	public inline static var Q_KEY				:Int = 81;
	public inline static var R_KEY				:Int = 82;
	public inline static var S_KEY				:Int = 83;
	public inline static var T_KEY				:Int = 84;
	public inline static var U_KEY				:Int = 85;
	public inline static var V_KEY				:Int = 86;
	public inline static var W_KEY				:Int = 87;
	public inline static var X_KEY				:Int = 88;
	public inline static var Y_KEY				:Int = 89;
	public inline static var Z_KEY				:Int = 90;
	public inline static var SPACE_KEY			:Int = 32;
	public inline static var SHIFT_KEY			:Int = 16;
	public inline static var UP_KEY				:Int = 38;
	public inline static var DOWN_KEY			:Int = 40;
	public inline static var LEFT_KEY			:Int = 37;
	public inline static var RIGHT_KEY			:Int = 39;
	public inline static var PLUS_KEY			:Int = 187;
	public inline static var MINUS_KEY			:Int = 189;
	
	
	public static var zero							:Bool = false;
	public static var num1							:Bool = false;
	public static var num2							:Bool = false;
	public static var num3							:Bool = false;
	public static var num4							:Bool = false;
	public static var num5							:Bool = false;
	public static var num6							:Bool = false;
	public static var num7							:Bool = false;
	public static var num8							:Bool = false;
	public static var num9							:Bool = false;		
	public static var A								:Bool = false;
	public static var B								:Bool = false;
	public static var C								:Bool = false;
	public static var D								:Bool = false;
	public static var E								:Bool = false;
	public static var F								:Bool = false;
	public static var G								:Bool = false;
	public static var H								:Bool = false;
	public static var I								:Bool = false;
	public static var J								:Bool = false;
	public static var K								:Bool = false;
	public static var L								:Bool = false;
	public static var M								:Bool = false;
	public static var N								:Bool = false;
	public static var O								:Bool = false;
	public static var P								:Bool = false;
	public static var Q								:Bool = false;
	public static var R								:Bool = false;
	public static var S								:Bool = false;
	public static var T								:Bool = false;
	public static var U								:Bool = false;
	public static var V								:Bool = false;
	public static var W								:Bool = false;
	public static var X								:Bool = false;
	public static var Y								:Bool = false;
	public static var Z								:Bool = false;
	public static var SPACE							:Bool = false;
	public static var SHIFT							:Bool = false;
	public static var UP							:Bool = false;
	public static var DOWN							:Bool = false;
	public static var LEFT							:Bool = false;
	public static var RIGHT							:Bool = false;
	public static var PLUS							:Bool = false;
	public static var MINUS							:Bool = false;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new() 
	{
		super();
		
		mouseScreenPos 	= new Point();
		mouseWorldPos 	= new Point();
		isMouseDown 	= false;
		isMouseClicked 	= false;
		
		screen = HE.world;			
		screen.addEventListener(MouseEvent.MOUSE_DOWN, 	onMouseDown, false, 0, true);
		screen.addEventListener(MouseEvent.MOUSE_UP, 	onMouseUp, false, 0, true);
		
		/* If you are getting an error here, it is becuase HE does not yet have acces to the stage. */
		HE.stage.addEventListener(KeyboardEvent.KEY_DOWN, 	keyDown_handle, false, 0, true);
		HE.stage.addEventListener(KeyboardEvent.KEY_UP, 	keyUp_handle, false, 0, true);
		HE.stage.addEventListener(Event.DEACTIVATE, 		deactivate_handle, false, 0, true);
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	public function update():Void 
	{
		if (screen != null)
		{
			mouseScreenPos.x = screen.mouseX;
			mouseScreenPos.y = screen.mouseY;
			
			mouseWorldPos.x = HE.camera.x + screen.mouseX;
			mouseWorldPos.y = HE.camera.y + screen.mouseY;
		}
		
		isMouseClicked = false;
		InputManager.MOUSE_UP = false;
		InputManager.MOUSE_CLICKED = false;
	}
	
	public function isKeyDown(key:String):Bool
	{		
		//if (InputManager[key.toUpperCase()])
		if(Reflect.hasField(InputManager, key.toUpperCase()))
			return true;
		else
			return false;
	}
	
	public function destroy():Void 
	{
		screen.removeEventListener(MouseEvent.MOUSE_DOWN, 	onMouseDown);
		screen.removeEventListener(MouseEvent.MOUSE_UP, 	onMouseUp);
		
		if (screen.stage != null)
		{
			screen.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown_handle);
			screen.stage.removeEventListener(KeyboardEvent.KEY_UP, 	keyUp_handle);
			screen.stage.removeEventListener(Event.DEACTIVATE, 		deactivate_handle);
		}
		
		isMouseDown	= false;
		isMouseClicked	= false;
		
		deactivate_handle();
		
		screen = null;
	}
	
	public function reset():Void 
	{
		deactivate_handle(null);
	}
	
/*-------------------------------------------------
* public FUNCTIONS
-------------------------------------------------*/
	
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	public function onMouseDown(e:MouseEvent):Void 
	{
		isMouseDown = true;
		
		InputManager.MOUSE_DOWN = true;
		InputManager.MOUSE_UP = false;
	}
	
	public function onMouseUp(e:MouseEvent):Void 
	{			
		isMouseDown = false;
		isMouseClicked = true;
		
		InputManager.MOUSE_DOWN 	= false;
		InputManager.MOUSE_UP 		= true;
		InputManager.MOUSE_CLICKED 	= true;
	}
	
	public function keyDown_handle(e:KeyboardEvent):Void
	{
		switch (e.keyCode)
		{
			case A_KEY :		A = true;	
			case B_KEY :		B = true;	
			case C_KEY :		C = true;	
			case D_KEY :		D = true;	
			case E_KEY :		E = true;	
			case F_KEY :		F = true;	
			case G_KEY :		G = true;	
			case H_KEY :		H = true;	
			case I_KEY :		I = true;	
			case J_KEY :		J = true;	
			case K_KEY :		K = true;	
			case L_KEY :		L = true;	
			case M_KEY :		M = true;	
			case N_KEY :		N = true;	
			case O_KEY :		O = true;	
			case P_KEY :		P = true;	
			case Q_KEY :		Q = true;	
			case R_KEY :		R = true;	
			case S_KEY :		S = true;	
			case T_KEY :		T = true;	
			case U_KEY :		U = true;	
			case V_KEY :		V = true;	
			case W_KEY :		W = true;	
			case X_KEY :		X = true;	
			case Y_KEY :		Y = true;	
			case Z_KEY :		X = true;	
			case SPACE_KEY :	SPACE = true;	
			case SHIFT_KEY :	SHIFT = true;	
			case UP_KEY :		UP = true;	
			case DOWN_KEY :		DOWN = true;	
			case LEFT_KEY :		LEFT = true;	
			case RIGHT_KEY :	RIGHT = true;	
			case PLUS_KEY :		PLUS = true;	
			case MINUS_KEY :	MINUS = true;				
			case num0_KEY :		zero = true;
			case num1_KEY :		num1 = true;
			case num2_KEY :		num2 = true;
			case num3_KEY :		num3 = true;
			case num4_KEY :		num4 = true;
			case num5_KEY :		num5 = true;
			case num6_KEY :		num6 = true;
			case num7_KEY :		num7 = true;
			case num8_KEY :		num8 = true;
			case num9_KEY :		num9 = true;			
		}	
		dispatchEvent(e);
	}
	
	public function keyUp_handle(e:KeyboardEvent):Void
	{
		switch (e.keyCode)
		{
			case A_KEY :		A = false;	
			case B_KEY :		B = false;	
			case C_KEY :		C = false;	
			case D_KEY :		D = false;	
			case E_KEY :		E = false;	
			case F_KEY :		F = false;	
			case G_KEY :		G = false;	
			case H_KEY :		H = false;	
			case I_KEY :		I = false;	
			case J_KEY :		J = false;	
			case K_KEY :		K = false;	
			case L_KEY :		L = false;	
			case M_KEY :		M = false;	
			case N_KEY :		N = false;	
			case O_KEY :		O = false;	
			case P_KEY :		P = false;	
			case Q_KEY :		Q = false;	
			case R_KEY :		R = false;	
			case S_KEY :		S = false;	
			case T_KEY :		T = false;	
			case U_KEY :		U = false;	
			case V_KEY :		V = false;	
			case W_KEY :		W = false;	
			case X_KEY :		X = false;	
			case Y_KEY :		Y = false;	
			case Z_KEY :		X = false;	
			case SPACE_KEY :	SPACE 	= false;	
			case SHIFT_KEY :	SHIFT 	= false;	
			case UP_KEY :		UP 		= false;	
			case DOWN_KEY :		DOWN 	= false;	
			case LEFT_KEY :		LEFT 	= false;	
			case RIGHT_KEY :	RIGHT 	= false;	
			case PLUS_KEY :		PLUS 	= false;	
			case MINUS_KEY :	MINUS 	= false;	
			case num0_KEY :		zero 	= false;
			case num1_KEY :		num1 	= false;
			case num2_KEY :		num2 	= false;
			case num3_KEY :		num3 	= false;
			case num4_KEY :		num4 	= false;
			case num5_KEY :		num5 	= false;
			case num6_KEY :		num6 	= false;
			case num7_KEY :		num7 	= false;
			case num8_KEY :		num8 	= false;
			case num9_KEY :		num9 	= false;
		}
		dispatchEvent(e);
	}
	
	public function deactivate_handle(e:Event = null):Void
	{
		A = false;
		B = false;
		C = false;
		D = false;
		E = false;
		F = false;
		G = false;
		H = false;
		I = false;
		J = false;
		K = false;
		L = false;
		M = false;
		N = false;
		O = false;
		P = false;
		Q = false;
		R = false;
		S = false;
		T = false;
		U = false;
		V = false;
		W = false;
		X = false;
		Y = false;
		Z = false;
		SPACE 	= false;
		SHIFT 	= false;
		UP 		= false;
		DOWN 	= false;
		LEFT 	= false;
		RIGHT 	= false;
		PLUS 	= false;
		MINUS 	= false;
		
		zero 	= false;
		num1 	= false;
		num2 	= false;
		num3 	= false;
		num4 	= false;
		num5 	= false;
		num6 	= false;
		num7 	= false;
		num8 	= false;
		num9 	= false;			
		MOUSE_UP		= false;
		MOUSE_DOWN		= false;
		MOUSE_CLICKED	= false;
	}
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
}