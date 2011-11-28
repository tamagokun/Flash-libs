package com.ripeworks.Stellar.helper
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.text.StyleSheet;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import com.ripeworks.util.Library;
	import com.ripeworks.util.LoadedLibrary;
	import com.ripeworks.util.font.FontLoader;
	import com.ripeworks.Stellar.utils.loaders.AssetLoader;
	import com.ripeworks.Stellar.utils.loaders.StyleLoader;
	import com.ripeworks.Stellar.interfaces.IControl;
	import com.ripeworks.Stellar.core.Environment;
	import com.ripeworks.Stellar.core.Relationships;
	
	/**
	 * Application Helper.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 07.26.2010
	 */
	public class ApplicationHelper extends AbstractHelper
	{
		public static var baseURL:String = "";
		public static var assetURL:String = "";
		public static var assets:Library;
		public static var globals:Object;
		public static var control:Object;
		public static var css:StyleSheet;
		public static var config:XML;
		
		protected var loadablesToLoad:int = 0;
		private var _data:XML;
		
		public function ApplicationHelper(stage:Sprite):void
		{
			super(stage);
			assets = new Library();
		}
		
		public override function init(env:Environment):void
		{
			super.init(env);
			
			if( _config )
			{	
				var raw:String = _config.readUTFBytes( _config.length );
				ApplicationHelper.config = new XML( raw );
			}
			
			setupConfig();
			
			if( config.loadables && config.loadables.asset.length() > 0)
			{
				loadLoadables();
			}else
			{
				//Nothing to load, build controllers
				build();
			}
		}
		
		public override function build():void
		{
			trace("[ApplicationHelper::build()]");
			var i:int = 0;
			var limit:int = _environment.controllers.length;
			_environment.instances = [];
			for( i; i < limit; i++)
			{
				_environment.instances.push( new _environment.controllers[i]() as _environment.controllers[i]);
				_stage.addChild( _environment.instances[_environment.instances.length - 1] );
			}
			Relationships.sync();
			_environment.invoke();
			_stage.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		protected function loadLoadables():void
		{
			var i:int = 0;
			var limit:int = config.loadables.asset.length();
			loadablesToLoad = limit;
			
			for( i; i < limit; i++)
			{
				if( config.loadables.asset[i].indexOf(".xml") > -1)
				{
					StyleLoader.load(assetURL + config.loadables.asset[i], dataLoadedHandler);
					continue;
				}	
					
				if( config.loadables.asset[i].indexOf(".css") > -1 )
				{
					StyleLoader.load(assetURL + config.loadables.asset[i], cssLoadedHandler);
					continue;
				}
					
					
				if( config.loadables.asset[i].indexOf(".swf") > -1 )
				{
					AssetLoader.load(assetURL + config.loadables.asset[i], assetLoadedHandler);
					continue;
				}
					
			}
		}
		
		protected function dataLoadedHandler(e:Event):void
		{
			trace("[ Helper::dataLoadedHandler ]");
		 	_data = new XML( e.target.data );
		
			loadablesToLoad--;
			if( loadablesToLoad == 0)
			{
				build();
			}
		}
		
		protected function cssLoadedHandler(e:Event):void
		{
			trace("[ Helper::cssLoadedHandler ]");
			if( !css)
				css = new StyleSheet();
			css.parseCSS(e.target.data);
			
			for each(var style:String in css.styleNames) 
			{
				if( css.getStyle(style).src ) 
				{
					var fontLoader:FontLoader = new FontLoader(css);
					fontLoader.addEventListener(FontLoader.FONTS_LOADED, fontsLoadedHandler);
					return;
				}
			}
			
			loadablesToLoad--;
			if( loadablesToLoad == 0)
			{
				build();
			}
		}
		
		protected function fontsLoadedHandler(e:Event):void
		{
			loadablesToLoad--;
			if( loadablesToLoad == 0)
			{
				build();
			}
		}
		
		protected function assetLoadedHandler(e:Event):void
		{
			trace("[ Helper::assetsLoadedHandler ]");
			assets.addLibrary(e.target.content as LoadedLibrary);
			loadablesToLoad--;
			if( loadablesToLoad == 0)
			{
				build();
			}
		}
		
		protected function setupConfig():void
		{
			if( config.globals )
			{
				globals = new Object();
				for each( var prop:XML in config.globals.children() )
				{
					globals[prop.localName()] = prop;
				}
			}
			
			if( config.environments )
			{
				for each( var env:XML in config.environments.children() )
				{
					if( env.localName() == globals.environment )
					{
						baseURL = env["base_url"];
						assetURL = env["asset_url"];
					}
				}
			}
		}
		
	}
}