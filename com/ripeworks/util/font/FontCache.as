//AS3///////////////////////////////////////////////////////////////////////////
// 
// 
// 
////////////////////////////////////////////////////////////////////////////////
package com.ripeworks.util.font
{
	import com.ripeworks.events.Notification;
	import com.ripeworks.util.font.AbstractLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.sampler.stopSampling;
	import flash.text.StyleSheet;
	import flash.utils.Dictionary;
/**
 *	
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 10.0
 *
 *	@author Mike Kruk
 *	@since  12.19.09
 */
	public class FontCache extends EventDispatcher
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public const FONTS_LOADED:String = 'fontsLoaded';
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _lookUp:Dictionary = new Dictionary();
		protected var _loader:AbstractLoader;
		
		//this is for local testing only set it before load
		protected var _mediaPath:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		public function FontCache(){}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		public function load(css:StyleSheet):void
		{
			trace("[ FontCache::load() ]");
			if (_loader)
			{
				var newFontFound:Boolean = false;
				for each(var style:String in css.styleNames) 
				{
					var fontSrc:String = css.getStyle(style).fontSrc;
					
					// if the style has a font
					if(fontSrc && !_lookUp[splitURL(fontSrc)]) 
					{
						_loader.itemToLoad = fontSrc;
						newFontFound = true;
					}
				}
				
				if(!newFontFound)
				{
					dispatchEvent(new Event(FONTS_LOADED, true));
				}
				
				_loader.addEventListener(_loader.ITEM_LOADED, itemLoadedHandler);
				_loader.addEventListener(_loader.ALL_LOADED, allLoadedHandler);
				
				_loader.load();
			}else
			{
				throw new Error('must inject loader before calling load');
			}
			
		}
		
		public function destroy():void
		{
			_lookUp = null;
			
			removeEventListener(_loader.ITEM_LOADED, itemLoadedHandler);
			removeEventListener(_loader.ALL_LOADED, allLoadedHandler);
			
			_loader = null;
		}
		
		public function reset():void
		{
			_lookUp = new Dictionary(false);
			_loader = null;
		}
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		protected function splitURL(url:String):String
		{
			if (url)
			{
				if (_mediaPath)
				{
					url = (url.indexOf(_mediaPath) != -1)? url.substr(url.lastIndexOf(_mediaPath) + _mediaPath.length):url;
				}
				else if(url.indexOf('/htdocs') != -1)
				{
					url = url.substr(url.lastIndexOf('/htdocs') + 7);
				}
				else 
				{
					url = (url.indexOf('.com') != -1)? url.substr(url.lastIndexOf('.com') + 4):url;
				}
			}
			
			return url;
		}
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		private function allLoadedHandler(e:Event):void
		{
			trace("[ FontCache::allLoadedHandler ]");
			e.stopImmediatePropagation();
			dispatchEvent(new Event(FONTS_LOADED, true));
		}
		
		private function itemLoadedHandler(e:Notification):void
		{
			trace("[ FontCache::itemLoadedHandler ]");
			var url:String = e.data.url as String;
			
			//strip lead path
			url = splitURL(url);
			
			_lookUp[url] = e.data.media;
			
			//call register on font swf
			e.data.media.register();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		public function set loader(value:AbstractLoader):void 
		{
			_loader = value;
		}
		
		public function set mediaPath(value:String):void 
		{
			_mediaPath = value;
		}
	}
}