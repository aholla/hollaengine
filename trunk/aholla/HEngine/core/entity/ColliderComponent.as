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
		private var _bounds							:Rectangle;		
		private var _isCollider						:Boolean;
		private var _colliderGroup					:String;
		private var _quadtreeNode					:QuadtreeNode;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function ColliderComponent() 
		{
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
		
		public function init($shape:IShape, $isCollider:Boolean = true, $offsetX:Number = 0, $offsetY:Number = 0, $colliderGroup:String = null, $scaleX:Number = 0, $scaleY:Number = 0):void 
		{
			_isCollider 	= $isCollider;
			_colliderGroup	= $colliderGroup;			
			_shape 			= $shape;
			//_shape.scaleX	= $scaleX;
			//_shape.scaleY	= $scaleY;
			//_shape.scale 	= ($scaleX > $scaleY) ? $scaleX: $scaleY;
			//_shape.translate($offsetX, $offsetY);	
			
			_bounds 		= _shape.bounds;
			
			trace("shape bounds", _shape.bounds)
			
			owner.transform.width = _bounds.width;
			owner.transform.height = _bounds.height;
			//owner.transform.bounds = _bounds;
			owner.transform.isDirty = false;
		}
		
		public function render($graphic:Sprite, $colour:uint = 0x00FFFF):void
		{			
			_shape.render($graphic.graphics, $colour);			
			//$graphic.x -= owner.renderer.offsetX / owner.transform.scaleX;
			//$graphic.y -= owner.renderer.offsetY / owner.transform.scaleY;			
			//$graphic.scaleX = 1 / owner.transform.scaleX;			
			//$graphic.scaleY = 1 / owner.transform.scaleY;			
		}		
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/		
		
		private function setSize():void
		{
			//_shape.scale 	= owner.transform.scale;
			//_shape.scaleX 	= owner.transform.scaleX;
			//_shape.scaleY 	= owner.transform.scaleY;				
			_bounds 		= _shape.bounds;
			
			trace("shape bounds", _shape.bounds)
			
			owner.transform.width = _bounds.width;
			owner.transform.height = _bounds.height;
			//owner.transform.bounds = _bounds;	
			owner.transform.isDirty = false;
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/

		public function get bounds():Rectangle					{	return _bounds; }
		public function get shape():IShape						{	return _shape; }		
		public function set shape($shape:IShape):void 
		{
			_shape 	= $shape;
			_bounds = _shape.bounds;
		}
		
		public function get colliderGroup():String 				{ 	return _colliderGroup;}		
		public function set colliderGroup($value:String):void 	{	_colliderGroup = String($value);	}
		
		public function get isCollider():Boolean 				{ 	return _isCollider;	}		
		public function set isCollider(value:Boolean):void 		{ 	_isCollider = value; }
		
		public function get offsetX():Number 
		{ 
			if (_shape)	
				return _shape.tx;
			else 
				return 0;
		}
		
		public function get offsetY():Number
		{ 
			if (_shape)	
				return _shape.ty;
			else 
				return 0;
		}		
		
		public function get quadtreeNode():QuadtreeNode { return _quadtreeNode;	}
		public function set quadtreeNode($value:QuadtreeNode):void 
		{
			_quadtreeNode = $value;
		}		
		
	}

}