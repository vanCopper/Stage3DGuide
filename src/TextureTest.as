package
{
	import com.adobe.utils.PerspectiveMatrix3D;
	import com.adobe.utils.extended.AGALMiniAssembler;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	[SWF(backgroundColor="#333333", frameRate="60", width="800", height="600")]
	public class TextureTest extends Sprite
	{
		private var _context3d:Context3D;
		private var _stage3d:Stage3D;
		private var _modelMatrix:Matrix3D = new Matrix3D();
		private var _projectionmatrix:PerspectiveMatrix3D;
		private var _cameraMatrix:Matrix3D;
		private var _viewMatrix:Matrix3D;
		
		private var _vertexBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		
		private var _program3d:Program3D;
		
		private var _texture:Texture;
		
		[Embed(source="../assets/floor_diffuse.jpg")]
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
		
		private var _t:Number = 0;
		private var _speed:Number = .02;
		private var _degrees:Number = 0;
		private function render(event:Event):void
		{
			if(_t > .5) _speed = -.02;
			if(_t < -.5) _speed = .02; 
			
			_t += _speed;
			_degrees += 2.0;
			_modelMatrix.identity();
//			_modelMatrix.appendTranslation(_t, 0, 1);
			_modelMatrix.appendRotation(_degrees*1.0, Vector3D.Y_AXIS);
			
			_cameraMatrix.identity();
			_cameraMatrix.appendTranslation(0, 0, -5);
			_cameraMatrix.appendRotation(_degrees, Vector3D.Z_AXIS);
			
			_viewMatrix.identity();
			_viewMatrix.append(_modelMatrix);
			_viewMatrix.append(_cameraMatrix);
			_viewMatrix.append(_projectionmatrix);
			
			_context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _viewMatrix, true);
			
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
			
			_projectionmatrix = new PerspectiveMatrix3D();
			// 45 degrees FOV, 700/500 aspect ratio, 0.1=near, 100=far
			_projectionmatrix.perspectiveFieldOfViewRH(45.0, 700 / 500, 0.01, 100.0);
			
			_cameraMatrix = new Matrix3D();
			_cameraMatrix.appendTranslation(0, 0, -5);
			
			_viewMatrix = new Matrix3D();
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
			var vertexSrc:String = "m44 op, va0, vc0\n" +
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