package
{
	import com.adobe.utils.PerspectiveMatrix3D;
	import com.adobe.utils.extended.AGALMiniAssembler;
	import com.parser.OBJParser;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	
	/**
	 * 
	 * @author vanCopper
	 */
	[SWF(backgroundColor="#333333", frameRate="60", width="800", height="600")]
	public class ALightTest extends Sprite
	{
		[Embed (source = "../assets/spaceship.obj", mimeType = "application/octet-stream")] 
		private var objData:Class;
		
		[Embed (source = "../assets/spaceship_texture.jpg")] 
		private var TextureBitmap:Class;
		private var textureData:Bitmap = new TextureBitmap();
		
		public function ALightTest()
		{
			if(this.stage)
			{
				init();
			}else
			{
				addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
		
		private function init(e:Event = null):void
		{
			if(hasEventListener(Event.ADDED_TO_STAGE))removeEventListener(Event.ADDED_TO_STAGE,init);
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			initStage3D();
		}
		
		private var _stage3D:Stage3D;
		private var _context3D:Context3D;
		private function initStage3D():void
		{
			_stage3D = this.stage.stage3Ds[0];
			_stage3D.addEventListener(Event.CONTEXT3D_CREATE,onContext3DCreated);
			_stage3D.requestContext3D("auto", Context3DProfile.STANDARD);
		}
		
		private var _sw:int;
		private var _sh:int;
		private function onContext3DCreated(e:Event):void
		{
			_context3D = _stage3D.context3D;
			if(_context3D)
			{
				trace('driverInfo: ',_context3D.driverInfo);
				_sw = 800;
				_sh = 600;
				_stage3D.x = (this.stage.stageWidth - _sw)/2;
				_stage3D.y = (this.stage.stageHeight - _sh)/2;
				_context3D.configureBackBuffer(_sw,_sh,1);
				_context3D.clear(205,205,205);
				
				initData();
				initShader();
				addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}
		}
		
		private var _objParser:OBJParser;
		private var _postionVertexBuffer:VertexBuffer3D;
		private var _uvVertexBuffer:VertexBuffer3D;
		private var _indexBuffter:IndexBuffer3D;
		private var _texture:Texture;
		private var _textureSize:uint = 512;
		private var projectionmatrix:PerspectiveMatrix3D;
		private var viewmatrix:Matrix3D;
		private var _colorData:Vector.<Number>;
		
		private function initData():void
		{
			
			var vertices:Vector.<Number> = Vector.<Number>([
				0.5, 0.0, 0.5, 1, 0, 0,
				0.5, 0.0, -0.5, 1, 0, 0,
				-0.5, 0.0, -0.5, 1, 0, 0,
				-0.5, 0.0, 0.5, 1, 0, 0,
				0.0, 0.7, 0.0, 0, 0, 1
			])
			
			var indices:Vector.<uint> = Vector.<uint>([
				0, 1, 2,
				2, 3, 0, 
				0, 4, 3,
				1, 0, 4,
				1, 4, 2,
				4, 2, 3
			]);
//			
//			GLfloat vertices[] = {
//				0.0f, -0.5f, 0.5f,
//				0.0f, 0.5f, 0.5f,
//				1.0f, 0.5f, 0.5f,
//				1.0f, -0.5f, 0.5f,
//				
//				1.0f, -0.5f, -0.5f,
//				1.0f, 0.5f, -0.5f,
//				0.0f, 0.5f, -0.5f,
//				0.0f, -0.5f, -0.5f,
//			};
//			
//			GLubyte indices[] = {
//				0, 1, 1, 2, 2, 3, 3, 0,
//				4, 5, 5, 6, 6, 7, 7, 4,
//				0, 7, 1, 6, 2, 5, 3, 4
//			};
			
			var vertexBuffer:VertexBuffer3D = _context3D.createVertexBuffer(vertices.length/6, 6);
			vertexBuffer.uploadFromVector(vertices, 0, vertices.length/6)
				
			_indexBuffter = _context3D.createIndexBuffer(indices.length);
			_indexBuffter.uploadFromVector(indices, 0, indices.length);
			
			_context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
			
			projectionmatrix = new PerspectiveMatrix3D();
			projectionmatrix.identity();
			projectionmatrix.perspectiveFieldOfViewRH(
				45.0, _sw / _sh, 0.01, 100.0);
			
			
			viewmatrix = new Matrix3D();
			viewmatrix.identity();
			viewmatrix.appendTranslation(0,0,-2);
		}
		
		private var _program:Program3D;
		private function initShader():void
		{
			var vertexSrc:String = "m44 op, va0, vc0\n" +
				"mov v0, va1\n";
			var fragmentsrc:String = "mov oc, v0\n";
			var shaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			_program = shaderAssembler.assemble2(_context3D, 2, vertexSrc, fragmentsrc);
			_context3D.setProgram(_program);
			
		}
		
		private var t:Number = 0;
		private var looptemp:int = 0;
		private var modelmatrix:Matrix3D = new Matrix3D();
		private var modelViewProjection:Matrix3D = new Matrix3D();
		private function onEnterFrame(e:Event):void
		{
			_context3D.clear(0,0,0,.7); 
			t += 2.0;
			_context3D.setTextureAt(0, _texture);
			_context3D.setProgram (_program);
			
			modelmatrix.identity();
			modelmatrix.appendRotation(t*1.0, Vector3D.Y_AXIS);
			
			modelViewProjection.identity();
			modelViewProjection.append(modelmatrix);
			modelViewProjection.append(viewmatrix);
			modelViewProjection.append(projectionmatrix);
			
			_context3D.setProgramConstantsFromMatrix(
				Context3DProgramType.VERTEX, 
				0, modelViewProjection, true );
			_context3D.drawTriangles(
				_indexBuffter, 0, 6);
			
			_context3D.present();
		}
	}
}