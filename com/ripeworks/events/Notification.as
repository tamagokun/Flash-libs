//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2010 Ripeworks
// 
////////////////////////////////////////////////////////////////////////////////

package com.ripeworks.events {

import flash.events.Event;

/**
 *	Event Object with Object variable
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *
 *	@author Mike Kruk
 *	@since  06.18.2010
 */
public class Notification extends Event {
	
	//--------------------------------------
	// CLASS CONSTANTS
	//--------------------------------------
	
	public static const MENU_ITEM_CLICK:String = "menuItemClick";
	public static const MENU_ITEM_OVER:String = 'menuItemOver';
	public static const MENU_ITEM_OUT:String = 'menuItemOut';
	
	public static const PAGE_TRACK:String = 'pageTrackEvent';
	public static const LINK_TRACK:String = 'linkTrackEvent';
	
	public static const ANIMATION_DONE:String = 'animationDone';
	public static const INITIAL_ANIMATION:String = 'initialAnimation';

	//--------------------------------------
	//  PRIVATE VARIABLES
	//--------------------------------------
	
	private var _data:Object;
	private var _sender:Object;
	
	//--------------------------------------
	//  CONSTRUCTOR
	//--------------------------------------
	
	/**
	 *	@constructor
	 */
	public function Notification( type:String, data:Object = null, bubbles:Boolean = true, cancelable:Boolean = false, sender:Object = null )
	{
		_data = data;
		_sender = sender;
		super(type, bubbles, cancelable);
	}
		
	//--------------------------------------
	//  PUBLIC METHODS
	//--------------------------------------

	override public function clone():Event
	{
		return new Notification(type, _data, bubbles, cancelable);
	}
	
	//--------------------------------------
	//  PRIVATE & PROTECTED INSTANCE METHODS
	//--------------------------------------

	//--------------------------------------
	//  GETTER/SETTERS
	//--------------------------------------
	public function get data():Object { return _data; }
	
	public function get sender():Object { return _sender; }
	
	//--------------------------------------
	//  EVENT HANDLERS
	//--------------------------------------
	
		
}

}

