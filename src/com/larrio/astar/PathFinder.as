package com.larrio.astar
{
	import com.larrio.astar.map.MapCell;
	import com.larrio.astar.map.RegionMap;
	
	import flash.utils.Dictionary;
	
	/**
	 * 路径搜索器
	 * @author larryhou
	 * @createTime Jul 30, 2013 7:36:18 PM
	 */
	public class PathFinder
	{
		private var _optimal:Boolean;
		private var _diagnal:Boolean;
		
		private var _map:RegionMap;
		
		/**
		 * 构造函数
		 * create a [PathFinder] object
		 */
		public function PathFinder(optimal:Boolean = true, diagnal:Boolean = false)
		{
			_optimal = optimal; _diagnal = diagnal;
		}
		
		/**
		 * 在制定地图上查找 
		 * @param start		搜索起点
		 * @param finish	搜索终点
		 * @return 返回路径列表
		 */		
		public function search(start:MapCell, finish:MapCell):Vector.<MapCell>
		{
			if (!_map || !start || !finish) return null;
			
			var includes:Dictionary = new Dictionary(true);
			var excludes:Dictionary = new Dictionary(true);
			
			var result:Vector.<MapCell> = new Vector.<MapCell>;
			
			var cell:MapCell, key:String;
			
			key = createKey(start.x, start.y);
			includes[key] = excludes[key] = true;
			
			result.push(cell = start);
			
			var rounds:Vector.<MapCell>;
			
			var c1:MapCell, c2:MapCell;
			while (cell.x != finish.x || cell.y != finish.y)
			{
				rounds = _map.getAroundCells(cell.x, cell.y, _diagnal, false);
				
				c2 = null;
				while (rounds.length)
				{
					c1 = rounds.shift();
					key = createKey(c1.x, c1.y);
					if (excludes[key] || includes[key]) continue;
					
					if (!_optimal)
					{
						c2 = c1; break;
					}
					
					var dx:int, dy:int;
					
					dx = finish.x - c1.x;
					dy = finish.y - c1.y;
					c1.distance = Math.sqrt(dx * dx + dy * dy);
					
					if (!c2 || c1.distance < c2.distance) c2 = c1;
				}
				
				if (!c2)
				{
					if (result.length >= 2)
					{
						cell = result.pop();
						key = createKey(cell.x, cell.y);
						excludes[key] = true;
						delete includes[key];
						
						cell = result[result.length - 1];
						continue;
					}
					
					if (result.length == 1) return null;
				}
				
				result.push(cell = c2);
				
				key = createKey(cell.x, cell.y);
				includes[key] = true;
			}
			
			return result;
		}		
		
		/**
		 * 生成映射键值 
		 */		
		private function createKey(x:uint, y:uint):String
		{
			return x + ":" + y;
		}

		/**
		 * 是否查找最优路径
		 */		
		public function get optimal():Boolean { return _optimal; }
		public function set optimal(value:Boolean):void
		{
			_optimal = value;
		}

		/**
		 * 搜索地图
		 */		
		public function get map():RegionMap { return _map; }
		public function set map(value:RegionMap):void
		{
			_map = value;
		}

		/**
		 * 搜索的路径是否包含对角方向
		 */		
		public function get diagnal():Boolean { return _diagnal; }
		public function set diagnal(value:Boolean):void
		{
			_diagnal = value;
		}

	}
}