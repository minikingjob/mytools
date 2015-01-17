package feathersui 
{
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author minichen
	 */
	public class BasicItemRenderer extends FeathersControl implements IListItemRenderer 
	{
		
		public function BasicItemRenderer()
		{
		}
 
		protected var itemLabel:Label;
 
		protected var _index:int = -1;
 
		public function get index():int
		{
			return this._index;
		}
 
		public function set index(value:int):void
		{
			if(this._index == value)
			{
				return;
			}
			this._index = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
 
		protected var _owner:List;
 
		public function get owner():List
		{
			return List(this._owner);
		}
 
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
 
		protected var _data:Object;
 
		public function get data():Object
		{
			return this._data;
		}
 
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
 
		protected var _isSelected:Boolean;
 
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
 
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}
 
		override protected function initialize():void
		{
			if(!this.itemLabel)
			{
				this.itemLabel = new Label();
				this.addChild(this.itemLabel);
			}
		}
 
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
 
			if(dataInvalid)
			{
				this.commitData();
			}
 
			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
 
			if(dataInvalid || sizeInvalid)
			{
				this.layout();
			}
		}
 
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			this.itemLabel.width = NaN;
			this.itemLabel.height = NaN;
			this.itemLabel.validate();
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = this.itemLabel.width;
			}
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = this.itemLabel.height;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}
 
		protected function commitData():void
		{
			if(this._data)
			{
				this.itemLabel.text = this._data.toString();
			}
			else
			{
				this.itemLabel.text = "";
			}
		}
 
		protected function layout():void
		{
			this.itemLabel.width = this.actualWidth;
			this.itemLabel.height = this.actualHeight;
		}
	}

}