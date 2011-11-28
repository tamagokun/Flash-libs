//AS3///////////////////////////////////////////////////////////////////////////
// 
// 
// 
////////////////////////////////////////////////////////////////////////////////
package com.ripeworks.util.font
{
	import com.ripeworks.media.AssetLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.Font;
	import flash.text.StyleSheet;
		
	public class FontLoader extends EventDispatcher
	{
		public static const FONTS_LOADED:String = 'fontsLoaded';
		
		private var fontArray:Array = new Array();
		private var fontCount:Number = 0;
		
		// ==========================================================
		// FontLoader - 
		// ==========================================================
		public function FontLoader(_css:StyleSheet)
		{
			
			registerFonts(_css);
			
		}
		
		// ==========================================================
		// setup - 
		// ==========================================================
		private function registerFonts(css:StyleSheet):void
		{
			
			// get all fonts used in css
			for each(var style:String in css.styleNames) 
			{
				var fontSrc:String = css.getStyle(style).src;
				
				// if the style has a font
				if(fontSrc) 
				{
					// check if we have already made it
					if(fontArray.indexOf(fontSrc) == -1) 
					{
						trace(fontSrc + " loading font swf");
						var assetLoader:AssetLoader = new AssetLoader(fontSrc, fontArray.length);
						assetLoader.addEventListener(AssetLoader.ASSET_LOADED, fontLoaded);
						
						var fontObject:Object =  { 	fontSrc: fontSrc,
													fontName: css.getStyle(style).fontName
						}
						fontCount++;
						fontArray.push(fontObject);					
					}
				}
			}
			
			if (fontCount == 0)
			{
				trace("NO FONTS");
				dispatchEvent(new Event(FontLoader.FONTS_LOADED));
			}
		}
		
		// ==========================================================
		// fontLoaded - 
		// ==========================================================
		private function fontLoaded(e:Event):void
		{
			// remove listener
			e.target.removeEventListener(AssetLoader.ASSET_LOADED, fontLoaded);
			
			// get fontname
			var fontName:String = fontArray[e.target.getID()].fontName;
			
			// register it
			var FontLibrary:Class = e.target.getLibraryAsset(fontName) as Class;
            Font.registerFont(FontLibrary.font);
            
            fontCount--;
            if(fontCount == 0)
            {
            	dispatchEvent(new Event(FontLoader.FONTS_LOADED));
            }

		}
		
		// ==========================================================
		// setup - 
		// ==========================================================
		public function destroy():void
		{
			fontArray = null;
		}
		
	}
}