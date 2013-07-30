package larrio
{
	import com.larrio.astar.map.RegionMap;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 30, 2013 9:59:26 PM
	 */
	public class GameMap extends Sprite
	{
		private var _map:RegionMap;
		
		private var _items:Vector.<NodeItem>;
		private var _dict:Dictionary;
		
		private var _buffer:Dictionary;
		private var _keys:Dictionary;
		
		private var _start:NodeItem;
		private var _finish:NodeItem;
		
		/**
		 * 构造函数
		 * create a [GameMap] object
		 */
		public function GameMap(row:uint, column:uint)
		{
			_map = new RegionMap(row, column);
			_items = new Vector.<NodeItem>;
			
			_dict = new Dictionary(false);
			_keys = new Dictionary(true);
			
			var item:NodeItem;
			
			var locX:uint, locY:uint;
			for (var i:int = 0; i < row; i++)
			{
				locX = 0;
				for (var j:int = 0; j < column; j++)
				{
					item = new NodeItem();
					item.cell = _map.getCell(j, i);
					item.x = locX;
					item.y = locY;
					addChild(item);
					
					locX += item.width;
					
					_items.push(item);
					_dict[getKey(j, i)] = item;
				}
				
				locY += item.height;
			}
			
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function getItem(x:uint, y:uint):NodeItem
		{
			return _dict[getKey(x, y)];
		}
		
		private function init(e:Event):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		
		protected function keyHandler(e:KeyboardEvent):void
		{
			var code:uint = e.keyCode;
			if (e.type == KeyboardEvent.KEY_DOWN)
			{
				_keys[code] = true;
			}
			else
			if (e.type == KeyboardEvent.KEY_UP)
			{
				_keys[code] = false;
			}
		}
		
		protected function downHandler(e:MouseEvent):void
		{
			var item:NodeItem = e.target as NodeItem;
			if (!_keys[Keyboard.CONTROL] && !_keys[Keyboard.COMMAND])
			{
				if (!item || item.obstacle) return;
				
				if (!_keys[Keyboard.SHIFT])
				{
					if (_start) 
					{
						_start.status = ItemStatusType.IDLE;
					}
					
					_start = item;
					_start.status = ItemStatusType.START_POINT;
				}
				else
				{
					if (_finish) 
					{
						_finish.status = ItemStatusType.IDLE;
					}
					
					_finish = item;
					_finish.status = ItemStatusType.FINISH_POINT;

				}
				return;
			}
			
			_buffer = new Dictionary(true);
			
			addEventListener(Event.ENTER_FRAME, frameHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		protected function upHandler(e:MouseEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			removeEventListener(Event.ENTER_FRAME, frameHandler);
		}
		
		protected function frameHandler(e:Event):void
		{
			var x:uint = mouseX / NodeItem.SIZE >> 0;
			var y:uint = mouseY / NodeItem.SIZE >> 0;
			
			var key:String = getKey(x, y);
			var item:NodeItem = _dict[key];
			if (!item) return;
			
			if (_buffer[key] || (!_keys[Keyboard.COMMAND] && !_keys[Keyboard.CONTROL])) return;
			
			_buffer[key] = true;
			
			item.obstacle = !item.obstacle;
		}
		
		private function getKey(x:uint, y:uint):String { return x + ":" + y; }

		public function get map():RegionMap { return _map; }

		public function get start():NodeItem { return _start; }

		public function get finish():NodeItem { return _finish; }


	}
}