package com.ripeworks.Stellar.control
{
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import com.ripeworks.Stellar.interfaces.IControl;
	import com.ripeworks.Stellar.interfaces.IModel;
	import com.ripeworks.Stellar.interfaces.IView;
	import com.ripeworks.Stellar.events.DataEvent;
	import com.ripeworks.Stellar.core.Station;
	import com.ripeworks.Stellar.model.ModelObject;
	import flash.display.DisplayObject;
	
	/**
	 * This is the main instance for interacting with objects, their model, and view(s).
	 * The abstract class contains various methods for finding/managing model data, as well as for view rendering and
	 * handing responses sent back from the view.
	 * 
	 * This class should always be extended when new "objects" or "components" are created.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 01.11.2010
	 */
	public class AbstractController extends Sprite implements IControl
	{
		
		protected var _model:Object;
		protected var _views:Array;
		
		/**
		 * @constructor
		 */
		public function AbstractController():void { }
		
		/**
		 * Initializes a new Controller object.
		 * 
		 * @param model The ClassType of the model this object uses (optional)
		 */
		public function init():void
		{
			if( !_model )
				throw new Error("Must have model when running init() on controller.");

			_model.init();
			
			_views = new Array();
			addEventListener(DataEvent.RESPONSE, viewResponseHandler);
			Station.listen(Station.BROADCAST, broadcastHandler);
			Station.listen(Station.UPDATE, updateHandler);
		}
		
		/**
		 * Prepares the object instance for garbage collection.
		 */ 
		public function destroy():void
		{
			removeEventListener(DataEvent.RESPONSE, viewResponseHandler);
			Station.kill(Station.BROADCAST, broadcastHandler);
			Station.kill(Station.UPDATE, updateHandler);
			_model.destroy();
			_model = null;
		}
		
		/**
		 * Sends a render command to the Station.
		 * The Station then calls "render" on each View associated with the Controller.
		 * 
		 * @param data Any specific data that you wish the Views to have access to. (optional)
		 */
		public function render(data:Object = null):void
		{
			Station.render( data, this);
		}
		
		/**
		 * Create a new record, or set of records to be added to the Model.
		 * 
		 * @param data A ModelObject or Array of ModelObjects.
		 * 
		 * @return the created data from the Model is returned.
		 */
		public function create(data:*):*
		{
			if( data is Array)
			{
				var i:int = 0;
				var setLength:int = data.length;
				var object:ModelObject;
				var returnArray:Array = [];
				for( i; i < setLength; i++)
				{
					returnArray[returnArray.length] = add(data[i]);
				}
				return returnArray;
			}else
			{
				return add(data);
			}
		}
		
		/**
		 * Updates a specific part of the Model's data.
		 * 
		 * @param id An ID of a ModelObject, or an Array of ModelObject IDs.
		 * @param properties And Object of property keys and new values, or an Array of Objects respective to the Array id.
		 */
		public function update(id:*, properties:*):void
		{
			var i:int = 0;
			var setLength:int;
			if( id is Array )
			{
				var updateLength:int = id.length;
				for(i; i < updateLength; i++)
				{
					var j:int = 0;
					setLength = _model.data.length;
					for( j; j < setLength; j++)
					{
						if( _model.data[j].id == id[i])
						{
							for(var prop:String in properties)
							{
								_model.data[j][prop] = properties[prop];
							}
							_model.data[j]._updateBindings();
							break;
						}
					}
				}
				return;
			}else
			{
				setLength = _model.data.length;
				for( i=0; i < setLength; i++)
				{
					if( _model.data[i].id == id)
					{
						for(var property:String in properties)
						{
							_model.data[i][property] = properties[property];
						}
						_model.data[i]._updateBindings();
						return;
					}
				}
			}
		}
		
		/**
		 * Remove a specific ModelObject
		 * 
		 * @param instance The instance to remove from the Model.
		 */
		public function remove(instance:ModelObject):void
		{
			var i:int = 0;
			var setLength:int = _model.data.length;
			for( i; i < setLength; i++)
			{
				if( _model.data[i] == instance)
				{
					_model.data[i] = null;
					_model.data.splice(i, 1);
					return;
				}
			}
		}
		
		/**
		 * Query the Model for a specific dataset.
		 * 
		 * Amounts can be a range of values 0 to the entire Model size (AbstractModel.ALL)
		 * 
		 * If only 1 dataSet was found, but was queried for more than one, an Array with the one dataSet will be returned.
		 * If only 1 dataSet was requested, the direct instance will be returned. Otherwise, an Array of the matched ModelObjects
		 * will be returned.
		 * 
		 * @param amount The maximum amount of Objects to be returned
		 * @param options A String of options to query against. Much like the WHERE clause of a SQL statement (optional)
		 * 
		 * @return a single ModelObject or Array of ModelObjects based on the desired results.
		 */
		public function find(amount:int = -1, options:String = null):*
		{
			var returnAmount:int = amount;
			if( amount < 0)
				returnAmount = _model.data.length;
			
			var dataSet:Array = [];
			var i:int = 0;
			var setLength:int = _model.data.length;
			for( i; i < setLength; i++)
			{
				if( _model.data[i]._satisfies(options) )
				{
					dataSet[dataSet.length] = _model.data[i];
				}
				
				if( dataSet.length > returnAmount)
				{
					break;
				}
			}
			
			if( dataSet.length > 1)
			{
				return dataSet;
			}else if( dataSet.length == 1)
			{
				if( returnAmount == 0 || (returnAmount == 1 && amount > -1))
					return dataSet[0];
				else
					return dataSet;
			}else
			{
				return null;
			}
		}
		
		/**
		 * Find a specific record in the Model based in its ID.
		 * 
		 * If no Object is found an Error is thrown.
		 * 
		 * @param id The int value of the Object's ID.
		 * 
		 * @return The desired Object.
		 */
		public function findById(id:int):ModelObject
		{
			if( id >= 0 && id < _model.data.length )
			{
				return _model.data[id];
			}else
			{
				throw new Error("Bounds Error! There is no object with that id.");
			}
		}
		
		public function findByProperty(key:String, value:String, options:String = null):*
		{
			return null;
		}
		
		/**
		 * Add a set of properties to the Model as a new ModelObject.
		 * 
		 * Although this method can be used, the preferred way to add data is by using create().
		 * 
		 * @param properties An Object of key/value pairs to define the Model data.
		 * 
		 * @return The created ModelObject once added to the Model.
		 */
		protected function add(properties:Object):ModelObject
		{
			var object:ModelObject = new ModelObject(properties);
			var id:int = _model.data.length;
			object.id = id;
			_model.data[id] = object;
			return object;
		}
		
		/**
		 * Render only a single view.
		 * 
		 * If overwrite is true (default) all other views will be removed before calling render on the
		 * desired view type.
		 * 
		 * 
		 * @param ViewType The ClassType of the view to render.
		 * @param data Any specific data to be fed to the view. (optional)
		 * @param overwrite (default true) Removes any other view before rendering if true. (optional)
		 */
		protected function renderSingleView(ViewType:Class, data:Object = null, overwrite:Boolean = true):void
		{
			if( overwrite )
			{
				var i:int = 0;
				var viewLength:int = _views.length;
				for(i; i < viewLength; i++)
				{
					removeViewAt(i);
				}
			}
			
			var toRender:Object = addView(ViewType) as ViewType;
			addChild(toRender as Sprite);
			render(data);
		}
		
		/**
		 * Add a view of a specific ClassType
		 * 
		 * @param ViewType Specific ClassType of the view.
		 * 
		 * @return the instance of the added view is returned as an IView.
		 */
		protected function addView(ViewType:Class):IView
		{
			var view:Object = new ViewType() as ViewType;
			var index:int = _views.length;
			_views[index] = view as IView;
			view.controller = this;
			view.index = index;
			view.init();
			return _views[index];
		}
		
		/**
		 * Get an IView instance at a particular index
		 * 
		 * @param index The index of the view.
		 * 
		 * @return An IView instance at the specified index.
		 */
		protected function getViewAt(index:int):IView
		{
			if( index >= 0 && index < _views.length )
				return _views[index];
			else
				throw new Error("Bounds Error! There is no view at the specified index.");
		}
		
		/**
		 * Find the number of views the controller has
		 * 
		 * @return An int value of the number of views.
		 */
		protected function numViews():int
		{
			return _views.length;
		}
		
		/**
		 * Remove a view from the controller.
		 * 
		 * @param view The IView instance to remove.
		 * 
		 */
		protected function removeView(view:IView):void
		{
			var i:int = 0;
			var viewLength:int = _views.length;
			for(i; i < viewLength; i++)
			{
				if( _views[i] == view)
				{
					_views[i].destroy();
					_views[i] = null;
					_views.splice(i, 1);
					updateViews();
					return;
				}
			}
		}
		
		/**
		 * Remove a view from the controller at a specific index.
		 * 
		 * @param index The 0-based index where the view is located at.
		 * 
		 */
		protected function removeViewAt(index:int):void
		{
			if( index >= 0 && index < _views.length )
			{
				_views[index].destroy();
				_views[index] = null;
				_views.splice(index, 1);
				updateViews();
			}else
			{
				throw new Error("Bounds Error! There is no view at the specified index.");
			}	
		}
		
		/**
		 * Runs update() on all views contained in the controller.
		 * 
		 */
		protected function updateViews():void
		{
			var i:int = 0;
			var viewLength:int = _views.length;
			for(i; i < viewLength; i++)
			{
				_views[i].index = i;
				_views[i].update();
			}
		}
		
		/**
		 * If an UPDATE is dispatched from the Station, this handler calls updateViews().
		 * 
		 * This method will never need to be called.
		 * 
		 * @param e An instance of the DataEvent from the Station.
		 * 
		 */
		protected function updateHandler(e:DataEvent):void
		{
			updateViews();
		}
		
		/**
		 * If a BROADCAST is dispatched from the Station, this handler attempts to call the action method
		 * on the controller.
		 * 
		 * @param e An instance of the DataEvent from the Station.
		 * 
		 * @return *
		 */
		protected function broadcastHandler(e:DataEvent):*
		{
			if( e.data.action )
			{
				if( this.hasOwnProperty(e.data.action) )
				{
					if( e.data.data != null )
						this[e.data.action](e.data.data);
					else
						this[e.data.action]();
				}
			}
		}
		
		/**
		 * Handler for response() called by children views.
		 * 
		 * @param e An instance of the DataEvent from the view.
		 * 
		 */
		private function viewResponseHandler(e:DataEvent):void
		{
			if( e.data.action )
			{
				if( this.hasOwnProperty(e.data.action) )
				{
					if( e.data.data != null)
						this[e.data.action](e.data.data);
					else
						this[e.data.action]();
				}
			}
			e.stopImmediatePropagation();
		}
		
		public function set model(value:Class):void
		{
			_model = new value() as value;
		}
		
	}
}