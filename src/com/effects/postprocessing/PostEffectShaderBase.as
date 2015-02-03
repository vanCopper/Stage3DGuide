package com.effects.postprocessing
{
	import com.core.shaders.ShaderBase;
	/**
	 * 
	 * @author vancopper
	 * 
	 */	
	public class PostEffectShaderBase extends ShaderBase
	{
		public function PostEffectShaderBase()
		{
			super();
		}
		
		override public function get vertexSrc():String
		{
			return "mov op, va0\n" +
				"mov v0, va1\n";
		}
	}
}