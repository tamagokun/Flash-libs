package com.ripeworks.Stellar.core
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.utils.ByteArray;
	
	import com.ripeworks.Stellar.core.Relationships;
	import com.ripeworks.Stellar.core.Environment;
	import com.ripeworks.Stellar.interfaces.IHelper;
	/**
	 * StellarApp. Extend DocClass with this.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 05.18.2010
	 */
	public class StellarApp extends Sprite
	{
		public var helper:IHelper;
		public var environment:Environment;
		
		protected var AppConfig:Class;
		
		public function StellarApp():void 
		{
			if( stage )
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			
			environment = new Environment();
			Relationships.environment = environment;
			
			addEventListener(Event.ADDED_TO_STAGE, initHandler);
		}
		
		public function init():void
		{
			trace("[ StellarApp::init() ]");
		}
		
		private function initHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initHandler);
			init();
		}
	}
}