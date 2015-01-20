package com.core.materials
{
	import com.Stage3DProxy;
	import com.utils.TextureUtil;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.textures.Texture;

	/**
	 * 
	 * @author vancopper
	 * 
	 */	
	public class MaterialBase
	{
		public var bitmapData:BitmapData;	
		private var _texture:Texture;
		private var _preContext3D:Context3D;
		
		public function MaterialBase()
		{
		}
		
		public function active():void
		{
			//TODO:
			Stage3DProxy.instance.context3d.setTextureAt(0, texture);
		}
		
		public function deactive():void
		{
			//TODO:
			Stage3DProxy.instance.context3d.setTextureAt(0, null);
		}
		
		public function get texture():Texture
		{
			if(!_texture || _preContext3D != Stage3DProxy.instance.context3d)
			{
				_texture = TextureUtil.creatTextureFormBitmapData(bitmapData, Stage3DProxy.instance.context3d);
			}
			
			_preContext3D = Stage3DProxy.instance.context3d;
			return _texture;
		}
	
	}
}