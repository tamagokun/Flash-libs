package com.ripeworks.Stellar.view
{
	import flash.display.Sprite;
	
	import com.ripeworks.Stellar.interfaces.IView;
	import com.ripeworks.Stellar.interfaces.IControl;
	import com.ripeworks.Stellar.interfaces.IBindable;
	import com.ripeworks.Stellar.events.DataEvent;
	import com.ripeworks.Stellar.core.Station;
	import com.ripeworks.Stellar.model.ModelObject;
	import flash.events.Event;
	
	/**
	 * Abstract view class. Has abstract functionality for rendering and a response() method.
	 * 
	 * This class should always be extended when setting up views to display data/content.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 01.12.2010
	 */
	public class AbstractView extends Sprite implements IView, IBindable
	{	
		protected var _controller:IControl;
		protected var _index:int;
		protected var _model:ModelObject;
		
		public function AbstractView():void { }
		
		public function init():void
		{
			if( !_controller )
				throw new Error("Init Error. You must first assign a Controller to the View.");
			Station.listen(Station.RENDER, renderHandler);
		}
		
		public function destroy():void
		{
			if( this.parent )
			{
				this.parent.removeChild( this );
			}
			Station.kill(Station.RENDER, renderHandler);
		}
		
		public function bind(object:ModelObject):void
		{
			object._addBindableObject(this);
			model = object;
		}
		
		public function unbind():void
		{
			model._removeBindableObject(this);
		}
		
		public function updateModel(object:ModelObject):void
		{
			model = object;
			render();
		}
		
		public function update():void
		{
			//method stub to be extended by sub class
		}
		
		public function render(data:Object = null):void
		{
			//method stub to be extended by sub class
		}
		
		protected function respond(action:String, data:* = null):void
		{
			var event:DataEvent = new DataEvent(DataEvent.RESPONSE, {"action":action, "data":data}, null, true);
			
			if( this.parent )
			{
				parent.dispatchEvent( event );
			}else
			{
				dispatchEvent( event );
			}	
		}
		
		protected function renderHandler(e:DataEvent):void
		{
			if( e.controller != _controller )
				return;
			render(e.data);
		}
		
		public function set controller(value:IControl):void
		{
			_controller = value;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		
		public function get model():ModelObject
		{
			return _model;
		}
		
		public function set model(value:ModelObject):void
		{
			_model = value;
		}
		
	}
}