package com.ripeworks.Stellar.utils.loaders
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	/**
	 * Data Loader for loading remote XML, JSON, etc.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 02.10.2010
	 */
	public class DataLoader
	{
				
		private static const MAX_LOADERS:int = 5;
		
		private static var _loaders:Array;
		private static var _queue:Array;
		private static var _isLoading:Boolean;
		
		public function DataLoader():void { }
		
		public static function init():void
		{
			_loaders = new Array();
			_queue = new Array();
			_isLoading = false;
		}
		
		public static function load(url:String, callback:Function):void
		{
			addToQueue({url:url, callback:callback, loading: false});
		}
		
		private static function addToQueue(hash:Object):void
		{
			_queue[_queue.length] = hash;
			
			if( !_isLoading )
			{
				loadNextInQueue();
			}
		}
		
		private static function loadNextInQueue():void
		{
			if( _queue.length > 0)
			{
				var toLoad:int = 0;
			}else
			{
				_isLoading = false;
				return;
			}
			
			var loader:URLLoader = getAvailableLoader();
			if( loader )
			{
				_queue[toLoad].loading = true;
				var request:URLRequest = new URLRequest(_queue[toLoad].url);
				loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
				loader.load(request);
			}
		}
		
		private static function getAvailableLoader():URLLoader
		{
			var i:int = 0;
			var loaderLength:int = _loaders.length;
			for(i;i<loaderLength;i++)
			{
				if( !_loaders[i].hasEventListener(Event.COMPLETE))
					return _loaders[i];
			}
			
			if( loaderLength < MAX_LOADERS )
			{
				var addLoader:URLLoader = new URLLoader();
				_loaders[loaderLength] = addLoader;
				return addLoader;
			}
			
			return null;
		}
		
		private static function loadCompleteHandler(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			
			_queue[0]["callback"](e);
			_queue.splice(0, 1);
			loadNextInQueue();
		}
		
		private static function loadErrorHandler(e:IOErrorEvent):void
		{
			e.target.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			
			_queue.splice(0, 1);
			loadNextInQueue();
		}
	}
}