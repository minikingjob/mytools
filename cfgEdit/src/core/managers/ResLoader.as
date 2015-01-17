package core.managers {
	import core.handlers.Handler;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import core.utils.ObjectUtils;
	
	/**资源加载器*/
	public class ResLoader {
		public static const SWF:uint = 0;
		public static const BMD:uint = 1;
		public static const AMF:uint = 2;
		public static const TXT:uint = 3;
		public static const DB:uint = 4;
		public static const BYTE:uint = 5;
		public static const LOCAL_BYTE:uint = 6;
		
		private static var _loadedMap:Object = {};
		private var _loader:Loader = new Loader();
		private var _urlLoader:URLLoader = new URLLoader();
		private var _urlRequest:URLRequest = new URLRequest();
		private var _loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
		private var _url:String;
		private var _type:int;
		private var _complete:Handler;
		private var _progress:Handler;
		private var _isLoading:Boolean;
		private var _loaded:Number;
		private var _lastLoaded:Number;
		
		public function ResLoader() {
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}
		
		private function tryCloseLoad():void {
			try {
				_loader.unloadAndStop();
				_urlLoader.close();
			} catch (e:Error) {
			}
		}
		
		private function doLoad():void {
			if (_isLoading) {
				tryCloseLoad();
			}
			_isLoading = true;
			_urlRequest.url = App.getResPath(_url);
			if (_type == SWF) {
				_loader.load(_urlRequest, _loaderContext);
				return;
			}
			if (_type == BMD || _type == AMF || _type == DB || _type == BYTE) {
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				_urlLoader.load(_urlRequest);
				return;
			}
			if (_type == TXT) {
				_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
				_urlLoader.load(_urlRequest);
				return;
			}
			if (_type == LOCAL_BYTE) {
				if (!_url) {
					App.log.error("Load Error:url can not be null");
					endLoad(null);
					return;
				}
				var file:File = File.applicationDirectory.resolvePath(_url);
				trace("----", file.url);
				if (!file.exists) {
					App.log.error("Load Error:can not found path " + _url);
					endLoad(null);
					return;
				}
				trace("+++++", _url);
				var bytes:ByteArray = new ByteArray();
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.READ);
				stream.readBytes(bytes, 0, stream.bytesAvailable);
				stream.close();
				trace("file:", bytes.length);
				_loader.loadBytes(bytes);
				return;
			}
		}
		
		private function onStatus(e:HTTPStatusEvent):void {
		
		}
		
		private function onError(e:Event):void {
			App.log.error("Load Error:", e.toString());
			endLoad(null);
		}
		
		private function onProgress(e:ProgressEvent):void {
			if (_progress != null) {
				var value:Number = e.bytesLoaded / e.bytesTotal;
				_progress.executeWith([value]);
			}
			_loaded = e.bytesLoaded;
		}
		
		private function onComplete(e:Event):void {
			if (_type == SWF) {
				endLoad(_loadedMap[_url] = 1);
				return;
			}
			if (_type == BMD) {
				if (_urlLoader.data != null) {
					_loader.loadBytes(_urlLoader.data);
					_urlLoader.data = null;
					return;
				}
				endLoad(_loadedMap[_url] = Bitmap(_loader.content).bitmapData);
				return;
			}
			if (_type == AMF) {
				endLoad(_loadedMap[_url] = ObjectUtils.readAMF(_urlLoader.data));
				return;
			}
			if (_type == DB) {
				var bytes:ByteArray = _urlLoader.data as ByteArray;
				bytes.uncompress();
				endLoad(_loadedMap[_url] = bytes.readObject());
				return;
			}
			if (_type == BYTE) {
				var byte:ByteArray = _urlLoader.data as ByteArray;
				byte.uncompress();
				endLoad(_loadedMap[_url] = byte);
				return;
			}
			if (_type == TXT) {
				endLoad(_loadedMap[_url] = _urlLoader.data);
				return;
			}
		}
		
		private function endLoad(content:*):void {
			App.timer.clearTimer(checkLoad);
			_isLoading = false;
			_progress = null;
			if (_complete != null) {
				var handler:Handler = _complete;
				_complete = null;
				handler.executeWith([content]);
			}
		}
		
		/**加载资源*/
		public function load(url:String, type:int, complete:Handler, progress:Handler):void {
			_url = url;
			_type = type;
			_complete = complete;
			_progress = progress;
			
			var content:* = getResLoaded(url);
			if (content != null) {
				return endLoad(content);
			}
			_loaded = _lastLoaded = 0;
			App.timer.doLoop(5000, checkLoad);
			doLoad();
		}
		
		/**如果5秒钟下载小于1k，则停止下载*/
		private function checkLoad():void {
			if (_loaded - _lastLoaded < 1024) {
				App.log.warn("load time out:" + _url);
				tryCloseLoad();
				endLoad(null);
			} else {
				_lastLoaded = _loaded;
			}
		}
		
		/**获取已加载的资源*/
		public static function getResLoaded(url:String):* {
			return _loadedMap[url];
		}
		
		/**删除已加载的资源*/
		public static function clearResLoaded(url:String):void {
			var res:Object = _loadedMap[url];
			if (res is BitmapData) {
				BitmapData(res).dispose();
			} else if (res is Bitmap) {
				Bitmap(res).bitmapData.dispose();
			}
			delete _loadedMap[url];
		}
	}
}