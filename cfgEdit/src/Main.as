package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import moudules.entry.ui.EntryView;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author minichen
	 */
	public class Main extends Sprite 
	{
		private var _starling:Starling;
		public function Main():void 
		{
			App.init(this);
			init();
		}
		
		private function init():void {
			if(stage){
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				App.init(this);
			}
			this.mouseEnabled = this.mouseChildren = false;
			
			//ApplicationFacade.getInstance().startup(this);
			
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			this._starling = new Starling(EntryView, this.stage);
			this._starling.enableErrorChecking = false;
			this._starling.start();
			
			
		}
	}
	
}