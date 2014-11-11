package com.core.shaders
{
	public class DefaultShader extends ShaderBase
	{
		public function DefaultShader()
		{
			super();
		}
		
		override public function get vertexSrc():String
		{
			return "m44 op, va0, vc0\n" +
				   "mov v0, va1\n" +
				   "mov v1, va2\n";
		}
		
		override public function get fragmentSrc():String
		{
			return  "tex ft0, v0, fs0 <2d, repeat, linear, nomip>\n" +
					"mov oc ft0\n";
		}
	}
}