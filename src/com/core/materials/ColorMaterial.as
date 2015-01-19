package com.core.materials
{
	
	import flash.display.BitmapData;

	/**
	 * 颜色贴图 
	 * @author vancopper
	 * 
	 */	
	public class ColorMaterial extends MaterialBase
	{
		private var _matColor:uint;
		public function ColorMaterial(matColor:uint = 0xff0000)
		{
			_matColor = matColor;
		}
		
		override public function active():void
		{
			if(bitmapData == null)
			{
				bitmapData = new BitmapData(8, 8, false, _matColor);
			}
			super.active();
		}
	}
}