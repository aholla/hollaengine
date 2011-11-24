package aholla.HEngine.core.entity 
{
	import aholla.HEngine.collision.QuadtreeNode;
	import aholla.HEngine.collision.shapes.IShape;
	import aholla.HEngine.core.entity.IEntity;
	import aholla.HEngine.HE;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/**
	 *
	 * @author Adam
	 */
	public class ColliderComponent extends Component implements IColliderComponent
	{
		private var _shape							:IShape;
		private var _isCollider						:Boolean;
		private var _colliderGroup					:String;
		private var _quadtreeNode					:QuadtreeNode;
		private var _offsetX						:int;
		private var _offsetY						:int;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function ColliderComponent() 
		{
			_offsetX = _offsetY = 0;
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/

		override public function onAdded($owner:IEntity, $name:String):void 
		{
			super.onAdded($owner, $name);
		}
		
		override public function start():void 
		{
			setSize();
			super.start();
		}
		
		override public function destroy():void 
		{
			HE.processManager.removeCollision(this.owner);
			_shape.destroy();
			_shape = null;
			_quadtreeNode = null;	
			super.destroy();
		}
		
		public function create($shape:IShape, $isCollider:Boolean = true, $offsetX:Number = 0, $offsetY:Number = 0, $colliderGroup:String = null):void 
		{
			_isCollider 	= $isCollider;
			_colliderGroup	= $colliderGroup;			
			_shape 			= $shape;			
			_shape.translate($offsetX, $offsetY);
			_offsetX = $offsetX;
			_offsetY = $offsetY;
			setSize();
		}
		
		public function render($graphic:Sprite, $colour:uint = 0x00FFFF):void
		{			
			_shape.render($graphic.graphics, $colour);		
		}		
		
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/		
		
		private function setSize():void
		{
			_shape.rotation = owner.transform.rotation;
			_shape.scale 	= owner.transform.scale;			
			_shape.scaleX 	= owner.transform.scaleX;
			_shape.scaleY 	= owner.transform.scaleY;
			
			owner.transform.width 	= _shape.bounds.width;
			owner.transform.height 	= _shape.bounds.height;	
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/

		public function get bounds():Rectangle					{	return _shape.bounds; }
		public function get shape():IShape						{	return _shape; }		
		public function set shape($shape:IShape):void 
		{
			_shape 	= $shape;
		}
		
		public function get colliderGroup():String 				{ 	return _colliderGroup;}		
		public function set colliderGroup($value:String):void 	{	_colliderGroup = String($value);	}
		
		public function get isCollider():Boolean 				{ 	return _isCollider;	}		
		public function set isCollider(value:Boolean):void 		{ 	_isCollider = value; }
		
		public function get offsetX():Number 					{ 		return _offsetX;	}		
		public function get offsetY():Number					{ 		return _offsetY;	}		
		
		public function get quadtreeNode():QuadtreeNode 			{ return _quadtreeNode;	}
		public function set quadtreeNode($value:QuadtreeNode):void 	{ _quadtreeNode = $value;	}
		
	}

}