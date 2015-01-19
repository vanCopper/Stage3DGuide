package
{
	import com.Stage3DProxy;
	import com.View3D;
	import com.core.entities.MeshNode;
	import com.core.geometry.SphereGeometry;
	import com.core.materials.TextureMaterial;
	import com.core.shaders.MorphingShader;
	import com.debug.Stats;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	
	[SWF(width='600',height='450',backgroundColor='0x333333',frameRate="60")]
	public class MorphingTest extends Sprite
	{
		[Embed(source="../assets/arrow.jpg")]
		private static var TextureClass:Class;
		
		private var _view3d:View3D;
		private var _radius:Number = 0;
		private var _speed:Number = 0.01;
		
		public function MorphingTest()
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
		
		private function onEnterFrame(e:Event):void
		{
			_meshNode.rotationY += 1;
			
			_radius += _speed ;
			if(_radius > 0.5)
			{
				_speed = -0.01;
			}
			
			if(_radius < -0.5)
			{
				_speed = 0.01;
			}
			_view3d.configBackBuffer();
			Stage3DProxy.instance.context3d.clear();
			
			Stage3DProxy.instance.context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, Vector.<Number>([ 60, 50, 40, 1 ]));
			Stage3DProxy.instance.context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, Vector.<Number>([ _radius, _radius, _radius, _radius ]));
			
			_view3d.render();
		}
		
		private function init():void
		{
			addChild(new Stats());
			
			_view3d = new View3D();
			this.stage.addChild(_view3d);
			onResize(null);
			
			initObject();
		}
		
		private var _meshNode:MeshNode;
		private var _g_fTime:Number = 0;
		private var _raw:Vector.<Number>;
		private var vertexBuffer:VertexBuffer3D;
		private function initObject():void
		{
			var pGeo:SphereGeometry = new SphereGeometry(5);
			var mat:TextureMaterial = new TextureMaterial();
			mat.bitmapData = (new TextureClass() as Bitmap).bitmapData;
			
			_meshNode = new MeshNode(pGeo, mat, new MorphingShader);
			
			_view3d.scene3D.addChild(_meshNode);
			
			this.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
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
	}
}