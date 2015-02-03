package com.effects.postprocessing
{
	import com.Stage3DProxy;
	
	import flash.display3D.Context3DProgramType;

	/**
	 * 灰度图 
	 * @author vancopper
	 * 
	 */	
	public class GrayscaleEffect extends PostEffectShaderBase
	{
		private static const CONSTANTS_DATA:Vector.<Number> = new <Number>[0.3, 0.59, 0.11, 0];
		public function GrayscaleEffect()
		{
			super();
		}
		
		override public function get fragmentSrc():String
		{
			return "tex ft0, v0, fs0 <2d,clamp,linear>\n" +
				"dp3 ft0.x, ft0, fc0\n" +
				"mov ft0.y, ft0.x\n" +
				"mov ft0.z, ft0.x\n" +
				"mov oc, ft0\n";
		}
		
		override protected function uploadProgram3DConstants():void
		{
			Stage3DProxy.instance.context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,
				0, CONSTANTS_DATA);
		}
	}
}