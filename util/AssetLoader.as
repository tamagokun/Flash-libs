package com.ripeworks.util
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.system.LoaderContext;
	
	/**
	 * Loader for loading project assets
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 11.28.2011
	 */
	public class AssetLoader
	{
		public static var bytesLoaded:Number = 0;
		public static var bytesTotal:Number = 0;
		
		private static const MAX_LOADERS:int = 5;
		
		private static var _loaders:Array;
		private static var _queue:Array;
		private static var _isLoading:Boolean;
		private static var _inited:Boolean;
		
		public function AssetLoader():void { }
		
		public static function init(relative_to_swf:Boolean = false):void
		{
			if( !_inited )
			{
				loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
				_loaders = new Array();
				_queue = new Array();
				_isLoading = false;
				_inited = true;
			}
		}
		
		public static function load_text(url:String, callback:Function, checkPolicy:Boolean = false):void
		{
			queue_asset(url,callback,checkPolicy);
		}
		
		public static function load(url:String, callback:Function, checkPolicy:Boolean = false):void
		{
			queue_asset(url,callback,checkPolicy,true);
		}
		
		public static function flush_queue(force:Boolean = false):void
		{
			var i:int = 0;
			var loaderLength:int = _loaders.length;
			for(i;i<loaderLength;i++)
			{
				if( force )
					_loaders[i] = null;
				else
				{
					if(!_loaders[i].hasEventListener(Event.COMPLETE))
						_loaders[i] = null;
				}
			}
		}
		
		private static function queue_asset(url:String,callback:Function,checkPolicy:Boolean = false,useLoader:Boolean = false):void
		{
			var hash:Object = {url:url, callback:callback, loading: false, policy: checkPolicy, loader:useLoader};
			_queue[_queue.length] = hash;
			if(!_isLoading)
				load_next_in_queue();
		}
		
		private static function load_next_in_queue():void
		{
			if( _queue.length > 0)
			{
				var toLoad:int = 0;
			}else
			{
				_isLoading = false;
				flush_queue();
				return;
			}
			
			if( _queue[toLoad].loading )
				return;
			
			var loader:* = get_available_loader(_queue[toLoad].loader);
			if( loader )
			{
				_queue[toLoad].loading = true;
				var request:URLRequest = new URLRequest(_queue[toLoad].url);
				loaderContext.checkPolicyFile = _queue[toLoad].policy;
				var event_target:* = loader;
				if( loader is Loader )
					event_target = loader.contentLoaderInfo as LoaderInfo;
				event_target.addEventListener(Event.COMPLETE, loadCompleteHandler);
				event_target.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
				event_target.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
				loader.load(request, loaderContext);
			}
		}
		
		private static function get_available_loader(use_loader:Boolean = false):*
		{
			var i:int = 0;
			var loaderLength:int = _loaders.length;
			for(i;i<loaderLength;i++)
			{
				var type_check:Boolean = (use_loader)? _loaders[i] is Loader : _loaders[i] is URLLoader;
				if( !_loaders[i].hasEventListener(Event.COMPLETE) && type_check)
					return _loaders[i];
			}
			
			if( loaderLength < MAX_LOADERS )
			{
				var addLoader:URLLoader = (use_loader)? new Loader() : new URLLoader();
				_loaders[loaderLength] = addLoader;
				return addLoader;
			}
			
			return null;
		}
		
		private static function loadCompleteHandler(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			e.target.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			
			_queue[0]["callback"](e);
			_queue.splice(0, 1);
			load_next_in_queue();
		}
		
		private static function loadProgressHandler(e:ProgressEvent):void
		{
			bytesLoaded = 0;
			bytesTotal = 0;
			
			var i:int = 0;
			var loaderLength:int = _loaders.length;
			for(i;i<loaderLength;i++)
			{
				bytesLoaded += _loaders[i].bytesLoaded;
				bytesTotal += _loaders[i].bytesTotal;
			}
		}
		
		private static function loadErrorHandler(e:IOErrorEvent):void
		{
			e.target.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			e.target.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			
			_queue.splice(0, 1);
			load_next_in_queue();
		}
		
	}
}