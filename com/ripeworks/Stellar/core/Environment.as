package com.ripeworks.Stellar.core
{
	/**
	 * Environment is used to define all aspects of your application for runtime.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 07.28.2010
	 */
	public class Environment
	{
		public static const DEVELOPMENT:String = "development";
		public static const STAGING:String = "staging";
		public static const PRODUCTION:String = "production";
		
		private var _controls:Array;
		private var _instances:Array;
		private var _models:Array;
		private var _mode:String;
		
		public function Environment():void { }
		
		public function init(environmentMode:String):void
		{
			mode = environmentMode;
		}
		
		public function invoke():void
		{
			var i:int = 0;
			var limit:int = _instances.length;
			for(i;i<limit;i++)
			{
				_instances[i].init();
			}
		}
		
		public function set mode(value:String):void
		{
			_mode = value;
		}
		
		public function get mode():String
		{
			return _mode;
		}
		
		public function get instances():Array
		{
			return _instances;
		}
		
		public function set instances(value:Array):void
		{
			_instances = value;
		}
		
		public function set controllers(value:*):void
		{
			if( value is Array )
			{
				_controls = value;
			}else
			{
				_controls.push(value);
			}
		}
		
		public function get controllers():Array
		{
			return _controls;
		}
		
		public function set models(value:*):void
		{
			if( value is Array )
			{
				_models = value;
			}else
			{
				if( !_models)
					_models = [];
				_models.push(value);
			}
		}
		
		public function get models():Array
		{
			return _models;
		}
	}
}