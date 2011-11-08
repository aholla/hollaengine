package aholla.utils.pathfinding.astar
{
	public final class AStarNode
	{
		
		// -------------------------------------------------------
		// Variables
		// -------------------------------------------------------
		
		public var x						:int;
		public var y						:int;
		public var g						:Number;
		public var h						:Number;
		public var f						:Number;
		public var cost						:Number;
		public var terrainCost				:Number;
		public var parent					:AStarNode;
		public var walkable					:Boolean;
		
		// -------------------------------------------------------
		// Public Functions
		// -------------------------------------------------------
		
		/**
		 * Creates a new instance of <i>AStarNode</i>.
		 * @param $x
		 * @param $y
		 * @param $walkable
		 */
		public function AStarNode($x:int, $y:int, $walkable:Boolean = true)
		{
			x = $x;
			y = $y;
			walkable = $walkable;
			init();
		}
		
		// -------------------------------------------------------
		// Private Functions
		// -------------------------------------------------------
		
		private function init():void
		{
			g = h = f = cost = terrainCost = 0;			
		}	
		
	}	
	
}