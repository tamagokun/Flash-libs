
package com.ripeworks.events {

import flash.events.EventDispatcher;

/**
 *	Singleton description.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *
 *	@author Jon Andersen
 *	@since  11.05.2009
 */
public class EventRelay extends EventDispatcher {
	
	//--------------------------------------
	// CLASS CONSTANTS
	//--------------------------------------
	
	//--------------------------------------
	//  PRIVATE VARIABLES
	//--------------------------------------
	private static var _instance:EventRelay;

	//--------------------------------------
	//  CONSTRUCTOR
	//--------------------------------------	
	/**
	 *	@constructor
	 */
	public function EventRelay()
	{
		super();
		if( _instance != null ) throw new Error( "Error:EventRelay already initialised." );
		if( _instance == null ) _instance = this;
	}
	
	//--------------------------------------
	//  PUBLIC METHODS
	//--------------------------------------
	public static function initialize():EventRelay
	{
		if (_instance == null){
			_instance = new EventRelay();
		}
		return _instance;
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
	public static function get instance():EventRelay
	{
		return initialize();
	}
	
}

}

