package com.ripeworks.Stellar.model
{
	import com.ripeworks.Stellar.interfaces.IModel;
	import com.ripeworks.Stellar.interfaces.IControl;
	import com.ripeworks.Stellar.core.Relationships;
	import com.ripeworks.Stellar.core.Relationship;
	
	/**
	 * Abstract Model class. Stores data, creates relationships.
	 * Extend for concrete model classes.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 01.11.2010
	 */
	public class AbstractModel extends Object implements IModel
	{
		public static var FIRST:int = 0;
		public static var ALL:int = -1;
		
		private var _data:Array;
		
		public function AbstractModel():void { }
		
		public function init():void
		{
			data = new Array();
		}
		
		public function destroy():void
		{
			_data = null;
		}
		
		public function get data():Array
		{
			return _data;
		}
		
		public function set data(value:Array):void
		{
			_data = value;
		}
		
	}
}