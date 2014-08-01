package
{
	import com.adobe.utils.extended.AGALMiniAssembler;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	[SWF(backgroundColor="#333333", frameRate="60", width="800", height="600")]
	public class TextureTest extends Sprite
	{
		private var _context3d:Context3D;
		private var _stage3d:Stage3D;
		
		private var _vertexBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		
		private var _program3d:Program3D;
		
		private var _texture:Texture;
		
		[Embed(source="./assets/floor_diffuse.jpg")]
		private static var TextureClass:Class;
		
		public function TextureTest()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			if(this.stage.stage3Ds.length > 0)
			{
				_stage3d = this.stage.stage3Ds[0];
				_stage3d.addEventListener(ErrorEvent.ERROR, onCreateContext3DError);
				_stage3d.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
				_stage3d.requestContext3D(Context3DRenderMode.AUTO, Context3DProfile.STANDARD);
			}
		}
		
		private function onContext3DCreated(event:Event):void
		{
			initContext3D();
			initBuffer();
			initTexture();
			initProgram();
			
			addEventListener(Event.ENTER_FRAME, render);
		}
		
		private function render(event:Event):void
		{
			_context3d.clear(0, 0, 0);
			_context3d.drawTriangles(_indexBuffer);
			_context3d.present();
		}
		
		private function onCreateContext3DError(event:ErrorEvent):void
		{
			trace(event.text);
		}
		
		private function initContext3D():void
		{
			_context3d = _stage3d.context3D;	
			_stage3d.x = 50;
			_stage3d.y = 50;
			_context3d.configureBackBuffer(700, 500, 2);
		}
		
		private function initBuffer():void
		{
			var vertexData:Vector.<Number> = Vector.<Number>(
				[
					// x, y, z, u, v
					-0.5, 0.5, 0, 0, 0,
					0.5, 0.5, 0, 1, 0,
					0.5, -0.5, 0, 1, 1,
					-0.5, -0.5, 0, 0, 1
				]);	
			
			var indexData:Vector.<uint> = Vector.<uint>(
				[0, 1, 2, 2, 3, 0]);
			
			_vertexBuffer = _context3d.createVertexBuffer(vertexData.length/5, 5);
			_vertexBuffer.uploadFromVector(vertexData, 0, vertexData.length/5);
			
			_indexBuffer = _context3d.createIndexBuffer(indexData.length);
			_indexBuffer.uploadFromVector(indexData, 0, indexData.length);
		}
		
		private function initTexture():void
		{
			_texture = _context3d.createTexture(512, 512, Context3DTextureFormat.BGRA, true);
			_texture.uploadFromBitmapData((new TextureClass() as Bitmap).bitmapData);
		}
		
		private function initProgram():void
		{
			var vertexSrc:String = "mov op, va0\n" +
				"mov v0, va1\n";
			var fragmentsrc:String = "tex ft0, v0, fs0 <2d, repeat, linear, nomip>\n" +
				"mov oc ft0\n";
			var shaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			_program3d = shaderAssembler.assemble2(_context3d, 2, vertexSrc, fragmentsrc);
			
			_context3d.setVertexBufferAt(0, _vertexBuffer, 0, 
				Context3DVertexBufferFormat.FLOAT_3);
			_context3d.setVertexBufferAt(1, _vertexBuffer, 3, 
				Context3DVertexBufferFormat.FLOAT_2);
			_context3d.setTextureAt(0, _texture);
			_context3d.setProgram(_program3d);

		}
		
	}
}