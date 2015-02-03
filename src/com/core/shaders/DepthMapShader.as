package com.core.shaders
{
	import com.Stage3DProxy;
	
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;

	/**
	 * 深度图Shader 
	 * @author vancopper
	 * 
	 */	
	public class DepthMapShader extends ShaderBase
	{
		private var _data:Vector.<Number>;
//		private var _rttData:Vector.<Number> = new <Number>[1, 1, 1, 1];
		
		public function DepthMapShader()
		{
			super();
			_data = Vector.<Number>([    1.0, 255.0, 65025.0, 16581375.0,
				1.0/255.0, 1.0/255.0, 1.0/255.0, 0.0,
				0.0, 0.0, 0.0, 0.0]);
		}
		
		override public function active():void
		{
//			Stage3DProxy.instance.context3d.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			Stage3DProxy.instance.context3d.setDepthTest(true, Context3DCompareMode.LESS);
			Stage3DProxy.instance.context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _data, 3);
			super.active();
		}
		
		override public function get vertexSrc():String
		{
			return "m44 vt0, va0, vc0\n" +
				"mov v1, va1 \n" +
				"mov v2, va2 \n" +
				"mov op, vt0 \n" +
				"mov v0, vt0 \n";
		}
		
		override public function get fragmentSrc():String
		{
			return	"div ft2, v0, v0.w	\n"	+	
				 "mul ft0, fc0, ft2.z \n" +	
				 "frc ft0, ft0	\n" +			
				 "mul ft1, ft0.yzww, fc1 \n" +	
				 "sub oc, ft0, ft1 \n";//+
//				 "sub ft2, ft0, ft1 \n" +
//				 "mov oc, ft2.z \n";
		}
	}
}