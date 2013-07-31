package com.larrio.astar.map
{
	
	/**
	 * 地图单元格
	 * @author larryhou
	 * @createTime Jul 30, 2013 1:11:00 PM
	 */
	public class MapCell
	{
		/**
		 * 单元格所在列 
		 */		
		public var x:uint;
		
		/**
		 * 单元格所在行 
		 */		
		public var y:uint;
		
		/**
		 * 是否为障碍物 
		 */		
		public var obstacle:Boolean;
		
		/**
		 * 距离起点的距离 
		 */		
		public var g:uint;
		
		/**
		 * 剩余路径估算长度 
		 */	
		public var h:uint;
		
		/**
		 * 路径估算长度 
		 */		
		public var f:uint;
		
		/**
		 * 索引 
		 */		
		public var index:uint;
		
		/**
		 * 父节点 
		 */		
		public var belong:MapCell;
		
		/**
		 * 扩展字段 
		 */		
		public var distance:Number;
	}
}