/**
* ...
* @author Adam
*/

package aholla.henginex.components.collisionmap ;

import aholla.henginex.core.entity.IComponent;
import aholla.henginex.core.entity.Component;
import aholla.henginex.core.entity.IEntity;

class CollisionMap extends Component implements IComponent 
{
	
/*--------------------------------------------------
* PUBLIC CONSTRUCTOR
--------------------------------------------------*/
	
	public function CollisionMap(x:Int = 0, y:Int = 0) 
	{
		
	}		
	
/*-------------------------------------------------
* PUBLIC METHODS
-------------------------------------------------*/
	
	public function initMap(collisionArr:Array, tileW:Int, tileH:Int, xOffset:Int = 0, yOffset:Int = 0, isCentered:Bool = true):Void 
	{
		var rowLength:Int = collisionArr.length;
		var colLength:Int = collisionArr[0].length;
		
		for (var row:Int = 0; row < rowLength; row++) 
		{
			for (var col:Int = 0; col < colLength; col++) 
			{
				var type:Int = collisionArr[row][col];
				if (type > 0)
				{
					var tile:CollisionTile = new CollisionTile;
					tile.initTile(type, row, col, tileW, tileH, xOffset, yOffset, isCentered);						
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