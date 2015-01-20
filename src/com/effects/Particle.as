package com.effects
{
	import flash.display3D.textures.TextureBase;
	/**
	 *  
	 * @author vancopper
	 * 
	 */	
	public class Particle
	{
		public var diffuse:TextureBase;
		public var opacity:TextureBase;
		public var blendSource:String;
		public var blendDestination:String;
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var rotation:Number;
		
		public var width:Number;
		public var height:Number;
		public var originX:Number;
		public var originY:Number;
		
		public var uvScaleX:Number;
		public var uvScaleY:Number;
		public var uvOffsetX:Number;
		public var uvOffsetY:Number;
		
		public var red:Number;
		public var green:Number;
		public var blue:Number;
		public var alpha:Number;
		
		public var next:Particle;
		
		static public var collector:Particle;
		
		static public function create():Particle {
			var res:Particle;
			if (collector != null) {
				res = collector;
				collector = collector.next;
				res.next = null;
			} else {
				//trace("new Particle");
				res = new Particle();
			}
			return res;
		}
	}
}