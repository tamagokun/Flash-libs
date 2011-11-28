package com.ripeworks.Stellar.interfaces
{
	import flash.utils.ByteArray;
	import com.ripeworks.Stellar.core.Environment;
	/**
	 * Interface for Helpers.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 07.26.2010
	 */
	public interface IHelper
	{
		function init(env:Environment):void;
		function build():void;
		function set configData(value:ByteArray):void;
	}
}