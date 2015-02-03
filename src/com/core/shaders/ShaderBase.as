package com.core.shaders
{
	import com.Stage3DProxy;
	import com.adobe.utils.extended.AGALMiniAssembler;
	
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;

	/**
	 * 
	 * @author vancopper
	 * 
	 */	
	public class ShaderBase
	{
		private var _program3d:Program3D;
		private var _preContext3D:Context3D;
		private var _shaders:Vector.<ShaderBase> = new Vector.<ShaderBase>();
		
		public function ShaderBase()
		{
		}
		
		protected function uploadProgram3DConstants():void
		{
			//Override
		}
		
		public function active():void
		{
			if(!_program3d || _preContext3D != Stage3DProxy.instance.context3d)
			{
				var vStr:String = vertexSrc;
				var fStr:String = fragmentSrc;
				var shaderBase:ShaderBase;
				for(var i:int = 0; i < _shaders.length; i++)
				{
					shaderBase = _shaders[i];
					vStr += shaderBase.vertexSrc;
					fStr += shaderBase.fragmentSrc;
				}
				
				var agalA:AGALMiniAssembler = new AGALMiniAssembler();
				_program3d = agalA.assemble2(Stage3DProxy.instance.context3d, 2, vStr, fStr);
			}
			_preContext3D = Stage3DProxy.instance.context3d;
			Stage3DProxy.instance.context3d.setProgram( _program3d );
			
			uploadProgram3DConstants();
		}
		
		public function deactive():void
		{
			//TODO:
			Stage3DProxy.instance.context3d.setProgram(null);
		}
		
		public function addShader(shader:ShaderBase):void
		{
			if(!shader)return;
			if(_shaders.indexOf(shader) == -1)return;
			
			_shaders.push(shader);
		}
		
		public function removeShader(shader:ShaderBase):void
		{
			if(!shader)return;
			var index:int = _shaders.indexOf(shader);
			if(index == -1)return;
			
			_shaders.splice(index, 1);
		}
		
		public function get vertexSrc():String
		{
			//TODO
			return "";
		}
		
		public function get fragmentSrc():String
		{
			//TODO
			return "";
		}
	}
}