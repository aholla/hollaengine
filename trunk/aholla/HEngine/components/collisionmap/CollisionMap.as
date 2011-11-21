/**
 * ...
 * @author Adam
 */

package aholla.HEngine.components.collisionmap
{
	
	import aholla.HEngine.core.entity.IComponent;
	import aholla.HEngine.core.entity.Component;
	import aholla.HEngine.core.entity.IEntity;
	
	public class CollisionMap extends Component implements IComponent 
	{
		private var arr								:Array;
		private var tilesArr						:Vector.<CollisionTile>;
		private var tileW							:int;
		private var tileH							:int;
		private var _$isCentered					:Boolean;
		
/*--------------------------------------------------
* PUBLIC CONSTRUCTOR
--------------------------------------------------*/
		
		public function CollisionMap($x:int = 0, y:int = 0) 
		{
			
		}		
		
/*-------------------------------------------------
* PUBLIC METHODS
-------------------------------------------------*/
		
		public function initMap($collisionArr:Array, $tileW:int, $tileH:int, $xOffset:int = 0, $yOffset:int = 0, $isCentered:Boolean = true):void 
		{
			arr 	= $collisionArr;
			tileW 	= $tileW;
			tileH 	= $tileH;
			
			tilesArr = new Vector.<CollisionTile>();
			for (var row:int = 0; row < arr.length; row++) 
			{
				for (var col:int = 0; col < arr[0].length; col++) 
				{
					var tile:CollisionTile = new CollisionTile;
					var type:int = arr[row][col];
					tile.initTile(type, row, col, tileW, tileH, $xOffset, $yOffset, $isCentered);
					
					tilesArr[tilesArr.length] = tile;
				}
			}			
		}
		
		override public function destroy():void 
		{

			tilesArr.length = 0;
			super.destroy();
		}
		
		
/*-------------------------------------------------
* PRIVATE METHODS
-------------------------------------------------*/
		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		
	}	
}