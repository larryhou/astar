package com.larrio.astar
{
	import com.larrio.astar.map.MapCell;
	import com.larrio.astar.map.RegionMap;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.engine.Kerning;
	import flash.utils.Dictionary;
	
	/**
	 * 有新的操作时派发 
	 */	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * 寻路算法模拟器
	 * @author larryhou
	 * @createTime Jul 30, 2013 11:55:21 PM
	 */
	public class PathFindingSimulator extends EventDispatcher
	{
		public static const STEP_FORWARD:uint	= 1; // 向前移动
		public static const STEP_BACKWARD:uint	= 2; // 退后一步
		public static const STEP_CACULATE:uint	= 3; // 计算未知区域
		public static const STEP_FINISH:uint	= 4; // 搜索成功并结束
		public static const STEP_START:uint		= 1; // 开始搜索
		
		private var _step:uint;
		
		private var _cell:MapCell;
		private var _lastCell:MapCell;
		
		private var _includes:Dictionary;
		private var _excludes:Dictionary;
		
		private var _result:Vector.<MapCell>;
		
		private var _rounds:Vector.<MapCell>;
		
		private var _buffer:MapCell;
		private var _caculate:MapCell;
		
		private var _start:MapCell;
		private var _finish:MapCell;
		
		private var _map:RegionMap;
		
		/**
		 * 构造函数
		 * create a [PathFindingSimulator] object
		 */
		public function PathFindingSimulator()
		{
			
		}
		
		/**
		 * 设置寻路信息 
		 * @param start		寻路起点
		 * @param finish	寻路终点
		 */		
		public function setup(start:MapCell, finish:MapCell):void
		{
			_start = start; _finish = finish;
		}
		
		/**
		 * 进行下一步
		 */
		public function forward():Boolean
		{
			var key:String;
			var dx:int, dy:int;
			
			if (_step == STEP_CACULATE)
			{
				if (!_rounds.length)
				{
					if (!_buffer)
					{
						if (_result.length <= 1) return false;
						
						_lastCell = _cell;
						
						_cell = _result.pop();
						
						key = createKey(_cell.x, _cell.y);
						delete _includes[key];
						_excludes[key] = true;
						
						_cell = _result[_result.length - 1];
						_step = STEP_BACKWARD;
						
						notify();
						return true;
					}
					
					_lastCell = _cell;
					
					_cell = _buffer;
					_includes[createKey(_cell.x, _cell.y)] = true;
					
					_result.push(_cell);
					if (_cell.x == _finish.x && _cell.y == _finish.y) 
					{
						_step = STEP_FINISH;
					}
					else
					{
						_step = STEP_FORWARD;
					}
					
					notify();
					return _step == STEP_FORWARD;
				}
				
				while (_rounds.length)
				{
					_caculate = _rounds.shift();
					key = createKey(_caculate.x, _caculate.y);
					
					if (!_includes[key] && !_excludes[key]) 
					{
						dx = _finish.x - _caculate.x;
						dy = _finish.y - _caculate.y;
						
						_caculate.distance = Math.sqrt(dx * dx + dy * dy);
						if (_caculate.distance < _buffer.distance) 
						{
							_buffer = _caculate;
						}
						
						_step = STEP_CACULATE;
						
						notify();
						return true;
					}
				}
			}
			else
			if (_step == STEP_FORWARD)
			{
				_rounds = _map.getAroundCells(_cell.x, _cell.y);
				
				_buffer = null;
				while (_rounds.length)
				{
					_caculate = _rounds.shift();
					key = createKey(_caculate.x, _caculate.y);
					if (!_includes[key] && !_excludes[key]) 
					{
						_buffer = _caculate;
						_step = STEP_CACULATE;
						
						dx = _finish.x - _buffer.x;
						dy = _finish.y - _buffer.y;
						
						_buffer.distance = Math.sqrt(dx * dx + dy * dy);
						
						notify();
						return true;
					}
				}
				
				_step = STEP_CACULATE; return forward();
			}
			else
			if (_step == STEP_BACKWARD || _step == STEP_START)
			{
				_step = STEP_FORWARD; return forward();
			}
			else
			if (_step == STEP_FINISH)
			{
				return false;
			}
			else
			{
				_cell = _start;
				
				key = createKey(_cell.x, _cell.y);
				
				_includes = new Dictionary(true);
				_excludes = new Dictionary(true);
				_includes[key] = _excludes[key] = true;
				
				_result = new Vector.<MapCell>;
				_result.push(_cell);
				_step = STEP_START;
				
				notify();
			}
			
			return true;
		}
		
		private function createKey(x:uint, y:uint):String { return x + ":" + y; }
		
		/**
		 * 广播事件
		 */		
		private function notify():void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * 当前步骤
		 */		
		public function get step():uint { return _step; }

		/**
		 * 当前寻路位置
		 */		
		public function get cell():MapCell { return _cell; }

		/**
		 * 将要移动的位置
		 */		
		public function get lastCell():MapCell { return _lastCell; }

		/**
		 * 寻路结果
		 */		
		public function get result():Vector.<MapCell> { return _result; }

		/**
		 * 持续更新的最优单元格
		 */		
		public function get buffer():MapCell { return _buffer; }

		/**
		 * 寻路地图
		 */		
		public function get map():RegionMap { return _map; }
		public function set map(value:RegionMap):void
		{
			_map = value;
		}

		/**
		 * 当前正在计算的单元格
		 */	
		public function get caculate():MapCell { return _caculate; }

	}
}