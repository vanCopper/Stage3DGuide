package com.core.shaders
{
	public class MorphingShader extends ShaderBase
	{
		public function MorphingShader()
		{
			super();
		}
		override public function get vertexSrc():String
		{
			var str:String =
				"mov vt0, va0	\n" +
				//wave
				"dp4 vt2, vt0, vc4	\n" +
				"cos vt3, vt2	\n" +
				"sin vt3, vt3   \n" +
				"add vt1, vt0, vt3	\n" +
				//lerp
				"sub vt0, vt1, va0  \n" +
				"mul vt0, vt0, vc5	\n" +
				"add vt0, vt0, va0	\n" +
				
				// project 
				"m44 op, vt0, vc0	\n" +
				//UV
				"mov v0, va1	\n" +
				//Normal
				"mov v1, va2	\n";
			
			return str; 
		}
		
		override public function get fragmentSrc():String
		{
			return  "tex ft0, v0, fs0 <2d, repeat, linear, nomip>\n" +
				"mov oc ft0\n";
		}
	}
}