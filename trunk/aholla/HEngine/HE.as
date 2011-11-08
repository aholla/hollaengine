/**
 * HE (Game Engine) - (H Engine)
 * 
 * Game Engine/Framework based upon the PushButton Engine.
 * Follows a similar stucture to PBE but has been simplified
 * and customised.
 * 
 * - Initially built to work with the DisplayList. 
 * - To not require Box2D for collisions.
 *  
 * For more info on Component based game engines, watch 
 * Ben Garneys video on 'Understanding Components' in PBE: 
 * http://www.youtube.com/watch?v=auaqZzcjl-Y
 * 
 * Dependancies:
 * - Signals
 * - DataStructurs (SLL - single linked lists)
 * - DoobStats
 * 
 * TODO
 * - Lots....
 * This is teh version that uses SLL's instead of Vectors.
 * Version 00.00.04.
 * 
 * @author Adam Holland
 */

 
package aholla.HEngine
{	
	import aholla.HEngine.core.Camera;
	import aholla.HEngine.core.entity.IEntity;
	import aholla.HEngine.core.Logger;
	import aholla.HEngine.core.World;
	import aholla.HEngine.managers.EntityManager;
	import aholla.HEngine.managers.InputManager;
	import aholla.HEngine.managers.ProcessManager;
	import aholla.HEngine.managers.RenderManager;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class HE extends Sprite
	{
		static public var VERSION					:String = "00.00.04.";
		static public var SCREEN_WIDTH				:int;
		static public var SCREEN_HEIGHT				:int;
		static public var WORLD_WIDTH				:int;
		static public var WORLD_HEIGHT				:int;		
		
		static public var entityManager				:EntityManager;
		static public var processManager			:ProcessManager;
		
		static public var camera					:Camera;		
		static public var stage						:Stage;		
		static public var scene						:DisplayObjectContainer;
		static public var world						:World;
		
		static public var isDebug					:Boolean = false;
		
		static private var sortDepths				:Boolean;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function HE() 
		{
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/		
		
		static public function init($scene:DisplayObjectContainer, $width:int, $height:int, $sortDepths:Boolean = false, $useDisplayList:Boolean = false, $consoleCode:String = "aholla"):void
		{			
			scene 			= $scene;
			SCREEN_WIDTH 	= $width;
			SCREEN_HEIGHT 	= $height;
			sortDepths		= $sortDepths;
			stage 			= $scene.stage;
			
			WORLD_WIDTH 	= SCREEN_WIDTH;
			WORLD_HEIGHT 	= SCREEN_HEIGHT;			
			WORLD_WIDTH 	= SCREEN_WIDTH;
			WORLD_HEIGHT 	= SCREEN_HEIGHT;
			
			stage.align 	= StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			world = new World();
			scene.addChild(world);
			
			camera = new Camera();
			
			entityManager 	= new EntityManager();
			processManager 	= new ProcessManager(sortDepths);
			
			Logger.init($scene, $consoleCode);
		}
		
		static public function allocateEntity($name:String):IEntity 
		{
			if (entityManager)
			{
				return entityManager.createEntity($name);
			}
			else
			{
				Logger.error("HE.allocateEntity: entity manager does not exist. Make sure you have initialised the engine. HE.init()");
				return null;
			}
		}
		
		static public function focus():void
		{
			if(world)	stage.focus = world.stage;
		}		
		
		static public function start():void 
		{
			processManager.start();
			camera.start();
			focus();
		}
		
		static public function pause():void
		{
			processManager.pause();
		}
		
		static public function unPause():void
		{
			processManager.unPause();
			focus();
		}
		
		static public function destroy():void 
		{				
			processManager.pause();			
			
			camera.destroy();
			camera = null;
			
			entityManager.destroy();
			entityManager = null;				
			
			processManager.destroy();
			processManager = null;
			
			scene.removeChild(world);
			scene = null;
			
			world.destroy();
			world = null;			
		}
		
		static public function restart():void 
		{			
			processManager.pause();	
			
			camera.destroy();
			camera = null;	
			
			entityManager.destroy();						
			entityManager 	= null;
			
			processManager.destroy();
			processManager 	= null;	
			
			world.restart();			
			
			camera 			= new Camera();	
			entityManager 	= new EntityManager();
			processManager 	= new ProcessManager(sortDepths);
			
			start();
		}
		
		static public function updateWorldSize($width:int, $height:int):void
		{
			WORLD_WIDTH 	= $width;
			WORLD_HEIGHT 	= $height;
			processManager.updateWorldSize();
			world.updateWorldSize();
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
		
		static public function get isPaused():Boolean
		{
			return processManager.isPaused;
		}
		
		
	}
}