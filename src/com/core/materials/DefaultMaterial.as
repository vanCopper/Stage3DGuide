package com.core.materials
{
	import com.Stage3DProxy;
	import com.utils.TextureUtil;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.textures.Texture;

	public class DefaultMaterial extends MaterialBase
	{
		private static var _texture:Texture;
//		private static var _bitmapData:BitmapData;
		private var _preContext3D:Context3D;
		
		public function DefaultMaterial()
		{
			super();
		}
		
		override public function active():void
		{
			//TODO:
			if(_texture == null) createTexture();	
			Stage3DProxy.instance.context3d.setTextureAt(0, _texture);
		}
		
		override public function deactive():void
		{
			//TODO:
			Stage3DProxy.instance.context3d.setTextureAt(0, null);
		}
		
		private function createTexture():void
		{
			if(!_texture || _preContext3D != Stage3DProxy.instance.context3d)
			{
				var btpData:BitmapData = getDefaultBitmapData();
				_texture = TextureUtil.creatTextureFormBitmapData(btpData, Stage3DProxy.instance.context3d);
			}
			
			_preContext3D = Stage3DProxy.instance.context3d;
		}
		
		private function getDefaultBitmapData():BitmapData
		{
			var btpData:BitmapData = new BitmapData(8, 8, false, 0x0);
			var i:uint, j:uint;
			for (i = 0; i < 8; i++) {
				for (j = 0; j < 8; j++) {
					if ((j & 1) ^ (i & 1))
						btpData.setPixel(i, j, 0XFFFFFF);
				}
			}
			return btpData;
		}
	}
}