package com.larrio.astar
{
	import com.larrio.astar.map.MapCell;
	import com.larrio.astar.map.RegionMap;
	
	import flash.utils.Dictionary;
	
	/**
	 * A*寻路算法
	 * @author larryhou
	 * @createTime Aug 1, 2013 1:26:46 AM
	 */
	public class AStarFinder
	{
		private var _map:RegionMap;
		
		private var _diagnal:Boolean;
		private var _optimal:Boolean;
		private var _freeCross:Boolean;
		
		/**
		 * 构造函数
		 * create a [AStarFinder] object
		 */
		public function AStarFinder(optimal:Boolean = true, diagnal:Boolean = false, freeCross:Boolean = false)
		{
			_optimal = optimal; _diagnal = diagnal; _freeCross = freeCross;
		}
		
		/**
		 * 搜索路径 
		 * @param start  搜索起点
		 * @param finish 搜索终点
		 * @return 路径节点列表
		 */		
		public function search(start:MapCell, finish:MapCell):Vector.<MapCell>
		{
			if (!_map || !start || !finish) return null;
			
			var sequence:uint;
			var buffer:MapCell = start;
			
			var includes:Dictionary = new Dictionary(true);
			var excludes:Dictionary = new Dictionary(true);
			
			excludes[createKey(buffer)] = buffer;
			
			var open:Vector.<MapCell> = new Vector.<MapCell>;
			
			var dx:uint, dy:uint, cell:MapCell;
			dx = Math.abs(finish.x - buffer.x);
			dy = Math.abs(finish.y - buffer.y);
			
			buffer.g = 0;
			buffer.h = dx + dy;
			buffer.f = buffer.g + buffer.h;
			buffer.belong = null;
			
			var rounds:Vector.<MapCell>;
			var encounter:Vector.<MapCell>;
			
			var belong:MapCell;
			var i:int, length:uint;
			
			var movable:Boolean, diagnalCross:Boolean;
			var key:String, index:int, forward:Boolean = true;
			while (buffer.x != finish.x || buffer.y != finish.y)
			{
				if (forward)
				{
					forward = false;
					
					belong = buffer; movable = false;
					encounter = new Vector.<MapCell>();
					rounds = _map.getAroundCells(belong.x, belong.y, _diagnal);
					for (i = 0, length = rounds.length; i < length; i++) 
					{
						cell = rounds[i];
						key = createKey(cell);
						
						if (excludes[key]) continue;
						
						diagnalCross = (belong.x - cell.x) != 0 && (belong.y - cell.y) != 0
						if (diagnalCross)
						{
							if (!_freeCross && !checkCrossAvailable(belong, cell)) continue;
						}
						
						movable = true;
						if (includes[key])
						{
							encounter.push(cell);
						}
						else
						{
							cell.belong = belong;
							cell.index = ++sequence;
							
							dx = Math.abs(finish.x - cell.x);
							dy = Math.abs(finish.y - cell.y);
							
							cell.g = belong.g + (diagnalCross? 14 : 10);
							
							cell.h = dx + dy;
							cell.f = cell.g + cell.h;
							
							open.push(cell);
							includes[key] = true;
						}
					}
					
					while (encounter.length)
					{
						cell = encounter.shift();
						if (cell.g < buffer.g)
						{
							index = open.indexOf(cell);
							open.splice(index, 1);
							
							delete includes[key];
							excludes[key] = true;
							
							buffer = cell;
							forward = true;
							break;
						}
					}
					
					if (forward) continue;
					
					_optimal && open.sort(sortRule);
					
					if (!movable)	// 更换路径
					{
						cell = _optimal? open.shift() : open.pop();
						key = createKey(cell);
						
						delete includes[key];
						excludes[key] = true;
						
						buffer = cell;
						forward = true;
					}
					
					if (forward) continue;
				}
				
				if (!open.length) return null;
				
				cell = open.shift();
				key = createKey(cell);
				
				delete includes[key];
				excludes[key] = true;
				
				buffer = cell;
				forward = true;
			}
			
			var result:Vector.<MapCell> = new Vector.<MapCell>;
			result.push(buffer);
			
			while (buffer.belong)
			{
				buffer = buffer.belong;
				result.unshift(buffer);
			}
			
			return result;
		}
		
		/**
		 * 检查对角中间是否包含障碍物 
		 * @param buffer  当前位置
		 * @param cell    下一个单元格
		 * @return true为有效， false为不可穿越
		 */		
		private function checkCrossAvailable(buffer:MapCell, cell:MapCell):Boolean
		{
			var cross:MapCell;
			
			cross = _map.getCell(buffer.x, cell.y);
			if (!cross || cross.obstacle) return false;
			
			cross = _map.getCell(cell.x, buffer.y);
			if (!cross || cross.obstacle) return false;
			return true;
		}
		
		private function sortRule(c1:MapCell, c2:MapCell):int
		{
			if (c1.f > c2.f) return 1;
			if (c1.f < c2.f) return -1;
			return c1.index > c2.index? -1 : 1;
		}
		
		private function createKey(cell:MapCell):String { return cell.x + ":" + cell.y; }

		/**
		 * 寻路地图
		 */		
		public function get map():RegionMap { return _map; }
		public function set map(value:RegionMap):void
		{
			_map = value;
		}

		/**
		 * 对角位置是否可行走
		 */		
		public function get diagnal():Boolean { return _diagnal; }
		public function set diagnal(value:Boolean):void
		{
			_diagnal = value;
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
		 * 对角可以行走条件下，是否可以自由穿越有障碍对角点
		 */		
		public function get freeCross():Boolean { return _freeCross; }
		public function set freeCross(value:Boolean):void
		{
			_freeCross = value;
		}

	}
}