package com.core.shaders
{
	/**
	 * 
	 * @author vancopper
	 * 
	 */	
	public class SolidWireframeShader extends ShaderBase
	{
		public function SolidWireframeShader()
		{
			super();
		}
		
		override public function get vertexSrc():String
		{
			var str:String = 
				//va0: pos va1: uv va2: Normal va3: distance
				"m44 op, va0, vc0\n" +
				"mov v0, va1\n" +
				"mov v1, va2\n" +
				"mov v2, va3\n";
			
			return str;
		}
		
		override public function get fragmentSrc():String
		{
			var str:String = 
				//采样
				"tex ft0, v0, fs0 <2d, linear, nomip>\n" +
				//线的颜色存储至 ft1
				"mov ft1, fc0\n" +
				//取三条垂线距离最短的存储至 ft2.x
				"min ft2.x, v2.x, v2.y\n" +
				"min ft2.x, ft2.x, v2.z\n" +
				// ft3 = ft2.x < fc1.x ? 1 : 0  fc1.x为线的粗细
				"slt ft3, ft2.x, fc1.x\n" +
				//线的颜色 ft1 = ft1 x ft3(1或者0)
				"mul ft1, ft1, ft3\n" +
				//ft3 = 1 - ft3 (取反)
				"sub ft3, fc1.y, ft3\n" +
				//材质颜色 ft0 = ft0 x ft3 (1或者0)
				"mul ft0, ft0, ft3\n" +
				//输出最终颜色
				"add oc, ft1, ft0\n ";
			return str;
			
			//constants
			// fc0:颜色
			// fc1.x:1, fc1.y:-2, fc1.z:2, fc1.w: pow = 2
			// fc2.x: thickness - 1, fc2.y thickness + 1			
			
			//temps
			//ft0: d fragment distance
			//ft1: 0 / 1
			//ft2: 颜色
			//ft3: 平滑值
			//ft4: temp
			//shader
			/**
			var str:String = 
				"mov ft2, fc0\n" +
				"min ft0.x, v2.x, v2.y\n" +
				"min ft0.x, ft0.x, v2.z\n" +
				
				"sub ft4, fc2.x, ft0.x\n" +
				"sub ft4, fc1.z, ft4\n" +
				"pow ft4, ft4, fc1.w\n" +
				"mul ft4, ft4, fc1.y\n" +
				"exp ft3, ft4\n" +
				
				"slt ft1, ft0.x, fc2.x\n" +
				"mul ft4, fc1.x, ft1\n" +
				"sub ft1, fc1.x, ft1\n" +
				"mul ft3, ft3, ft1\n" +
				"add ft4, ft4, ft3\n" +
				"mul ft2.w, ft2.w, ft4\n" +
				
				"slt ft1, ft0.x, fc2.y\n" +
				"sub ft4, ft1, fc1.x\n" +
				
				"kill ft4.x\n" +
				"tex ft0, v0, fs0 <2d, repeat, linear, nomip>\n" +
//				"mul ft0, ft0, ft1\n" +
//				"add oc, ft2, ft0\n" +
				"mov oc, ft2\n";
			
			return str;
			*/
		}
	}
}