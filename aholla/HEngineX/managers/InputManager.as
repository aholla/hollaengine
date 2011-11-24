/**
 * The InputManager can be used in num2 way, calling methods and passing in varibles to check.
 * Or by checking static varibles.
 * 
 * To check if a Key is down, check if the static boolean is true;
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

package aholla.HEngine.managers 
{
	import aholla.HEngine.core.Logger;
	import aholla.HEngine.HE;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class InputManager extends EventDispatcher
	{
		public var screen						:Sprite;
		
		public var _mouseScreenPos				:Point = new Point();
		public var _mouseWorldPos				:Point = new Point();
		public var _isMouseDown				:Boolean = false;
		public var _isMouseClicked				:Boolean = false;
		
		public static var MOUSE_UP				:Boolean = false;
		public static var MOUSE_DOWN			:Boolean = false;
		public static var MOUSE_CLICKED			:Boolean = false;		
		
		public static const num0_KEY				:int = 48;
		public static const num1_KEY				:int = 49;
		public static const num2_KEY				:int = 50;
		public static const num3_KEY				:int = 51;
		public static const num4_KEY				:int = 52;
		public static const num5_KEY				:int = 53;
		public static const num6_KEY				:int = 54;
		public static const num7_KEY				:int = 55;
		public static const num8_KEY				:int = 56;
		public static const num9_KEY				:int = 57;		
		public static const A_KEY				:int = 65;
		public static const B_KEY				:int = 66;
		public static const C_KEY				:int = 67;
		public static const D_KEY				:int = 68;
		public static const E_KEY				:int = 69;
		public static const F_KEY				:int = 70;
		public static const G_KEY				:int = 71;
		public static const H_KEY				:int = 72;
		public static const I_KEY				:int = 73;
		public static const J_KEY				:int = 74;
		public static const K_KEY				:int = 75;
		public static const L_KEY				:int = 76;
		public static const M_KEY				:int = 77;
		public static const N_KEY				:int = 78;
		public static const O_KEY				:int = 79;
		public static const P_KEY				:int = 80;
		public static const Q_KEY				:int = 81;
		public static const R_KEY				:int = 82;
		public static const S_KEY				:int = 83;
		public static const T_KEY				:int = 84;
		public static const U_KEY				:int = 85;
		public static const V_KEY				:int = 86;
		public static const W_KEY				:int = 87;
		public static const X_KEY				:int = 88;
		public static const Y_KEY				:int = 89;
		public static const Z_KEY				:int = 90;
		public static const SPACE_KEY			:int = 32;
		public static const SHIFT_KEY			:int = 16;
		public static const UP_KEY				:int = 38;
		public static const DOWN_KEY			:int = 40;
		public static const LEFT_KEY			:int = 37;
		public static const RIGHT_KEY			:int = 39;
		public static const PLUS_KEY			:int = 187;
		public static const MINUS_KEY			:int = 189;
		
		
		public static var zero					:Boolean = false;
		public static var num1					:Boolean = false;
		public static var num2					:Boolean = false;
		public static var num3					:Boolean = false;
		public static var num4					:Boolean = false;
		public static var num5					:Boolean = false;
		public static var num6					:Boolean = false;
		public static var num7					:Boolean = false;
		public static var num8					:Boolean = false;
		public static var num9					:Boolean = false;		
		public static var A						:Boolean = false;
		public static var B						:Boolean = false;
		public static var C						:Boolean = false;
		public static var D						:Boolean = false;
		public static var E						:Boolean = false;
		public static var F						:Boolean = false;
		public static var G						:Boolean = false;
		public static var H						:Boolean = false;
		public static var I						:Boolean = false;
		public static var J						:Boolean = false;
		public static var K						:Boolean = false;
		public static var L						:Boolean = false;
		public static var M						:Boolean = false;
		public static var N						:Boolean = false;
		public static var O						:Boolean = false;
		public static var P						:Boolean = false;
		public static var Q						:Boolean = false;
		public static var R						:Boolean = false;
		public static var S						:Boolean = false;
		public static var T						:Boolean = false;
		public static var U						:Boolean = false;
		public static var V						:Boolean = false;
		public static var W						:Boolean = false;
		public static var X						:Boolean = false;
		public static var Y						:Boolean = false;
		public static var Z						:Boolean = false;
		public static var SPACE					:Boolean = false;
		public static var SHIFT					:Boolean = false;
		public static var UP					:Boolean = false;
		public static var DOWN					:Boolean = false;
		public static var LEFT					:Boolean = false;
		public static var RIGHT					:Boolean = false;
		public static var PLUS					:Boolean = false;
		public static var MINUS					:Boolean = false;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function InputManager() 
		{
			screen = HE.world;			
			screen.addEventListener(MouseEvent.MOUSE_DOWN, 	onMouseDown, false, 0, true);
			screen.addEventListener(MouseEvent.MOUSE_UP, 	onMouseUp, false, 0, true);
			
			// If you are getting an error here, it is becuase HE does not yet have acces to the stage.
			screen.stage.addEventListener(KeyboardEvent.KEY_DOWN, 	keyDown_handle, false, 0, true);
			screen.stage.addEventListener(KeyboardEvent.KEY_UP, 	keyUp_handle, false, 0, true);
			screen.stage.addEventListener(Event.DEACTIVATE, 		deactivate_handle, false, 0, true);
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function update():void 
		{
			if (screen)
			{
				_mouseScreenPos.x = screen.mouseX;
				_mouseScreenPos.y = screen.mouseY;
				
				_mouseWorldPos.x = HE.camera.x + screen.mouseX;
				_mouseWorldPos.y = HE.camera.y + screen.mouseY;
			}
			
			_isMouseClicked = false;
			InputManager.MOUSE_UP = false;
			InputManager.MOUSE_CLICKED = false;
		}
		
		public function isKeyDown($key:String):Boolean
		{		
			if (InputManager[$key.toUpperCase()])
				return true;
			else
				return false;
		}
		
		public function destroy():void 
		{
			screen.removeEventListener(MouseEvent.MOUSE_DOWN, 	onMouseDown);
			screen.removeEventListener(MouseEvent.MOUSE_UP, 	onMouseUp);
			
			if (screen.stage)
			{
				screen.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown_handle);
				screen.stage.removeEventListener(KeyboardEvent.KEY_UP, 	keyUp_handle);
				screen.stage.removeEventListener(Event.DEACTIVATE, 		deactivate_handle);
			}
			
			_isMouseDown	= false;
			_isMouseClicked	= false;
			
			deactivate_handle();
			
			screen = null;
		}
		
		public function reset():void 
		{
			deactivate_handle(null);
		}
		
/*-------------------------------------------------
* public FUNCTIONS
-------------------------------------------------*/
		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		public function onMouseDown(e:MouseEvent):void 
		{
			_isMouseDown = true;
			
			InputManager.MOUSE_DOWN = true;
			InputManager.MOUSE_UP = false;
		}
		
		public function onMouseUp(e:MouseEvent):void 
		{			
			_isMouseDown = false;
			_isMouseClicked = true;
			
			InputManager.MOUSE_DOWN 	= false;
			InputManager.MOUSE_UP 		= true;
			InputManager.MOUSE_CLICKED 	= true;
		}
		
		public function keyDown_handle(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case A_KEY :		A = true;				break;	
				case B_KEY :		B = true;				break;	
				case C_KEY :		C = true;				break;	
				case D_KEY :		D = true;				break;	
				case E_KEY :		E = true;				break;	
				case F_KEY :		F = true;				break;	
				case G_KEY :		G = true;				break;	
				case H_KEY :		H = true;				break;	
				case I_KEY :		I = true;				break;	
				case J_KEY :		J = true;				break;	
				case K_KEY :		K = true;				break;	
				case L_KEY :		L = true;				break;	
				case M_KEY :		M = true;				break;	
				case N_KEY :		N = true;				break;	
				case O_KEY :		O = true;				break;	
				case P_KEY :		P = true;				break;	
				case Q_KEY :		Q = true;				break;	
				case R_KEY :		R = true;				break;	
				case S_KEY :		S = true;				break;	
				case T_KEY :		T = true;				break;	
				case U_KEY :		U = true;				break;	
				case V_KEY :		V = true;				break;	
				case W_KEY :		W = true;				break;	
				case X_KEY :		X = true;				break;	
				case Y_KEY :		Y = true;				break;	
				case Z_KEY :		X = true;				break;	
				case SPACE_KEY :	SPACE = true;			break;	
				case SHIFT_KEY :	SHIFT = true;			break;	
				case UP_KEY :		UP = true;				break;	
				case DOWN_KEY :		DOWN = true;			break;	
				case LEFT_KEY :		LEFT = true;			break;	
				case RIGHT_KEY :	RIGHT = true;			break;	
				case PLUS_KEY :		PLUS = true;			break;	
				case MINUS_KEY :	MINUS = true;			break;				
				case num0_KEY :		zero = true;			break;
				case num1_KEY :		num1 = true;				break;
				case num2_KEY :		num2 = true;				break;
				case num3_KEY :		num3 = true;			break;
				case num4_KEY :		num4 = true;			break;
				case num5_KEY :		num5 = true;			break;
				case num6_KEY :		num6 = true;				break;
				case num7_KEY :		num7 = true;			break;
				case num8_KEY :		num8 = true;			break;
				case num8_KEY :		num9 = true;			break;			
			}	
			dispatchEvent(e);
		}
		
		public function keyUp_handle(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case A_KEY :		A = false;				break;	
				case B_KEY :		B = false;				break;	
				case C_KEY :		C = false;				break;	
				case D_KEY :		D = false;				break;	
				case E_KEY :		E = false;				break;	
				case F_KEY :		F = false;				break;	
				case G_KEY :		G = false;				break;	
				case H_KEY :		H = false;				break;	
				case I_KEY :		I = false;				break;	
				case J_KEY :		J = false;				break;	
				case K_KEY :		K = false;				break;	
				case L_KEY :		L = false;				break;	
				case M_KEY :		M = false;				break;	
				case N_KEY :		N = false;				break;	
				case O_KEY :		O = false;				break;	
				case P_KEY :		P = false;				break;	
				case Q_KEY :		Q = false;				break;	
				case R_KEY :		R = false;				break;	
				case S_KEY :		S = false;				break;	
				case T_KEY :		T = false;				break;	
				case U_KEY :		U = false;				break;	
				case V_KEY :		V = false;				break;	
				case W_KEY :		W = false;				break;	
				case X_KEY :		X = false;				break;	
				case Y_KEY :		Y = false;				break;	
				case Z_KEY :		X = false;				break;	
				case SPACE_KEY :	SPACE 	= false;		break;	
				case SHIFT_KEY :	SHIFT 	= false;		break;	
				case UP_KEY :		UP 		= false;		break;	
				case DOWN_KEY :		DOWN 	= false;		break;	
				case LEFT_KEY :		LEFT 	= false;		break;	
				case RIGHT_KEY :	RIGHT 	= false;		break;	
				case PLUS_KEY :		PLUS 	= false;		break;	
				case MINUS_KEY :	MINUS 	= false;		break;	
				case num0_KEY :		zero 	= false;		break;
				case num1_KEY :		num1 	= false;		break;
				case num2_KEY :		num2 	= false;		break;
				case num3_KEY :		num3 	= false;		break;
				case num4_KEY :		num4 	= false;		break;
				case num5_KEY :		num5 	= false;		break;
				case num6_KEY :		num6 	= false;		break;
				case num7_KEY :		num7 	= false;		break;
				case num8_KEY :		num8 	= false;		break;
				case num8_KEY :		num9 	= false;		break;
			}
			dispatchEvent(e);
		}
		
		public function deactivate_handle(e:Event = null):void
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
		
		public function get isMouseDown():Boolean 		{ return _isMouseDown; }
		public function get isMouseClicked():Boolean 	{ return _isMouseClicked; }
		
		public function get mouseScreenPos():Point 		{ return _mouseScreenPos; }		
		public function get mouseWorldPos():Point 		{ return _mouseWorldPos; }
		
	}
}