/**
 * ...
 * @author Adam
 */

package aholla.hxhengine.core.entity;
import nme.geom.Point;
import nme.geom.Rectangle;

interface ITransformComponent implements IComponent
{	
	function isOnscreen():Bool;	
	var x(default, setX):Int;
	var y(default, setY):Int;
	var z:Int;
	var zIndex:Int;
	var width(getWidth, setWidth):Int;
	var height(getHeight, setHeight):Int;
	var rotation(getRotation, setRotation):Float;
	var scale(getScale, setScale):Float;
	var scaleX(getScaleX, setScaleX):Float;
	var scaleY(getScaleY, setScaleY):Float;
	var velocity:Point;
	var acceleration:Point;
	var bounds(getBounds, null):Rectangle;
	var layerIndex:Float;
	var hasMoved:Bool;
	var isDirty:Bool;	
}	