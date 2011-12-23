package com.ripeworks.events
{
	
	import flash.events.*;
	
	public class InitEvent extends Event
	{
		
		public static const INIT:String = "init";
		public var assetData:*;
		
		// ==========================================================
		// InitEvent() - constructor
		// ==========================================================
		public function InitEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, assetData:* = null):void
		{
			super(type, bubbles, cancelable);
			this.assetData = assetData;
		}
		
		// ==========================================================
		// clone() - constructor
		// ==========================================================
		public override function clone():Event 
		{
			return new InitEvent(type, bubbles, cancelable, assetData);
		}
		
		// ==========================================================
		// clone() - constructor
		// ==========================================================
		public override function toString():String
		{
			return formatToString("InitEvent", "type", "bubbles", "cancelable", "eventPhase", "assetData");
		}
		
	}
	
}
