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
		 * 当前单元格与起点和终点的距离之和 
		 */		
		public var distance:Number;
	}
}