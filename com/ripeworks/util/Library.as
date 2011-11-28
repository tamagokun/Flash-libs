//AS3///////////////////////////////////////////////////////////////////////////
// 
// 
// 
////////////////////////////////////////////////////////////////////////////////
package com.ripeworks.util
{
	
	
/**
 *	This is a storage class for LoadedLibraries
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 10.0
 *
 *	@author Mike Kruk
 *	@since  06.08.2010
 */
	public class Library
	{
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var _assets:Array = new Array();
		private var _ids:Object = {};
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		public function Library():void { }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		public function addLibrary(asset:LoadedLibrary, id:String = null):Boolean
		{
			if( _assets.indexOf(asset) > -1 )
				return false;
			
			_assets[_assets.length] = asset;
			
			if( id )
			{
				_ids[id] = _assets.indexOf(asset);
			}else
			{
				_ids[parseUrl(asset.url)] = _assets.indexOf(asset);
			}
			
			return true;
		}
		
		public function removeLibrary(asset:*):Boolean
		{
			if( asset is LoadedLibrary )
			{
				var index:int = _assets.indexOf(asset);
				if( index > -1 )
				{
					for(var key:String in _ids)
					{
						if( _ids[key] == index )
							_ids[key] = null;
					}
					_assets.splice(index, 1);
					return true;
				}
			}
			
			if( asset is String)
			{
				if( _ids[asset] != null && _ids[asset] >= 0 && _ids[asset] < _assets.length)
				{
					return removeLibrary(_assets[_ids[asset]]);
				}
			}
			
			return false;
		}
		
		public function hasLibrary(asset:*):Boolean
		{
			if( asset is LoadedLibrary )
			{
				if( _assets.indexOf( asset ) > -1 )
					return true;
			}
			
			if( asset is String )
			{
				if( _ids[asset] != null && _ids[asset] >= 0 && _ids[asset] < _assets.length)
					return true;
			}
			
			return false;
		}
		
		public function getLibrary(asset:*):LoadedLibrary
		{
			if( !hasLibrary(asset) )
				return null;
			
			if( asset is LoadedLibrary )
				return _assets[_assets.indexOf(asset)];
			
			if( asset is String)
			{
				if( _ids[asset] != null && _ids[asset] >= 0 && _ids[asset] < _assets.length)
					return _assets[_ids[asset]];
			}
			
			return null;
		}
		
		public function hasAsset(id:String):Boolean
		{
			var i:int = 0;
			var limit:int = _assets.length;
			for( i; i < limit; i++)
			{
				if( _assets[i].hasAsset(id) )
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function getAsset(id:String):Class
		{
			var i:int = 0;
			var limit:int = _assets.length;
			for( i; i < limit; i++)
			{
				if( _assets[i].hasAsset(id) )
				{
					return _assets[i].getAsset(id);
				}
			}
			
			//throw new Error('There is no Library that contains ' + id);
			
			return null;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function parseUrl(url:String):String
		{
			return url.match(/(?:\\|\/)([^\\\/]*)$/)[1];
		}
		
	}
}