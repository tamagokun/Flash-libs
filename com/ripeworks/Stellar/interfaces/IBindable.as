package com.ripeworks.Stellar.interfaces
{
	import com.ripeworks.Stellar.model.ModelObject;
	/**
	 * Interface for Bindable objects.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 05.27.2010
	 */
	public interface IBindable
	{
		function updateModel(object:ModelObject):void;
		function bind(object:ModelObject):void;
		function unbind():void;
	}
}