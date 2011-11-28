package com.ripeworks.Stellar.core
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import com.ripeworks.Stellar.events.DataEvent;
	import com.ripeworks.Stellar.interfaces.IControl;
	
	/**
	 * Static class which manages broadcast and update commands passed between views and controllers.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 01.26.2010
	 */
	public class Station
	{
		public static const RENDER:String = "stellar_render";
		public static const UPDATE:String = "stellar_update";
		public static const BROADCAST:String = "stellar_broadcast";
		
		private static var _eventConduit:EventDispatcher = new EventDispatcher;
		
		public function Station():void { }
		
		public static function render(data:*, controller:IControl):void
		{
			_eventConduit.dispatchEvent( new DataEvent(Station.RENDER, data, controller) );
		}
		
		public static function broadcast(broadcastType:String, action:String, data:* = null):void
		{
			_eventConduit.dispatchEvent( new DataEvent(broadcastType, {"action":action, "data":data}));
		}
		
		public static function listen(event:String, callback:Function):void
		{
			_eventConduit.addEventListener(event, callback);
		}
		
		public static function kill(event:String, callback:Function):void
		{
			_eventConduit.removeEventListener(event, callback);
		}
	}
}