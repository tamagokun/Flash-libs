//AS3///////////////////////////////////////////////////////////////////////////
// 
// 
// 
////////////////////////////////////////////////////////////////////////////////
package com.ripeworks.util
{
	import flash.display.Sprite;

/**
 *	This is the document class for all loaded libraries
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 10.0
 *
 *	@author Mike Kruk
 *	@since  12.19.2009
 */
	public class LoadedLibrary extends Sprite
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		public function LoadedLibrary() { }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		public function getAsset(id:String):Class
		{
			try {
				return loaderInfo.applicationDomain.getDefinition(id) as Class;
			} catch (e:Error) {
			    throw new Error('Library does not contain ' + id);
			}
			
			return null;
		}
		
		public function hasAsset(id:String):Boolean
		{
			try {
				return loaderInfo.applicationDomain.hasDefinition(id);
			} catch (e:Error) {
				return false;
			}
			
			return false;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		public function get url():String
		{
			return loaderInfo.url;
		}
	}
}