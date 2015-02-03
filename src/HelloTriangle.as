package
{
	import com.adobe.utils.extended.AGALMiniAssembler;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	
	[SWF(backgroundColor="#333333", frameRate="60", width="800", height="600")]
	public class HelloTriangle extends Sprite
	{
		private var _context3d:Context3D;
		private var _stage3d:Stage3D;
		
		private var _vertexBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		
		private var _program3d:Program3D;
		
		public function HelloTriangle()
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
			initProgram();
			
			addEventListener(Event.ENTER_FRAME, render);
		}
		
		private function render(event:Event):void
		{
			var modelMatrix:Matrix3D = new Matrix3D();
//			modelMatrix.appendTranslation(0, 1, 0);
			//			_modelMatrix.position = new Vector3D(1, 0, 0);
			//			_modelMatrix.appendRotation(t*1.0, Vector3D.Z_AXIS);
			_context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, modelMatrix)
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
				// x, y, z, r, g, b
					0, 0, 0, 1, 0, 1,
					1, 1, 0, 1, 1, 0,
					1, 0, 0, 1, 0, 1
				]);
			var indexData:Vector.<uint> = Vector.<uint>(
				[0, 1, 2]);
			
			_vertexBuffer = _context3d.createVertexBuffer(vertexData.length/6, 6);
			_vertexBuffer.uploadFromVector(vertexData, 0, vertexData.length/6);
			
			_indexBuffer = _context3d.createIndexBuffer(indexData.length);
			_indexBuffer.uploadFromVector(indexData, 0, 3);
		}
		
		private function initProgram():void
		{
			var vertexSrc:String = "m44 op, va0, vc0\n" +
				"mov v0, va1\n";
			var fragmentsrc:String = "mov oc, v0\n";
			
			var shaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			_program3d = shaderAssembler.assemble2(_context3d, 2, vertexSrc, fragmentsrc);
			
			_context3d.setVertexBufferAt(0, _vertexBuffer, 0, 
				Context3DVertexBufferFormat.FLOAT_3);
			_context3d.setVertexBufferAt(1, _vertexBuffer, 3, 
				Context3DVertexBufferFormat.FLOAT_3);
			
			_context3d.setProgram(_program3d);
		}
			
	}
}