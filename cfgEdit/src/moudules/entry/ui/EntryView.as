package moudules.entry.ui 
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.text.BitmapFontTextFormat;
	import feathers.themes.MetalWorksMobileTheme;
	import feathersui.BasicItemRenderer;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author minichen
	 */
	public class EntryView extends Sprite 
	{
		private var _group:ButtonGroup;
		private var _list:List;
		public function EntryView() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addToStage);
		}
		private function addToStage(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			new MetalWorksMobileTheme();
			
			_group = new ButtonGroup();
			this.addChild(_group);
			_group.dataProvider = new ListCollection(
			[
				{ label: "打开配置", triggered: triggeredHandler },
				{ label: "保存配置", triggered: triggeredHandler },
				{ label: "创建新节点", triggered: triggeredHandler },
			]);
			_group.direction = "horizontal";
			//_group.buttonProperties.
			
		}
		private function triggeredHandler( event:Event ):void
		{
			var button:Button = Button( event.currentTarget );
			trace( "button triggered:", button.label );
		}
		
		
		
	}

}