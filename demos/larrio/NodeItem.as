package larrio
{
	import com.larrio.astar.map.MapCell;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 30, 2013 9:40:44 PM
	 */
	public class NodeItem extends Sprite
	{
		public static const SIZE:uint = 30;
		
		private var _status:uint;
		private var _cell:MapCell;
		
		private var _obstacle:Boolean;
		private var _label:TextField;
		
		/**
		 * 构造函数
		 * create a [NodeItem] object
		 */
		public function NodeItem()
		{
			this.status = 0;
			this.mouseChildren = false;
			
			_label = new TextField();
			_label.width = SIZE;
			_label.height = 18;
			_label.y = (SIZE - _label.height) / 2;
			_label.defaultTextFormat = new TextFormat("Monaco", 13, 0xFFFFFF, null, null,null,null,null, "center");
			addChild(_label);
		}
		
		public function get status():uint { return _status; }
		public function set status(value:uint):void
		{
			var color:uint;
			
			const DEFAULT_COLOR:uint = 0xEFEFEF;
			switch (value)
			{
				case ItemStatusType.START_POINT:color = 0x0066FF;break;
				case ItemStatusType.FINISH_POINT:color = 0x0000FF;break;
				case ItemStatusType.CACULATE:color = 0xFF9900;break;
				case ItemStatusType.PATH:color = 0x336600;break;
				case ItemStatusType.FORBIDDEN:color = 0xCC0000;break;
				case ItemStatusType.OBSTACLE:color = 0x000000;break;
				default:color = DEFAULT_COLOR;break;
			}
			
			//if (value == _status) color = DEFAULT_COLOR;
			
			_status = value;
			
			graphics.clear();
			graphics.lineStyle(0.5, 0xBBBBBB, 1);
			graphics.beginFill(color, 1);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		override public function get width():Number { return SIZE; }
		override public function get height():Number { return SIZE; }

		public function get cell():MapCell { return _cell; }
		public function set cell(value:MapCell):void
		{
			_cell = value;
		}

		public function get obstacle():Boolean { return _obstacle; }
		public function set obstacle(value:Boolean):void
		{
			_obstacle = value;
			_cell.obstacle = _obstacle;
			
			this.status = _obstacle? ItemStatusType.OBSTACLE : ItemStatusType.IDLE;
		}

		public function get label():String { return _label.text; }
		public function set label(value:String):void
		{
			_label.text = value;
		}


	}
}