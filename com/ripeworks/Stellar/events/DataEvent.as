package com.ripeworks.Stellar.events
{
	import flash.events.Event;
	
	import com.ripeworks.Stellar.interfaces.IControl;
	
	/**
	 * Extended Event for passing data and an optional controller reference.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 01.12.2010
	 */
	public class DataEvent extends Event
	{
		public static const RESPONSE:String = "stellar_view_response";
		
		private var _data:Object;
		private var _control:IControl;
		
		public function DataEvent(type:String, data:Object = null, controller:IControl = null, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			_data = data;
			_control = controller;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new DataEvent(type, _data, _control, bubbles, cancelable);
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function get controller():IControl
		{
			return _control;
		}
	}
}