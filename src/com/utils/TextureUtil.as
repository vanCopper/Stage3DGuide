package com.utils
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;

	/**
	 *  
	 * @author vancopper
	 * 
	 */	
	public class TextureUtil
	{
		private static const MAX_SIZE:uint = 2048;
		
		public function TextureUtil()
		{
		}
		
		/**
		 * 从bitmapData中创建纹理 
		 * @param bitmapData
		 * @param context3d
		 * @param miplevel
		 * @return 
		 * 
		 */		
		public static function creatTextureFormBitmapData(bitmapData:BitmapData, context3d:Context3D, miplevel:uint = 0):Texture
		{
			if(!bitmapData || !context3d)return null;
			var width:int = bitmapData.width;
			var height:int = bitmapData.height;
			if((width&(width - 1)) || (height&(height - 1)))
			{
				throw new Error("纹理大小不为2的幂数");
			}
			
			var texture:Texture = context3d.createTexture(width, height, Context3DTextureFormat.BGRA, false);
			texture.uploadFromBitmapData(bitmapData, miplevel);
			return texture;
		}
		
		public static function getBestPowerOf2(value):uint
		{
			trace(value);
			var p:uint = 1;
			
			while (p < value)
				p <<= 1;
			
			if (p > MAX_SIZE)
				p = MAX_SIZE;
			
			trace(p);
			return p;
		}
	}
}