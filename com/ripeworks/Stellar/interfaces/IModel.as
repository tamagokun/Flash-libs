package com.ripeworks.Stellar.interfaces
{
	import com.ripeworks.Stellar.interfaces.IControl;
	import com.ripeworks.Stellar.model.ModelObject;
	import com.ripeworks.Stellar.core.Relationship;
	
	/**
	 * Interface for Models.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 01.11.2010
	 */
	public interface IModel
	{
		function init():void;
		function destroy():void;
		function get data():Array;
		function set data(value:Array):void;
	}
}