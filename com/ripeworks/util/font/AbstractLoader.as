//AS3///////////////////////////////////////////////////////////////////////////
// 
// 
// 
////////////////////////////////////////////////////////////////////////////////

package com.ripeworks.util.font {

import flash.events.EventDispatcher;
import flash.events.Event;
import flash.display.Loader;
import com.ripeworks.events.Notification;

/**
 *	EventDispatcher subclass description.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *
 *	@author Jon Andersen
 *	@since  22.05.2009
 */
public class AbstractLoader extends EventDispatcher {
	
	//--------------------------------------
	// CLASS CONSTANTS
	//--------------------------------------
	public const ALL_LOADED:String = 'allLoaded';
	public const ITEM_LOADED:String = 'itemLoaded';
	public const LOADER_PROGRESS:String = 'loaderProgress';
	
	//--------------------------------------
	//  PRIVATE VARIABLES
	//--------------------------------------
	protected var _itemsToLoad:Array = [];
	protected var _itemsLoaded:int = 0;
	protected var _loaderLookUp:Object = {};
	protected var _seperateDomain:Boolean = false;
	
	//--------------------------------------
	//  CONSTRUCTOR
	//--------------------------------------
	
	/**
	 *	@constructor
	 */
	public function AbstractLoader()
	{
		super();
	}
		
	//--------------------------------------
	//  PUBLIC METHODS
	//--------------------------------------
	public function load():void { }
	
	//--------------------------------------
	//  PRIVATE & PROTECTED INSTANCE METHODS
	//--------------------------------------
	protected function dispatchMediaData(e:Event):void
	{
		var loader:Loader = e.target.loader as Loader;
		var loadedMedia:Object = loader.content;
		dispatchEvent(new Notification(ITEM_LOADED, {media:loadedMedia, url:loader.contentLoaderInfo.url}));
	}
	
	//--------------------------------------
	//  EVENT HANDLERS
	//--------------------------------------
	
	//--------------------------------------
	//  GETTER/SETTERS
	//--------------------------------------
	public function set itemToLoad(value:String):void 
	{
		if (value)
		{
			_itemsToLoad[_itemsToLoad.length] = value;
		}
	}
	
	public function set seperateDomain(value:Boolean):void 
	{
		_seperateDomain = value;
	}
}

}