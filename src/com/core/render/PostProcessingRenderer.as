package com.core.render
{
	import com.Stage3DProxy;
	import com.adobe.utils.extended.AGALMiniAssembler;
	import com.core.entities.NodeBase;
	import com.effects.postprocessing.PostEffectShaderBase;
	import com.utils.TextureUtil;
	
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;

	/**
	 * 延迟渲染 
	 * @author vancopper
	 * 
	 */	
	public class PostProcessingRenderer extends RendererBase
	{
		public var postEffectShader:PostEffectShaderBase;
		public function PostProcessingRenderer()
		{
			init();
		}
		
		override public function render(rootNode:NodeBase):void
		{
			var nodes:Vector.<NodeBase> = rootNode.nodes;
			if(!nodes && !nodes.length)return;
			
			var texture:Texture = getRTTexture();
			Stage3DProxy.instance.context3d.setRenderToTexture(texture, true);
			Stage3DProxy.instance.context3d.clear(/*255, 255, 255*/);
			
			for(var i:int = 0; i < nodes.length; i++)
			{
				var node:NodeBase = nodes[i];
				node.render();
			}
			
			Stage3DProxy.instance.context3d.setRenderToBackBuffer();
			
			
			Stage3DProxy.instance.context3d.setTextureAt(0, texture);
//			Stage3DProxy.instance.context3d.setProgram(_program3d);
			postEffectShader.active();
			
			//va0  pos
			Stage3DProxy.instance.context3d.setVertexBufferAt(0, _sceneVertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			//va1 UV
			Stage3DProxy.instance.context3d.setVertexBufferAt(1, _sceneVertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			Stage3DProxy.instance.context3d.drawTriangles(_sceneIndexBuffer, 0, 2);
			//clear
			Stage3DProxy.instance.context3d.setTextureAt(0, null);
			Stage3DProxy.instance.context3d.setVertexBufferAt(0, null);
			Stage3DProxy.instance.context3d.setVertexBufferAt(1, null);
			Stage3DProxy.instance.context3d.setProgram(null);
			postEffectShader.deactive();
		}
		
		private var _sceneVertexRaw:Vector.<Number>;
		private var _sceneIndexRaw:Vector.<uint>;
		private var _sceneVertexBuffer:VertexBuffer3D;
		private var _sceneIndexBuffer:IndexBuffer3D;
		private var _agalA:AGALMiniAssembler = new AGALMiniAssembler();
		private var _program3d:Program3D;
		private function init():void
		{
			_sceneVertexRaw = Vector.<Number>([
				-1, 1, 0, 0, 0,
				1, 1, 0, 1, 0,
				1, -1, 0, 1, 1,
				-1,-1, 0, 0, 1
			]);
			
			_sceneIndexRaw = Vector.<uint>([
				0,2,3,
				0,1,2
			]);
			
			_sceneVertexBuffer = Stage3DProxy.instance.context3d.createVertexBuffer(4, 5);
			_sceneVertexBuffer.uploadFromVector(_sceneVertexRaw, 0, 4);
			_sceneIndexBuffer = Stage3DProxy.instance.context3d.createIndexBuffer(6);
			_sceneIndexBuffer.uploadFromVector(_sceneIndexRaw, 0, 6);
			
			var vStr:String = 
				"mov op, va0\n" +
				"mov v0, va1\n";
			var fStr:String = 
				"tex ft0, v0, fs0<2d, clamp, linear>\n" +
				"sub ft0.yz, ft0.yz, ft0.yz \n" +
				"mov oc, ft0\n";
			_program3d = _agalA.assemble2(Stage3DProxy.instance.context3d, 2, vStr, fStr);
		}
		
		private var _rttexture:Texture;
		/**
		 * 获取RTT材质 
		 * @param type
		 * @return 
		 * 
		 */			
		public function getRTTexture(type:int = 0):Texture
		{
			//TODO: type标记texture类型 深度缓冲、法线缓冲、颜色缓冲、位置缓冲等
			if( !_rttexture && Stage3DProxy.instance.context3d)
			{
				var w:uint = TextureUtil.getBestPowerOf2(Stage3DProxy.instance.viewWidth);
				var h:uint = TextureUtil.getBestPowerOf2(Stage3DProxy.instance.viewHeight);
				_rttexture = Stage3DProxy.instance.context3d.createTexture(w, h, Context3DTextureFormat.BGRA, true)
			}
			return _rttexture;
		}
		
	}
}