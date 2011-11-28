package com.ripeworks.Stellar.core
{
	import flash.utils.getQualifiedClassName;
	
	import com.ripeworks.Stellar.interfaces.IControl;
	import com.ripeworks.Stellar.core.Relationship;
	
	/**
	 * Static class manager for Model Relationships.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Mike Kruk
	 * @since 01.15.2010
	 */
	public class Relationships
	{
		public static var environment:Environment;
		private static var _relationships:Array = [];
		
		public function Relationships():void { }
		
		public static function create(relationship:Relationship):void
		{
			if( !_relationships )
				_relationships = [];
			_relationships[_relationships.length] = relationship;
		}
		
		public static function sync():void
		{
			var i:int = 0;
			var limit:int = _relationships.length;
			for( i;i<limit;i++)
			{
				if( !_relationships[i].controller )
				{
					var j:int = 0;
					for(j;j<environment.instances.length;j++)
					{
						if( environment.instances[j] is _relationships[i].type)
						{
							_relationships[i].controller = environment.instances[j];
						}
					}
				}
				
			}
		}
	}
}