package com.ripeworks.Stellar.interfaces
{
	/**
	 * Interface for Views.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 01.11.2010
	 */
	public interface IView
	{
		function init():void;
		function destroy():void;
		function update():void;
		function set controller(value:IControl):void;
		function set index(value:int):void;
	}
}