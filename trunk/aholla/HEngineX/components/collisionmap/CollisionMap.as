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
			var rowLength:int = $collisionArr.length;
			var colLength:int = $collisionArr[0].length;
			
			for (var row:int = 0; row < rowLength; row++) 
			{
				for (var col:int = 0; col < colLength; col++) 
				{
					var type:int = $collisionArr[row][col];
					if (type > 0)
					{
						var tile:CollisionTile = new CollisionTile;
						tile.initTile(type, row, col, $tileW, $tileH, $xOffset, $yOffset, $isCentered);						
					}
				}
			}
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