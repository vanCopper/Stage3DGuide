package
{
	import com.Stage3DProxy;
	import com.View3D;
	import com.core.entities.MeshNode;
	import com.core.geometry.GeometryBase;
	import com.core.materials.TextureMaterial;
	import com.core.shaders.SolidWireframeShader;
	import com.debug.Stats;
	import com.parser.OBJParser;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	[SWF(width='600',height='450',backgroundColor='0x333333',frameRate="60")]
	public class SolidWireframeTest extends Sprite
	{
//		[Embed(source="../assets/arrow.jpg")]
//		private static var TextureClass:Class;
		
		[Embed (source = "../assets/spaceship.obj", 
		mimeType = "application/octet-stream")] 
		private var objData:Class;
		
		[Embed (source = "../assets/spaceship_texture.jpg")] 
		private var TextureBitmap:Class;
		private var textureData:Bitmap = new TextureBitmap();
		
		private var _view3d:View3D;
		
		public function SolidWireframeTest()
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStage);
		}
		
		private function addToStage(e:Event):void
		{
			init();
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private var _angle:int = 1;
		private function onEnterFrame(e:Event):void
		{
			_meshNode.rotationY += 1;
//			_angle += 1;
//			_view3d.camera3D.rotaion(_angle, "y");
			_view3d.render();
		}
		
		private function init():void
		{
			addChild(new Stats());
			
			_view3d = new View3D();
			_view3d.camera3D.distance = 3;
			this.stage.addChild(_view3d);
			onResize(null);
			
			initObject();
		}
		
		private var _meshNode:MeshNode;
		private var _objParser:OBJParser;
		private function initObject():void
		{
			var objdata:ByteArray = new objData() as ByteArray;
			_objParser = new OBJParser(objdata);
			
			var pGeo:GeometryBase = new GeometryBase();
			pGeo.updateVertexData(_objParser.vertexsData);
			pGeo.updateIndexData(_objParser.indexData);
			pGeo.updateUVData(_objParser.uvData);
//			pGeo.updateNormalData(_objParser.normalData);
			
//			var pGeo:PlaneGeometry = new PlaneGeometry(10, 10);
//			var pGeo:SphereGeometry = new SphereGeometry(5);
			var mat:TextureMaterial = new TextureMaterial();
			mat.bitmapData = (new TextureBitmap() as Bitmap).bitmapData;
			
			_meshNode = new MeshNode(pGeo, mat, new SolidWireframeShader);
			
			_view3d.scene3D.addChild(_meshNode);
			
			setTimeout(func, 100);
			function func():void
			{
				var disV:Vector.<Number> = new Vector.<Number>();
				var vertexV:Vector.<Number> = pGeo.vertexes;
				var indexes:Vector.<uint> = pGeo.indexes;
				var numT:uint = indexes.length/3;
				trace();
				for(var i:int = 0; i < numT; i++)
				{
					var indexA:int = indexes[i*3]*3;
					var indexB:int = indexes[i*3 + 1]*3;
					var indexC:int = indexes[i*3 + 2]*3;
					var pA:Vector3D = new Vector3D(vertexV[indexA], vertexV[indexA + 1], vertexV[indexA + 2]);
					var pB:Vector3D = new Vector3D(vertexV[indexB], vertexV[indexB + 1], vertexV[indexB + 2]);
					var pC:Vector3D = new Vector3D(vertexV[indexC], vertexV[indexC + 1], vertexV[indexC + 2]);
					
					//A->BC
					disV.push(vertexEdgeDistance(pA,pB,pC), 0, 0);
					//B->CA
					disV.push(0, vertexEdgeDistance(pB,pC,pA), 0);
					//C->AB
					disV.push(0, 0, vertexEdgeDistance(pC,pA,pB))
				}
				var disVB:VertexBuffer3D = Stage3DProxy.instance.context3d.createVertexBuffer(disV.length/3, 3);
				disVB.uploadFromVector(disV, 0, disV.length/3);
				Stage3DProxy.instance.context3d.setVertexBufferAt(3, disVB, 0, Context3DVertexBufferFormat.FLOAT_3);
				
				_view3d.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onResize(e:Event):void
		{
			if(_view3d)
			{
				_view3d.width = this.stage.stageWidth - 100;
				_view3d.height = this.stage.stageHeight - 80;
				
				_view3d.x = (this.stage.stageWidth - _view3d.width)/2;
				_view3d.y = (this.stage.stageHeight - _view3d.height)/2;
			}
		}

		
		/**
		 * 计算 v0 至线段 v1-v2 的距离 
		 * @param v0
		 * @param v1
		 * @param v2
		 * @return 
		 * 
		 */		
		private function vertexEdgeDistance(v0:Vector3D, v1:Vector3D, v2:Vector3D):Number
		{
			var sub1:Vector3D = subtractV(v1, v0);
			var sub2:Vector3D = subtractV(v2, v1);
			var sub3:Vector3D = subtractV(v2, v1);
			
			var c:Vector3D = cross(sub1, sub2);
			
			return magnitude(c)/magnitude(sub3);
		}
		
		private function subtractV(v0:Vector3D, v1:Vector3D):Vector3D
		{
			return new Vector3D(v0.x - v1.x, v0.y - v1.y, v0.z - v1.z);
		}
		
		private function cross(v0:Vector3D, v1:Vector3D):Vector3D
		{
			return new Vector3D(v0.y * v1.z - v0.z * v1.y,
								v0.z * v1.x - v0.x * v1.z,
								v0.x * v1.y - v0.y * v1.x);
		}
		
		private function magnitude(v0:Vector3D):Number
		{
			return Math.sqrt(v0.x * v0.x + v0.y * v0.y + v0.z * v0.z);
		}
	}
}