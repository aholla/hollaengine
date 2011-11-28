/**
 * ...
 * @author Adam
 */

package aholla.henginex.core.entity;
import nme.geom.Point;
import nme.geom.Rectangle;


//interface ITransformComponent extends IComponent
interface ITransformComponent implements IComponent
{	
	function isOnscreen():Bool;	
	var x:Int;
	var y:Int;
	var z:Int;
	var zIndex:Int;
	var width:Int;
	var height:Int;
	var rotation:Float;
	var scale:Float;
	var scaleX:Float;
	var scaleY:Float;
	var velocity:Point;
	var acceleration:Point;
	var bounds:Rectangle;
	var layerIndex:Float;
	var hasMoved:Bool;
	var isDirty:Bool;	
}	