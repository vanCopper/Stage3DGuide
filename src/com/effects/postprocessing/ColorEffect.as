package com.effects.postprocessing
{
	/**
	 *  
	 * @author vancopper
	 * 
	 */	
	public class ColorEffect extends PostEffectShaderBase
	{
		public function ColorEffect()
		{
			super();
		}
		
		override public function get fragmentSrc():String
		{
			return "tex ft0, v0, fs0<2d, clamp, linear>\n" +
				"sub ft0.yz, ft0.yz, ft0.yz \n" +
				"mov oc, ft0\n";
		}
	}
}