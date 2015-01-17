package  
{
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Label;
	import feathers.data.ListCollection;
	import feathers.text.BitmapFontTextFormat;
	import feathers.themes.MetalWorksMobileTheme;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	
	/**
	 * ...
	 * @author minichen
	 */
	public class MainView extends Sprite 
	{
		protected var button:Button;
		public function MainView() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addToStage);
		}
		private function addToStage(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			new MetalWorksMobileTheme();

			//create a button and give it some text to display.
			this.button = new Button();
			//this.button.labelFactory = labelFactoryFun;
			this.button.width = 100;
			this.button.height = 40;
			this.button.label = "Click Me";

			//an event that tells us when the user has tapped the button.
			this.button.addEventListener(Event.TRIGGERED, button_triggeredHandler);

			//add the button to the display list, just like you would with any
			//other Starling display object. this is where the theme give some
			//skins to the button.
			this.addChild(this.button);

			//the button won't have a width and height until it "validates". it
			//will validate on its own before the next frame is rendered by
			//Starling, but we want to access the dimension immediately, so tell
			//it to validate right now.
			this.button.validate();

			//center the button
			this.button.x = Math.round((this.stage.stageWidth - this.button.width) / 2);
			this.button.y = Math.round((this.stage.stageHeight - this.button.height) / 2);
		}
		
		/**
		 * Listener for the Button's Event.TRIGGERED event.
		 */
		protected function button_triggeredHandler(event:Event):void
		{
			var label:Label = new Label();
			label.text = "Hi, I'm Feathers!\nHave a nice day.";
			Callout.show(label, this.button);
		}
		
		
		private function labelFactoryFun():void 
		{
			//var myBitmapFont:BitmapFont = new BitmapFont();
			//button.defaultLabelProperties.textFormat = new BitmapFontTextFormat( myBitmapFont, 42 );
		}
		
	}

}