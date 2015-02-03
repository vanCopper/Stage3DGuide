package com.effects.postprocessing
{
	import com.Stage3DProxy;
	
	import flash.display3D.Context3DProgramType;
	import flash.utils.getTimer;

	/**
	 * 波动效果 
	 * @author vancopper
	 * 
	 */	
	public class WaveEffect extends PostEffectShaderBase
	{
		private var _time:Number = 0;
		private static const CONSTANTS_DATA:Vector.<Number> = new <Number>[0, 10, 0.01, 0];
		public function WaveEffect()
		{
			super();
		}
		
		override public function get fragmentSrc():String
		{
			return "mov ft0, v0	\n" +
				"mov ft1, fc0 \n" +
				"mul ft2.x, ft0.x, ft1.y \n" +//Tex.x*10->ft2.x
				"mul ft2.y, ft0.y, ft1.y \n" +//Tex.y*10->ft2.y
				"add ft2.x, ft2.x, ft1.x \n" +//time + Tex.x*10 -> ft2.x
				"add ft2.y, ft2.y, ft1.x \n" +//time + Tex.y*10 -> ft2.y
				"sin ft2.x, ft2.x \n" +
				"cos ft2.y, ft2.y \n" +
				"mul ft2.x, ft2.x, ft1.z \n" +
				"mul ft2.y, ft2.y ft1.z \n" +
				"add ft0.x, ft0.x, ft2.x	\n" +
				"add ft0.y, ft0.y, ft2.y	\n" +
				"tex oc, ft0, fs0<2d, clamp, linear>\n";
		}
		
		override protected function uploadProgram3DConstants():void
		{
			//TODO:
			_time += 0.1;
			CONSTANTS_DATA[0] = _time;
			
			Stage3DProxy.instance.context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, CONSTANTS_DATA);
		}
	}
}