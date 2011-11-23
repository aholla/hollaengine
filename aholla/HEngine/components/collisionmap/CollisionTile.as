/**
 * This is a collision tile. Extend this class to creat your own custom shaped tiles from teh Colliions Map.
 * @author Adam
 */

package aholla.HEngine.components.collisionmap
{
	
	import aholla.HEngine.collision.shapes.Box;
	import aholla.HEngine.collision.shapes.Polygon;
	import aholla.HEngine.core.entity.IEntity;
	import aholla.HEngine.core.entity.RendererComponent;
	import aholla.HEngine.core.Logger;
	import aholla.HEngine.HE;
	import flash.geom.Point;
	
	public class CollisionTile
	{
		static public const TILE					:String = "tile";
		
		private var id								:int;
		private var type							:int;
		private var tileW							:int;
		private var tileH							:int;
		private var col								:int;
		private var row								:int;
		private var offset							:Point;
		private var isCentered						:Boolean;
		
/*--------------------------------------------------
* PUBLIC CONSTRUCTOR
--------------------------------------------------*/
		
		public function CollisionTile() 
		{
		}		
		
/*-------------------------------------------------
* PUBLIC METHODS
-------------------------------------------------*/
		
		public function initTile($type:int, $row:int, $col:int, $tileW:int, $tileH:int, $offsetX:int = 0, $offsetY:int = 0, $isCentered:Boolean = true):void 
		{
			id 		= $row * $col;
			type 	= $type;
			row		= $row;
			col		= $col;
			tileW 	= $tileW;
			tileH 	= $tileH;
			offset	= new Point($offsetX, $offsetY);
			isCentered = $isCentered;
			
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
					//Logger.error(this, "CollisionTile - tile number not listed: " + type);
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
			arr.push(new Point(0, 0));
			arr.push(new Point(tileW, 0));
			arr.push(new Point(tileW, tileH));
			arr.push(new Point(0, tileH));
			return arr;
		}
		
		private function returnTLTraiangle():Array 
		{
			var arr:Array = [];
			arr.push(new Point(0, 0));
			arr.push(new Point(tileW, 0));
			arr.push(new Point(0, tileH));
			return arr;
		}
		
		private function returnTRTraiangle():Array 
		{
			var arr:Array = [];
			arr.push(new Point(0, 0));
			arr.push(new Point(tileW, 0));
			arr.push(new Point(tileW, tileH));
			return arr;
		}
		
		private function returnBLTraiangle():Array 
		{
			var arr:Array = [];
			arr.push(new Point(0, 0));
			arr.push(new Point(tileW, tileH));
			arr.push(new Point(0, tileH));
			return arr;
		}
		
		private function returnBRTraiangle():Array 
		{
			var arr:Array = [];
			arr.push(new Point(tileW, 0));
			arr.push(new Point(tileW, tileH));
			arr.push(new Point(0, tileH));
			return arr;
		}
		
		
		private function createTile($type:int, $polyArr:Array, $colour:uint):void 
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
			_tileEntity.createCollider(Polygon.fromArray($polyArr, true), false, 0, 0, TILE);		 
			_tileEntity.start();
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		
	}	
}