package com.ripeworks.Stellar.model
{
	import com.ripeworks.Stellar.utils.Parser;
	import com.ripeworks.Stellar.interfaces.IBindable;
	
	/**
	 * Generic dynamic object class for storing model data.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 01.22.2010
	 */
	public dynamic class ModelObject extends Object
	{
		public var id:int;
		private var _bindedList:Array;
		
		public function ModelObject(data:Object):void 
		{
			setData(data); 
		}
		
		public function _satisfies(options:String):Boolean
		{
			if( !options || options.length < 1)
				return true;
			
			if( Parser.parse(this, options) )
			{
				return true;
			}
			return false;
		}
		
		public function _addBindableObject(object:IBindable):void
		{
			if( !_bindedList )
				_bindedList = new Array();
			
			_bindedList.push( object );
			object.updateModel( this );
		}
		
		public function _removeBindableObject(object:IBindable):void
		{
			if( !_bindedList )
				return;
			
			var index:int = _bindedList.indexOf( object );
			if( index > -1 )
			{
				_bindedList.splice(index, 1);
			}
		}
		
		public function _updateBindings():void
		{
			if( _bindedList && _bindedList.length > 0)
			{
				var i:int = 0;
				var limit:int = _bindedList.length;
				for( i; i < limit; i++)
				{
					_bindedList[i].updateModel(this);
				}
			}
		}
		
		private function setData(data:Object):void
		{
			for( var key:String in data)
			{
				this[key] = data[key];
			}
			
			_updateBindings();
		}
		
		public function toString():String
		{
			var returnString:String = "ModelObject::{";
			for ( var key:String in this)
			{
				returnString+=key+":"+this[key]+", ";
			}
			returnString+="}";
			return returnString;
		}
		
	}
}