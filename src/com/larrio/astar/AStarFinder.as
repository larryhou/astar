package com.larrio.astar
{
	import com.larrio.astar.map.MapCell;
	import com.larrio.astar.map.RegionMap;
	
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Aug 1, 2013 1:26:46 AM
	 */
	public class AStarFinder
	{
		private var _map:RegionMap;
		
		/**
		 * 构造函数
		 * create a [AStarFinder] object
		 */
		public function AStarFinder()
		{
			
		}
		
		public function search(start:MapCell, finish:MapCell):Vector.<MapCell>
		{
			var sequence:uint;
			var buffer:MapCell = start;
			
			var includes:Dictionary = new Dictionary(true);
			var excludes:Dictionary = new Dictionary(true);
			
			excludes[createKey(buffer)] = buffer;
			
			var open:Vector.<MapCell> = new Vector.<MapCell>;
			
			var dx:uint, dy:uint, cell:MapCell;
			dx = Math.abs(finish.x - buffer.x);
			dy = Math.abs(finish.y - buffer.y);
			
			buffer.g = 1;
			buffer.h = dx + dy;
			buffer.f = buffer.g + buffer.h;
			
			var rounds:Vector.<MapCell>;
			
			var belong:MapCell;
			var i:int, length:uint;
			
			var movable:Boolean;
			var key:String, index:int, forward:Boolean = true;
			while (buffer.x != finish.x || buffer.y != finish.y)
			{
				if (forward)
				{
					belong = buffer; movable = false;
					rounds = _map.getAroundCells(belong.x, belong.y);
					for (i = 0, length = rounds.length; i < length; i++) 
					{
						cell = rounds[i];
						key = createKey(cell);
						if (excludes[key]) continue;
						movable = true;
						
						cell.belong = belong;
						cell.index = ++sequence;
						cell.g = belong.g + 1;
						
						dx = Math.abs(finish.x - cell.x);
						dy = Math.abs(finish.y - cell.y);
						
						cell.h = dx + dy;
						cell.f = cell.g + cell.h;
						
						if (includes[key])
						{
							if (cell.f < buffer.f)
							{
								index = open.indexOf(cell);
								open.splice(index, 1);
								
								delete includes[key];
								excludes[key] = cell;
								
								buffer = cell;
							}
						}
						else
						{
							open.push(cell);
							includes[key] = cell;
						}
					}
					
					if (!movable)	// 更换路径
					{
						cell = open.shift();
						key = createKey(cell);
						
						delete includes[key];
						excludes[key] = cell;
						
						buffer = cell;
						continue;
					}
					
					open.sort(sortRule);
					forward = false;
				}
				
				if (!open.length) return null;
				
				cell = open.shift();
				key = createKey(cell);
				
				delete includes[key];
				excludes[key] = cell;
				
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

	}
}