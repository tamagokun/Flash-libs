package com.ripeworks.Stellar.core
{
	
	import com.ripeworks.Stellar.interfaces.IControl;
	import com.ripeworks.Stellar.core.Relationships;
	/**
	 * Relationship object used to define relationships between 2 models.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 02.05.2010
	 */
	public class Relationship
	{
		private var _control:Class;
		private var _controller:Object;
		
		public function Relationship(controller:Class):void
		{
			_control = controller;
			Relationships.create(this);
		}
		
		public function get type():Class
		{
			return _control;
		}
		
		public function get controller():IControl
		{
			return _controller as IControl;
		}
		
		public function set controller(value:IControl):void
		{
			_controller = value;
			if( _control )
			{
				_controller = value as _control;
			}
		}
	}
}