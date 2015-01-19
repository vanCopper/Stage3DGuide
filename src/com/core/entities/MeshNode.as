package com.core.entities
{
	import com.Stage3DProxy;
	import com.core.geometry.GeometryBase;
	import com.core.materials.DefaultMaterial;
	import com.core.materials.MaterialBase;
	import com.core.shaders.DefaultShader;
	import com.core.shaders.ShaderBase;
	
	import flash.display.Stage;

	/**
	 * 
	 * @author vancopper
	 * 
	 */	
	public class MeshNode extends NodeBase
	{
		private var _geo:GeometryBase; 
		private var _mat:MaterialBase;
		private var _shader:ShaderBase;
		
		public function MeshNode(geo:GeometryBase, mat:MaterialBase = null, shader:ShaderBase = null)
		{
			//TODO: 添加默认材质&shader
			_geo = geo;
			_mat = mat ? mat : new DefaultMaterial();
			_shader = shader ? shader : new DefaultShader();
			super();
		}
		
		override public function render():void
		{
			if(!_geo || !_mat || !_shader)
			{
				return;
			}
			
			_geo.active();
			_mat.active();
			_shader.active();
			
			Stage3DProxy.instance.wm = modelMatrix;
			Stage3DProxy.instance.context3d.drawTriangles(_geo.indexBuffer);
			
//			_geo.deactive();
//			_mat.deactive();
//			_shader.deactive();
		}
	}
}