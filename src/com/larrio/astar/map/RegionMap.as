package com.larrio.astar.map
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 地图生成器
	 * @author larryhou
	 * @createTime Jul 30, 2013 1:09:28 PM
	 */
	public class RegionMap
	{
		protected var _row:uint;
		protected var _column:uint;
		protected var _cellRenderClass:Class;
		
		protected var _dict:Dictionary;
		
		/**
		 * 构造函数
		 * create a [RegionMap] object
		 */
		public function RegionMap(row:uint, column:uint, cellRenderClass:Class = MapCell)
		{
			_row = row; _column = column; _cellRenderClass = cellRenderClass || MapCell;
			
			checkCellRenderValidate(_cellRenderClass);
			init();
		}
		
		/**
		 * 初始化单元格
		 */	
		private function init():void
		{
			_dict = new Dictionary();
			
			update();
		}
		
		/**
		 * 渲染地图
		 */		
		private function update():void
		{
			var key:String, cell:MapCell;
			for (var x:uint = 0; x < _column; x++)
			{
				for (var y:uint = 0; y < _row; y++)
				{
					key = createKey(x, y);
					if (!_dict[key])
					{
						_dict[key] = new _cellRenderClass() as MapCell;
					}
					
					cell = _dict[key];
					cell.x = x;
					cell.y = y;
				}
			}
		}
		
		/**
		 * 单元格渲染器有效性 
		 * @param renderClass
		 */		
		private function checkCellRenderValidate(renderClass:Class):Boolean
		{
			if (!renderClass) return true;
			
			var type:String = getQualifiedClassName(MapCell);
			if (type == getQualifiedClassName(renderClass)) return true;
			
			var superClass:XMLList = describeType(MapCell)..extendsClass.(@type == type);
			if (superClass.length() != 1)
			{
				throw new ArgumentError("[FATAL]" + renderClass + " must extend [" + getQualifiedClassName(MapCell) + "] super class!");
				return false;
			}
			
			return true;
		}
		
		/**
		 * 获取坐标映射键值 
		 * @param x	当前列
		 * @param y	当前行
		 */		
		private function createKey(x:uint, y:uint):String
		{
			return x + ":" + y;
		}
		
		/**
		 * 获取单元格 
		 * @param x	单元格所在列
		 * @param y	单元格所在行
		 * @return 	单元格实例对象
		 */		
		public function getCell(x:uint, y:uint):MapCell
		{
			return _dict[createKey(x, y)] as MapCell;
		}
		
		/**
		 * 覆盖默认单元格 
		 * @param x		单元格所在列
		 * @param y		单元格所在行
		 * @param cell	单元格实例对象
		 */		
		public function setCell(x:uint, y:uint, cell:MapCell):void
		{
			cell ||= new MapCell();
			cell.x = x;
			cell.y = y;
			
			_dict[createKey(x, y)] = cell;
		}
		
		/**
		 * 获取一个矩形区域的单元格 
		 * @param x			起始列
		 * @param y			起始行
		 * @param width		矩形宽度
		 * @param height	举行高度
		 * @return 单元格列表
		 */		
		public function getRegionCells(x:uint, y:uint, width:uint, height:uint):Vector.<MapCell>
		{
			var result:Vector.<MapCell> = new Vector.<MapCell>;
			
			var key:String;
			for (var i:int = y; i < y + height; i++)
			{
				for (var j:int = x; j < x + width; j++)
				{
					key = createKey(j, i);
					result.push(_dict[key] as MapCell);
				}
			}
			
			return result;
		}
		
		/**
		 * 设置一个矩形区域为障碍物 
		 * @param x			起始列
		 * @param y			起始行
		 * @param width		矩形宽度
		 * @param height	举行高度
		 * @param obstacle	是否为障碍物
		 * @return 矩形区域的单元格列表
		 */
		public function setRegionAsObstacle(x:uint, y:uint, width:uint, height:uint, obstacle:Boolean = true):Vector.<MapCell>
		{
			var result:Vector.<MapCell> = new Vector.<MapCell>;
			
			var key:String, cell:MapCell;
			for (var i:int = y; i < y + height; i++)
			{
				for (var j:int = x; j < x + width; j++)
				{
					key = createKey(j, i);
					cell = _dict[key] as MapCell;
					cell.obstacle = obstacle;
					result.push(cell);
				}
			}
			
			return result;
		}
		
		/**
		 * 设置障碍物 
		 * @param x	所在列
		 * @param y	所在行
		 * @param obstacle	是否为障碍物
		 */		
		public function setObstacle(x:uint, y:uint, obstacle:Boolean = true):MapCell
		{
			var cell:MapCell = getCell(x, y);
			if (cell) cell.obstacle = obstacle;
			return cell;
		}
		
		/**
		 * 获取坐标周围的单元格 
		 * @param x			对应列
		 * @param y			对应行
		 * @param diagnal	是否包含对角线的单元格
		 * @param obstacle	是否包含障碍物单元格
		 */		
		public function getAroundCells(x:uint, y:uint, diagnal:Boolean = false, obstacle:Boolean = false):Vector.<MapCell>
		{
			var result:Vector.<MapCell> = new Vector.<MapCell>;
			
			var cell:MapCell;
			for (var i:int = -1; i <= 1; i++)
			{
				for (var j:int = -1; j <= 1; j++)
				{
					if (i == 0 && j == 0) continue;
					
					cell = getCell(x + j, y + i);
					if (cell)
					{
						if (!obstacle && cell.obstacle) continue;
						if (!diagnal && Math.abs(i) + Math.abs(j) == 2) continue;
						result.push(cell);
					}
				}
			}
			
			return result;
		}
		
		/**
		 * 单元格类
		 */		
		public function get cellRenderClass():Class { return _cellRenderClass; }
		public function set cellRenderClass(value:Class):void
		{
			value ||= MapCell;
			checkCellRenderValidate(value);
			
			if (value != _cellRenderClass)
			{
				_cellRenderClass = value; init();
			}
			else
			{
				_cellRenderClass = value; update();
			}			
		}

		/**
		 * 地图行数
		 */	
		public function get row():uint { return _row; }
		public function set row(value:uint):void
		{
			_row = Math.max(1, value); update();
		}

		/**
		 * 地图列数
		 */
		public function get column():uint { return _column; }
		public function set column(value:uint):void
		{
			_column = Math.max(1, value); update();
		}
	}
}