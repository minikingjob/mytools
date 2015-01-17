package  
{
	import core.managers.FileManager;
	import core.managers.LoaderManager;
	import core.managers.LogManager;
	import core.managers.TimerManager;
	import flash.display.Stage;
	/**
	 * ...
	 * @author minichen
	 */
	public class App 
	{
		public static var main:Main;
		public static var stage:Stage;
		public static var loader:LoaderManager = new LoaderManager();
		public static var timer:TimerManager = new TimerManager();
		public static var file:FileManager = new FileManager();
		public static var log:LogManager = new LogManager();
		public function App() 
		{
			
		}
		
		public static function init(_main:Main):void {
			main = _main;
			stage = _main.stage;
			
		}
		
		public static function getResPath(url:String):String
		{
			return url;
		}
	}

}