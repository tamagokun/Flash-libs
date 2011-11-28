// ############################################################################
// ############################################################################
package com.ripeworks.media
{
	
	import com.ripeworks.events.InitEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	public class AssetLoader extends EventDispatcher
	{
		
		public static const ASSET_LOADED:String = "assetLoaded";
		public static const ASSET_COMPLETE:String = "assetComplete";
		public static const ASSET_PROGRESS:String = "assetProgress";
		public static const INIT_EVENT:String = "init";
		public static const IO_ERROR:String = "error";
		
		private var loader:Loader;
		private var assetData:*;
		private var id:Number;
		
		// ==========================================================
		// AssetLoader() - constructor
		// ==========================================================
		public function AssetLoader(fileURL:String, _id:Number = 0) 
		{
			
			id = _id;
			load(fileURL);
	
		}
		
		// ==========================================================
		// loadImages() - 
		// ==========================================================
		public function load(fileURL:String):void 
		{
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeListener);
			loader.contentLoaderInfo.addEventListener(Event.INIT, initListener);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressListener);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(new URLRequest(fileURL));
			
		}
		
		// ==========================================================
		// initListener() - called on asset init
		// ==========================================================
		private function initListener(e:Event):void 
		{
			// assign assetData if this is an image
			try{
				assetData = e.target.content;
			// catch error if we are loading a swf
			} catch(error:ErrorEvent) {
				trace("no asset data")
			}
			
			// dispatch event
			dispatchEvent(new InitEvent(AssetLoader.INIT_EVENT, e.bubbles, e.cancelable, e.target.content));
			dispatchEvent(new Event(AssetLoader.ASSET_LOADED));
			loader.contentLoaderInfo.removeEventListener(Event.INIT, initListener);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
		}
		
		// ==========================================================
		// completeListener() - called on asset init
		// ==========================================================
		private function completeListener(e:Event):void 
		{
			// assign assetData if this is an image
			try{
				assetData = e.target.content;
			// catch error if we are loading a swf
			} catch(error:ErrorEvent) {
				trace("no asset data")
			}
			
			// dispatch event
			dispatchEvent(new Event(AssetLoader.ASSET_COMPLETE));
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, initListener);
			
		}
		
		// ==========================================================
		// ioErrorHandler() - called on error
		// ==========================================================
		private function ioErrorHandler(event:IOErrorEvent):void 
		{
		    trace("ioErrorHandler: " + event);
			dispatchEvent(new Event(AssetLoader.IO_ERROR));
		}
		
	
		
		// ==========================================================
		// progressListener() -
		// ==========================================================
		private function progressListener(e:ProgressEvent):void 
		{
			dispatchEvent(new ProgressEvent(AssetLoader.ASSET_PROGRESS, e.bubbles, e.cancelable, e.bytesLoaded, e.bytesTotal));
			if(e.bytesLoaded == e.bytesTotal)
			{
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressListener);
			}
		}
		
		// ==========================================================
		// getAssetData() - returns the asset data
		// ==========================================================
		public function getAssetData():*
		{
			// get the data
			return  assetData;

		}
		
		// ==========================================================
		// getID() - returns the id
		// ==========================================================
		public function getID():*
		{
			// get the id
			return  id;

		}
		
		// ==========================================================
		// getLibraryAsset() - get item out of library
		// ==========================================================
		public function getLibraryAsset(name:String):Class 
		{
			return loader.contentLoaderInfo.applicationDomain.getDefinition(name)  as  Class;
		}
		
		// ==========================================================
		// getLibraryAsset() - get item out of library
		// ==========================================================
		public function getConstructor(name:String):Class 
		{
			trace(loader.contentLoaderInfo.applicationDomain.hasDefinition(name))
			try {
				return loader.contentLoaderInfo.applicationDomain.getDefinition(name)  as  Class;
			} catch (e:Error) {
			    trace("Cant Find it" + name);
			}
			return null;
				
		}
		
		// ==========================================================
		// destroy() -
		// ==========================================================
		public function destroy():void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, initListener);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressListener);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
		}
		
		
		// ==========================================================
		// destroy() -
		// ==========================================================
		public function unload():void
		{
			loader.unload();
			
		}
		
	}
	
}
