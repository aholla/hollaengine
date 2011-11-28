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
 * http://www.youtube.com/watchv=auaqZzcjl-Y
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

 
package aholla.henginex;

import aholla.henginex.core.Camera;
import aholla.henginex.core.entity.IEntity;
import aholla.henginex.core.Logger;
import aholla.henginex.core.World;
import aholla.henginex.managers.EntityManager;
import aholla.henginex.managers.ProcessManager;
import nme.display.DisplayObjectContainer;
import nme.display.Sprite;
import nme.display.Stage;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;

class HE extends Sprite
{
	//static public var VERSION					:String = "00.00.04.";
	static public var SCREEN_WIDTH				:Int;
	static public var SCREEN_HEIGHT				:Int;
	static public var WORLD_WIDTH				:Int;
	static public var WORLD_HEIGHT				:Int;
	static public var entityManager				:EntityManager;
	static public var processManager			:ProcessManager;
	static public var camera					:Camera;		
	static public var stage						:Stage;		
	static public var scene						:DisplayObjectContainer;
	static public var world						:World;	
	static public var isDebug					:Bool = false;
	static public var isDebugShowQuadTree		:Bool = false;
	
	static private var sortDepths				:Bool;
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function new() 
	{
		super();
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/		
	
	static public function init(scene:DisplayObjectContainer, width:Int, height:Int, sortDepths:Bool = false, useDisplayList:Bool = false, consoleCode:String = "aholla"):Void
	{			
		HE.scene 			= scene;
		HE.SCREEN_WIDTH 	= width;
		HE.SCREEN_HEIGHT 	= height;
		HE.sortDepths		= sortDepths;
		HE.stage 			= Lib.current.stage;
		
		HE.WORLD_WIDTH 		= SCREEN_WIDTH;
		HE.WORLD_HEIGHT 	= SCREEN_HEIGHT;			
		HE.WORLD_WIDTH 		= SCREEN_WIDTH;
		HE.WORLD_HEIGHT 	= SCREEN_HEIGHT;
		
		world = new World();
		scene.addChild(world);
		
		camera = new Camera();
		
		HE.entityManager 	= new EntityManager();
		processManager		= new ProcessManager(sortDepths);
		
		Logger.init(consoleCode);
	}
	
	static public function allocateEntity(name:String):IEntity 
	{
		if (entityManager != null)
		{
			return entityManager.createEntity(name);
		}
		else
		{
			Logger.error(HE, "HE.allocateEntity: entity manager does not exist. Make sure you have initialised the engine. HE.init()");
			return null;
		}
	}
	
	static public function focus():Void
	{
		if(world != null)	stage.focus = world.stage;
	}		
	
	static public function start():Void 
	{
		processManager.start();
		camera.start();
		focus();
	}
	
	static public function pause():Void
	{
		processManager.pause();
	}
	
	static public function unPause():Void
	{
		processManager.unPause();
		focus();
	}
	
	static public function destroy():Void 
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
	
	static public function restart():Void 
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
	
	static public function updateWorldSize(width:Int, height:Int):Void
	{
		WORLD_WIDTH 	= width;
		WORLD_HEIGHT 	= height;
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
	
	static public var isPaused(getIsPaused, null):Bool;
	
	static public function getIsPaused():Bool
	{
		return processManager.isPaused;
	}
	
	
}
