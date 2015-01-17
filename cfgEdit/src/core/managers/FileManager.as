package core.managers 
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author minichen
	 */
	public class FileManager 
	{
		private var _bytesMap:Object = { };
		public function FileManager() 
		{
			
		}
		
		
		public function load(filePath:String):ByteArray
		{
			if (_bytesMap[filePath]) return _bytesMap[filePath];
			if(filePath)
			{
				var file:File = File.applicationDirectory.resolvePath(filePath);
				if(file.exists)
				{
					var bytes:ByteArray = new ByteArray();
					var stream:FileStream = new FileStream();
					stream.open(file, FileMode.READ);
					stream.readBytes(bytes, 0, stream.bytesAvailable);
					stream.close();
					
					_bytesMap[filePath] = bytes;
					return bytes;
				}
			}
			return null;
		}
		
		
	}

}