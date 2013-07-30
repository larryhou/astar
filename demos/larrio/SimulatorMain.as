package larrio
{
	import com.larrio.astar.PathFinder;
	import com.larrio.astar.PathFindingSimulator;
	import com.larrio.astar.map.MapCell;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	[SWF(width="1024", height="768", frameRate="60")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 31, 2013 12:41:10 AM
	 */
	public class SimulatorMain extends Sprite
	{
		private var _map:GameMap;
		private var _simulator:PathFindingSimulator;
		
		private var _caculate:NodeItem;
		
		private var _index:uint;
		
		/**
		 * 构造函数
		 * create a [SimulatorMain] object
		 */
		public function SimulatorMain()
		{
			addChild(_map = new GameMap(25, 33));
			
			_map.x = _map.y = 10;
			
			_simulator = new PathFindingSimulator();
			_simulator.map = _map.map;
			
			_simulator.addEventListener(Event.CHANGE, changeHandler);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		
		protected function keyHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				_simulator.setup(_map.start.cell, _map.finish.cell);
				
				forward();
			}
		}
		
		private function forward():void
		{
			if (_simulator.forward())
			{
				setTimeout(forward, 50);
			}
		}
		
		protected function changeHandler(event:Event):void
		{
			var cell:MapCell, item:NodeItem;
			switch (_simulator.step)
			{
				case PathFindingSimulator.STEP_FORWARD:
				{
					cell = _simulator.cell;
					item = _map.getItem(cell.x, cell.y);
					item.status = ItemStatusType.PATH;
					item.label = (++_index).toString();
					break;
				}
				
				case PathFindingSimulator.STEP_START:
				{
					cell = _simulator.cell;
					item = _map.getItem(cell.x, cell.y);
					item.status = ItemStatusType.START_POINT;
					break;
				}
					
				case PathFindingSimulator.STEP_FINISH:
				{
					cell = _simulator.cell;
					item = _map.getItem(cell.x, cell.y);
					item.status = ItemStatusType.FINISH_POINT;
					break;
				}
					
				case PathFindingSimulator.STEP_CACULATE:
				{
					cell = _simulator.caculate;
					
					item = _map.getItem(cell.x, cell.y);
					item.status = ItemStatusType.CACULATE;
					
					_caculate = item;
					break;
				}
					
				case PathFindingSimulator.STEP_BACKWARD:
				{
					cell = _simulator.lastCell;
					item = _map.getItem(cell.x, cell.y);
					item.status = ItemStatusType.FORBIDDEN;
					item.label = "";
					_index--;
					break;
				}
			}
		}
	}
}