package larrio
{
	import com.larrio.astar.PathFinder;
	import com.larrio.astar.map.MapCell;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	[SWF(width="1024", height="768", frameRate="60")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 30, 2013 12:59:15 PM
	 */
	public class SimpleMain extends Sprite
	{
		private var _map:GameMap;
		private var _finder:PathFinder;
		
		/**
		 * 构造函数
		 * create a [SimpleMain] object
		 */
		public function SimpleMain()
		{
			addChild(_map = new GameMap(25, 33));
			
			_map.x = _map.y = 10;
			
			_finder = new PathFinder(true, false);
			_finder.map = _map.map;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		
		protected function keyHandler(e:KeyboardEvent):void
		{
			if (e.keyCode != Keyboard.ENTER) return;
			
			var result:Vector.<MapCell> = _finder.search(_map.start.cell, _map.finish.cell);
			if (result)
			{
				result.shift();
				result.pop();
				
				var cell:MapCell, item:NodeItem;
				for (var i:int = 0; i < result.length; i++)
				{
					cell = result[i];
					item = _map.getItem(cell.x, cell.y);
					if (item) 
					{
						item.status = ItemStatusType.PATH;
						item.label = i;
					}
					
					trace(i + ".{x:" + cell.x + ", y:" + cell.y + "}");
				}
			}
		}
	}
}