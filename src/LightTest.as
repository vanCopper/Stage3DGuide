package
{
	import com.adobe.utils.PerspectiveMatrix3D;
	import com.adobe.utils.extended.AGALMiniAssembler;
	import com.parser.OBJParser;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	
	/**
	 * 灯光测试
	 * @author vanCopper
	 */
	[SWF(width='1000',height='800',backgroundColor='0x333333',frameRate="60")]
	public class LightTest extends Sprite
	{
		[Embed (source = "../assets/spaceship.obj", 
		mimeType = "application/octet-stream")] 
		private var objData:Class;
		
		[Embed (source = "../assets/spaceship_texture.jpg")] 
		private var TextureBitmap:Class;
		private var textureData:Bitmap = new TextureBitmap();
		
		[Embed(source = "../assets/ship_normalsmap.jpg")]
		private var NormalBitmap:Class;
		private var _normalTextureData:Bitmap = new NormalBitmap();
		
		private var _lightDirection : Matrix3D = new Matrix3D();
		
		public function LightTest()
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

		//漫反射光颜色
		private var _diffuseLightColor:Vector.<Number> = Vector.<Number>([1, 1, 1, 1.0]);
		//环境光颜色
		private var _ambientColor:Vector.<Number> = Vector.<Number>([0.8, 0.5, 0.5, 1.0]);
		
		private var _normalVertexBuffer:VertexBuffer3D;
		private var _normalTexture:Texture;
		
		private function initData():void
		{
			var objdata:ByteArray = new objData() as ByteArray;
			_objParser = new OBJParser(objdata);
			
			var posVertexs:Vector.<Number> = _objParser.vertexsData;
			var posVertexsCont:uint = posVertexs.length/3;
			_postionVertexBuffer = _context3D.createVertexBuffer(posVertexsCont,3);
			_postionVertexBuffer.uploadFromVector(posVertexs,0,posVertexsCont);
			
			var uvVertexs:Vector.<Number> = _objParser.uvData;
			var uvVertexsCont:uint = uvVertexs.length/2;
			_uvVertexBuffer = _context3D.createVertexBuffer(uvVertexsCont,2);
			_uvVertexBuffer.uploadFromVector(uvVertexs,0,uvVertexsCont);
			

			_context3D.setVertexBufferAt(0,_postionVertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1,_uvVertexBuffer,0,Context3DVertexBufferFormat.FLOAT_2);
			
			var indexVertexs:Vector.<uint> = _objParser.indexData;
			_indexBuffter = _context3D.createIndexBuffer(indexVertexs.length);
			_indexBuffter.uploadFromVector(indexVertexs,0,indexVertexs.length);
			
			_texture = _context3D.createTexture(_textureSize,_textureSize,Context3DTextureFormat.BGRA,false);
			uploadTextureWithMipmaps(_texture,textureData.bitmapData);
			
			//法线贴图
			_normalTexture = _context3D.createTexture(_textureSize, _textureSize, Context3DTextureFormat.BGRA, false);
			_normalTexture.uploadFromBitmapData(_normalTextureData.bitmapData);
			
			projectionmatrix = new PerspectiveMatrix3D();
			projectionmatrix.identity();
			projectionmatrix.perspectiveFieldOfViewRH(
				45.0, _sw / _sh, 0.01, 100.0);
			
			viewmatrix = new Matrix3D();
			viewmatrix.identity();
			viewmatrix.appendTranslation(0, 0, -4);
			
//			modelmatrix.appendTranslation(0, 0, 15);
		}
		
		public function uploadTextureWithMipmaps(dest:Texture, src:BitmapData):void
		{
			var ws:int = src.width;
			var hs:int = src.height;
			var level:int = 0;
			var tmp:BitmapData;
			var transform:Matrix = new Matrix();
			
			tmp = new BitmapData(src.width, src.height, true, 0);
			
			while ( ws >= 1 && hs >= 1 )
			{ 
				tmp.draw(src, transform, null, null, null, true); 
				dest.uploadFromBitmapData(tmp, level);
				transform.scale(0.5, 0.5);
				level++;
				ws >>= 1;
				hs >>= 1;
				if (hs && ws) 
				{
					tmp.dispose();
					tmp = new BitmapData(ws, hs, true, 0x00000000);
				}
			}
			tmp.dispose();
		}
		
		private var _vertexShaderAssembler:AGALMiniAssembler;
		private var _fragmentAssembler:AGALMiniAssembler;
		private var _program:Program3D;
		private function initShader():void
		{
			_vertexShaderAssembler = new AGALMiniAssembler();
			_vertexShaderAssembler.assemble(Context3DProgramType.VERTEX,
				"m44 op, va0, vc0\n" +
				"mov v1, va1\n"
			, 2);
			
			_fragmentAssembler= new AGALMiniAssembler();
			_fragmentAssembler.assemble
				( 
					Context3DProgramType.FRAGMENT,	
					//纹理采样
					"tex ft0, v1, fs0<2d, linear, repeat>\n" +
					//法线纹理
					"tex ft1, v1, fs1<2d, linear, repeat>\n" +
					//法线转换到世界空间
					"m44 ft2 ft1 fc0\n"+
					"nrm ft2.xyz ft2.xyz\n"+
					//求法线和灯光的角度
					"dp3 ft2.w ft2.xyz fc3.xyz\n"+
					//取出大于0的部分
					"max ft2.w ft2.w fc4.w\n"+
					//diffuseColor = ft2.w * lightDiffuseColor;
					"mul ft3.xyzw ft2.wwwww fc1.xyzw\n"+
					//混合漫反射光
					"mul ft3 ft0 ft3\n"+
					//混合环境光
					"mul ft4 ft0 fc2\n"+
					//最终输出
					"add oc ft3 ft4\n"
//					"mov oc ft3\n"
				
				, 2);
			
			_program = _context3D.createProgram();
			_program.upload(_vertexShaderAssembler.agalcode,_fragmentAssembler.agalcode);
		}
		
		private var t:Number = 0;
		private var looptemp:int = 0;
		private var modelmatrix:Matrix3D = new Matrix3D();
		private var modelViewProjection:Matrix3D = new Matrix3D();
		private function onEnterFrame(e:Event):void
		{
			_context3D.clear(0,0,0,.7); 
			t += 1.0;
			_context3D.setTextureAt(0, _texture);
			_context3D.setTextureAt(1, _normalTexture);
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
			
			//世界空间矩阵 fc0
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.FRAGMENT, 0, modelmatrix.clone());
			
			//漫反射光颜色 fc1
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, _diffuseLightColor);
			
			//环境光颜色 fc2
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, _ambientColor);
			
			_lightDirection.identity();
			_lightDirection.appendTranslation(Math.sin(t/30)*30, 30, Math.cos(t/30)*30);
			
			//灯光方向 fc3
			var lightDir:Vector3D = _lightDirection.position;
			lightDir.normalize();
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([
													lightDir.x, lightDir.y, lightDir.z, 1]));
			//fc4 [常量，常量，光强度，对比参数]
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, Vector.<Number>([1,1,0.5,0]));
			
			_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			_context3D.drawTriangles(
				_indexBuffter, 0, _objParser.indexData.length/3);

			_context3D.setTextureAt(0, null);
			_context3D.setTextureAt(1, null);
			_context3D.setProgram (null);
			_context3D.present();
		}
	}
}