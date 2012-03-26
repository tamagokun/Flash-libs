package com.ripeworks.Stellar.utils
{
	import com.ripeworks.Stellar.model.ModelObject;

	import flash.external.ExternalInterface;
	/**
	 * Parser util to evaluate string based expressions
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 02.08.2010
	 */
	public class Parser
	{
		private static var _callback:Function;
		
		public function Parser():void { }
		
		public static function getCodeBlock(id:String, callback:Function):Boolean
		{
			if( !ExternalInterface.available)
				return false;
			
			_callback = callback;
			ExternalInterface.addCallback("setData",codeBlockDataHandler);
			ExternalInterface.call("Stellar.getCodeBlock",id);
			
			return true;
		}
		
		public static function parse(model:ModelObject, options:String):Boolean
		{
			var cursor:Boolean = false;
			var operator:int = 0;
			var expressions:Array = options.split(/[\s]{1}(and|or)[\s]{1}/gi);
			var i:int = 0;
			for( i; i < expressions.length; i++)
			{
				switch( expressions[i] )
				{
					case "and":
						//previous and next exp must be TRUE
						operator = 2;
						break;
					case "or":
						//previous or next exp must be TRUE
						operator = 1;
						break;
					default:
						//default used for evaluation
						switch( operator )
						{
							case 0:
								//no previous operator, go with the flow
								cursor = evaluate(model, expressions[i]);
								break;
							case 1:
								//"or" statement
								cursor = (cursor || evaluate(model, expressions[i]));
								operator = 0;
								break;
							case 2:
								//"and" statement
								var check:Boolean = evaluate(model, expressions[i]);
								if( cursor && check )
									cursor = true;
								else
									return false;
								operator = 0;
								break;
						}
						break;
				}
			}
			
			return cursor;
		}
		
		private static function evaluate(model:ModelObject, expression:String):Boolean
		{
			var regx:RegExp = /([\w]+)[\s]*?([\W]{1,2}?)[\s]*?([\w]+)/gi;
			var segments:Array = regx.exec(expression);
			var key:String = segments[1];
			var operator:String = segments[2];
			var value:String = segments[3];
			
			if( model[key] == null)
				return false;
			switch( operator.replace(/^\s+|\s+$/g, "") )
			{
				case "=":
					if( model[key] == value)
						return true;
					return false;
					break;
				case "!=":
					if( model[key] != value)
						return true;
					return false;
					break;
				case "<":
					if( model[key] < value)
						return true;
					return false;
					break;
				case ">":
					if( model[key] > value)
						return true;
					return false;
					break;
				case "<=":
					if( model[key] <= value)
						return true;
					return false;
					break;
				case ">=":
					if( model[key] >= value)
						return true;
					return false;
					break;
				default:
					return false;
					break;
			}
			return true;
		}
		
		private static function codeBlockDataHandler(value:String):void
		{
			_callback(value);
		}
	}
}