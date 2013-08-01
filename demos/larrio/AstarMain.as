package larrio
{
	import com.larrio.astar.AStarFinder;
	import com.larrio.astar.map.MapCell;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	[SWF(width="1024", height="768", frameRate="60")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Aug 1, 2013 2:29:05 AM
	 */
	public class AstarMain extends Sprite
	{
		private var _map:GameMap;
		private var _finder:AStarFinder;
		
		/**
		 * 构造函数
		 * create a [AstarMain] object
		 */
		public function AstarMain()
		{
			addChild(_map = new GameMap(25, 33));
			
			_map.x = _map.y = 10;
			_finder = new AStarFinder(true, true);
			_finder.map = _map.map;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		
		protected function keyHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ESCAPE)
			{
				_map.mouseChildren = true;
				_map.reset();
			}
			
			if (e.keyCode != Keyboard.ENTER) return;
			_map.mouseChildren = false;
			
			var item:NodeItem;
			var result:Vector.<MapCell> = _finder.search(_map.start.cell, _map.finish.cell);
			if (result.length > 2)
			{
				result.shift(); result.pop();
			}
			
			var cell:MapCell;
			for (var i:int = 0; i < result.length; i++)
			{
				cell = result[i];
				item = _map.getItem(cell.x, cell.y);
				if (item)
				{
					item.status = ItemStatusType.PATH;
					item.label = i.toString(); 
				}
			}
		}
	}
}