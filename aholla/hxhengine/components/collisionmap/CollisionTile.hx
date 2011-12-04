/**
* This is a collision tile. Extend this class to creat your own custom shaped tiles from teh Colliions Map.
* @author Adam
*/

package aholla.hxhengine.components.collisionmap ;

import aholla.hxhengine.collision.shapes.Box;
import aholla.hxhengine.collision.shapes.Polygon;
import aholla.hxhengine.core.entity.IEntity;
import aholla.hxhengine.core.entity.RendererComponent;
import aholla.hxhengine.core.Logger;
import aholla.hxhengine.HE;
import flash.geom.PoInt;

class CollisionTile
{
	static public const TILE					:String = "tile";
	
	private var id								:Int;
	private var type							:Int;
	private var tileW							:Int;
	private var tileH							:Int;
	private var col								:Int;
	private var row								:Int;
	private var offset							:PoInt;
	private var isCentered						:Bool;
	
/*--------------------------------------------------
* PUBLIC CONSTRUCTOR
--------------------------------------------------*/
	
	public function CollisionTile() 
	{
	}		
	
/*-------------------------------------------------
* PUBLIC METHODS
-------------------------------------------------*/
	
	public function initTile(type:Int, row:Int, col:Int, tileW:Int, tileH:Int, offsetX:Int = 0, offsetY:Int = 0, isCentered:Bool = true):Void 
	{
		id 		= row * col;
		type 	= type;
		row		= row;
		col		= col;
		tileW 	= tileW;
		tileH 	= tileH;
		offset	= new PoInt(offsetX, offsetY);
		isCentered = isCentered;
		
		var polyArr:Array;			
		switch(type)
		{
			case 0:
				// Floor tiles, no collision needed.
				return;
			break;
			
			case 1:	
				// Square collision.
				polyArr = returnBox();
			break;
			
			case 2:	
				// Top left triangle 
				polyArr = returnTLTraiangle();
			break;
			
			case 3:	
				// Top right triangle 
				polyArr = returnTRTraiangle();
			break;
			
			case 4:	
				// Bottom left triangle 
				polyArr = returnBLTraiangle();
			break;
			
			case 5:	
				// Bottom right triangle 
				polyArr = returnBRTraiangle();
			break;
			
			
			//default:
				//Logger.error(this, "CollisionTile - tile Float not listed: " + type);
				//return;
		}	
		
		createTile(type, polyArr, 0xFF0000);
	}
	
/*-------------------------------------------------
* PRIVATE METHODS
-------------------------------------------------*/
	
	private function returnBox():Array 
	{
		var arr:Array = [];
		arr.push(new PoInt(0, 0));
		arr.push(new PoInt(tileW, 0));
		arr.push(new PoInt(tileW, tileH));
		arr.push(new PoInt(0, tileH));
		return arr;
	}
	
	private function returnTLTraiangle():Array 
	{
		var arr:Array = [];
		arr.push(new PoInt(0, 0));
		arr.push(new PoInt(tileW, 0));
		arr.push(new PoInt(0, tileH));
		return arr;
	}
	
	private function returnTRTraiangle():Array 
	{
		var arr:Array = [];
		arr.push(new PoInt(0, 0));
		arr.push(new PoInt(tileW, 0));
		arr.push(new PoInt(tileW, tileH));
		return arr;
	}
	
	private function returnBLTraiangle():Array 
	{
		var arr:Array = [];
		arr.push(new PoInt(0, 0));
		arr.push(new PoInt(tileW, tileH));
		arr.push(new PoInt(0, tileH));
		return arr;
	}
	
	private function returnBRTraiangle():Array 
	{
		var arr:Array = [];
		arr.push(new PoInt(tileW, 0));
		arr.push(new PoInt(tileW, tileH));
		arr.push(new PoInt(0, tileH));
		return arr;
	}
	
	
	private function createTile(type:Int, polyArr:Array, colour:Uint):Void 
	{
		var _tileEntity:IEntity  = HE.allocateEntity(TILE);
		_tileEntity.groupName = TILE;
		
		_tileEntity.transform.x = (col * tileW) + offset.x;
		_tileEntity.transform.y = (row * tileH) + offset.y;
		
		if (isCentered)
		{
			_tileEntity.transform.x += tileW * 0.5;
			_tileEntity.transform.y += tileH * 0.5;
		}			 
		_tileEntity.createCollider(Polygon.fromArray(polyArr, true), false, 0, 0, TILE);		 
		_tileEntity.start();
	}
	
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
	
	
	
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
	
		
}