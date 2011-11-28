package com.ripeworks.util
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.StyleSheet;
	import flash.display.BlendMode;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	public class StellarTextField extends TextField
	{
		protected var _style:Object;
		private var _css:StyleSheet;
		private var _format:TextFormat;
		private var _html:Boolean;
		
		public function StellarTextField():void 
		{
			super();
			embedFonts = true;
			blendMode = BlendMode.LAYER;
			antiAliasType = AntiAliasType.ADVANCED;
		}
		
		public function init(style:String, html:Boolean=false):void
		{
			_html = html;
			_style = _css.getStyle(style);
			
			multiline = (_style.multiline)? Boolean(_style.multiline) : true;
			
			x = _style.left;
			y = _style.top;
			
			if( _style.width || _style.height )
			{
				wordWrap = true;
				width = Number(_style.width);
				height = Number(_style.height);
			}else
			{
				wordWrap = false;
				autoSize = TextFieldAutoSize.LEFT;
				if( _style.textAlign )
				{
					switch( _style.textAlign )
					{
						case "center":
							autoSize = TextFieldAutoSize.CENTER;
							break;
						case "right":
							autoSize = TextFieldAutoSize.RIGHT;
							break;
					}
				}
			}
			
			if( _html )
				this.styleSheet = _css;
			else
				_format = _css.transform(_style);
		}
		
		public override function set text(value:String):void
		{
			if( _html )
				htmlText = value;
			else
				super.text = value;
			if( _format )
				setTextFormat(_format);
		}
		
		public function set css(value:StyleSheet):void
		{
			_css = value;
		}
	}
}