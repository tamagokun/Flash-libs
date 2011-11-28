package com.ripeworks.Stellar.helper
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import com.ripeworks.Stellar.utils.loaders.StyleLoader;
	import com.ripeworks.Stellar.utils.loaders.AssetLoader;
	import com.ripeworks.Stellar.interfaces.IHelper;
	import com.ripeworks.Stellar.core.Environment;
	/**
	 * Abstract Helper.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 01.25.2010
	 */
	public class AbstractHelper implements IHelper
	{
		protected var _stage:Sprite;
		protected var _config:ByteArray;
		protected var _environment:Environment;
		
		public function AbstractHelper(stage:Sprite):void 
		{ 
			_stage = stage;
		}
		
		public function init(env:Environment):void
		{
			_environment = env;
			StyleLoader.init();
			AssetLoader.init();
		}
		
		public function build():void
		{
			//Stub method for override
		}
		
		public function set configData(value:ByteArray):void
		{
			_config = value;
		}
		
	}
}