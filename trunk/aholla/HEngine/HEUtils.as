package aholla.HEngine
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	/**
	 * Maths Utility class based on functions writen by Iain Lobb.
	 */
	
	public class HEUtils 
	{
		/*
		public static var TWO_PI				:Number = Math.PI * 2;
		public static var PI_OVER_TWO			:Number = Math.PI / 2;
		public static var PI_OVER_FOUR			:Number = Math.PI / 4;
		public static var PI_OVER_EIGHT			:Number = Math.PI / 8;
		
		public static var CIRCLE				:Number = Math.PI * 2;
		public static var HALF_CIRCLE			:Number = Math.PI;
		public static var QUARTER_CIRCLE		:Number = Math.PI / 2;
		public static var EIGHTH_CIRCLE			:Number = Math.PI / 4;
		public static var SIXTEENTH_CIRCLE		:Number = Math.PI / 8;
		
		public static var DEGREES_TO_RADIANS	:Number = Math.PI / 180;
		public static var RADIANS_TO_DEGREES	:Number = 180 / Math.PI;
		*/
		
		public static var PI				:Number = 3.1415926535897932384626433832795;
		public static var TO_RADIANS		:Number = 0.01745329251994329576923690768489;
		public static var TO_DEGREES		:Number = 57.295779513082320876798154814105;
		
		public function HEUtils() 
		{			
		}
		
		public static function getAngle($pointA:Point, $pointB:Point):Number 
		{
			var dx:Number = $pointB.x - $pointA.x;
			var dy:Number = $pointB.y - $pointA.y;	
			return Math.atan2(dy, dx);
		}
		
		static public function bytesToXML($bytes:ByteArray):XML
		{
			return XML($bytes.readUTFBytes($bytes.length));
		}
		
		/*
		public static function random(from:Number = 0, to:Number = 1):Number
		{
			return (Math.random() * (to - from)) + from;
		}
		
		public static function randomInt(equalOrGreaterThan:Number = 0, lessThan:Number = 1):int
		{
			return Math.floor(MathHelper.random(equalOrGreaterThan, lessThan));
		}
		
		public static function randomIntInclusive(from:Number = 0, to:Number = 1):int
		{
			return Math.floor(MathHelper.randomInt(from, to + 1));
		}
		
		public static function randomBoolean(chance:Number = 0.5):Boolean
		{
			return Math.random() < chance;
		}
		
		public static function randomPlusMinus(chance:Number = 0.5):int
		{
			return (Math.random() < chance) ? -1 : 1;
		}
		
		public static function roundToDecimalPlaces(number:Number, decimalPlaces:int):Number
		{
			var shift:int = Math.pow(10, decimalPlaces);
			return Math.round(number * shift) / shift;
		}
		
		public static function floorToDecimalPlaces(number:Number, decimalPlaces:int):Number
		{
			var shift:int = Math.pow(10, decimalPlaces);
			return Math.floor(number * shift) / shift;
		}
		
		public static function ceilToDecimalPlaces(number:Number, decimalPlaces:int = 0):Number
		{
			var shift:int = Math.pow(10, decimalPlaces);
			return Math.ceil(number * shift) / shift;
		}
		
		public static function getSign(value:Number):Number
		{
			return (value >= 0) ? 1 : -1;
		}
		
		public static function shortestAngle(angle1:Number, angle2:Number):Number
		{
			var pi:Number = Math.PI;
			var pi2:Number = pi*2;
			
			angle1 = (Math.abs(angle1)>pi2) ? (angle1<0) ? angle1%pi2+ pi2 : angle1%pi2 : angle1;
      		angle2 = (Math.abs(angle2)>pi2) ? (angle2<0) ? angle2%pi2+ pi2 : angle2%pi2 : angle2;
      		
      		var diff:Number = angle1-angle2;
      		diff += (Math.abs(diff) <pi) ? 0 : (diff>0) ? -pi2 : pi2;
      		
      		return diff;
		}
		
		
		public static function getDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			return Math.sqrt((dx * dx) + (dy * dy));
		}
		
		public static function constrain(value:Number, min:Number = 0, max:Number = 1):Number
		{
			if (value > max)
			{
				return max;
			}
			else if (value < min)
			{
				return min;
			}
			
			return value;
		}
		
		public static function boxesCollide(left1:Number, right1:Number, top1:Number, bottom1:Number, left2:Number, right2:Number, top2:Number, bottom2:Number):Boolean
		{
			if (bottom1 < top2)
			{
				return false;
			}
			else if (top1 > bottom2)
			{
				return false;
			}
			else if (right1 < left2)
			{
				return false;
			}
			else if (left1 > right2)
			{
				return false;
			}
			
			return true;
		}
		
		public static function convertToFraction(value:Number, lowerLimit:Number, upperLimit:Number):Number
		{
			var range:Number = upperLimit - lowerLimit;
			var valueOffset:Number = value - lowerLimit;
			return valueOffset / range;
		}
		
		public static function convertToRange(value:Number, lowerLimit:Number, upperLimit:Number):Number
		{
			var range:Number = upperLimit - lowerLimit;
			return lowerLimit + (value * range);
		}
		
		public static function convertRanges(value:Number, lowerLimit1:Number, upperLimit1:Number, lowerLimit2:Number, upperLimit2:Number):Number
		{
			var fraction:Number = convertToFraction(value, lowerLimit1, upperLimit1);
			return convertToRange(fraction, lowerLimit2, upperLimit2);
		}
		
		public static function isWithinRange(value:Number, lowerLimit:Number, upperLimit:Number):Boolean
		{
			return value > lowerLimit && value < upperLimit;
		}
		
			
		public static function smallestAngle(angle:Number, targetAngle:Number):Number
		{
			angle = limitRadians(angle);
			targetAngle = limitRadians(targetAngle);
			
			// STANDARD
			
			var difference1:Number = targetAngle - angle;
			
			// "ROUND THE HORN" CLOCKWISE / POSITIVE 
			
			var difference2:Number = (targetAngle + (Math.PI * 2)) - angle;
						
			// "ROUND THE HORN" ANTI-CLOCKWISE / NEGATIVE 
			
			var difference3:Number = (targetAngle - (Math.PI * 2)) - angle;
			
			// GET SHORTEST		
			
			var absDifference1:Number = Math.abs(difference1);
			var absDifference2:Number = Math.abs(difference2);
			var absDifference3:Number = Math.abs(difference3);
			
			var difference:Number = difference1;
			
			if (absDifference2 < absDifference1 && absDifference2 < absDifference3)
			{
				difference = difference2;
			}
			else if (absDifference3 < absDifference1 && absDifference3 < absDifference2)
			{
				difference = difference3;
			}
			
			return difference;
		}
		
		public static function limitPlusMinus(value:Number, max:Number):Number
		{
			var output:Number = Math.min(Math.abs(value), max);
			output *= MathHelper.getSign(value);
			
			return output;
		}
		
		// LIMIT RADIANS 
		//limit angle to +/- PI
		
		public static function isBetweenOrEqualTo(value:Number, lowerLimit:Number, upperLimit:Number):Boolean
		{
			return value >= lowerLimit && value <= upperLimit;
		}
		
		public static function isBetweenButNotEqualTo(value:Number, lowerLimit:Number, upperLimit:Number):Boolean
		{
			return value > lowerLimit && value < upperLimit;
		}
		
		public static function limitRadians(angle:Number):Number
		{
			if (angle >= 0)
			{
				while (angle > Math.PI)
				{
					angle -= MathHelper.TWO_PI;
				}
			}
			else
			{
				while (angle < -Math.PI)
				{
					angle += MathHelper.TWO_PI;
				}
			}
			
			return angle;
		}
		
		
		public static function hyp(x1:Number, y1:Number, x2:Number, y2:Number):Number 
		{
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			
			return Math.sqrt((dx*dx)+(dy*dy));
		}
		
		public static function getAngle(x1:Number, y1:Number, x2:Number, y2:Number):Number 
		{
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			
			return Math.atan2(dx, dy);
		}
		
		public static function magnitude(dx:Number, dy:Number):Number 
		{
			return Math.sqrt((dx*dx)+(dy*dy));
		}
		
		public static function closerThan(x1:Number, y1:Number, x2:Number, y2:Number, distance:Number):Boolean 
		{
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			
			return (dx*dx)+(dy*dy) < distance * distance;
		}
		
		*/
		
	}
	
}