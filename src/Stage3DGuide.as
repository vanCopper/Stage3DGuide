package
{
	import com.View3D;
	import com.core.entities.MeshNode;
	import com.core.geometry.PlaneGeometry;
	import com.core.materials.TextureMaterial;
	import com.core.shaders.DefaultShader;
	import com.debug.Stats;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	[SWF(width='800',height='600',backgroundColor='0x333333',frameRate="60")]
	public class Stage3DGuide extends Sprite
	{
		[Embed(source="../assets/floor_diffuse.jpg")]
		private static var TextureClass:Class;
		
		private var _view3d:View3D;
		
		public function Stage3DGuide()
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
		
		private function init():void
		{
			addChild(new Stats());
			
			_view3d = new View3D();
			this.stage.addChild(_view3d);
			onResize(null);
			
			initObject();
		}
		
		private function initObject():void
		{
			var pGeo:PlaneGeometry = new PlaneGeometry(10,10);
			var mat:TextureMaterial = new TextureMaterial();
			mat.bitmapData = (new TextureClass() as Bitmap).bitmapData;
			
			var meshNode:MeshNode = new MeshNode(pGeo, mat, new DefaultShader);
//			meshNode.x = -5;
			
			_view3d.scene3D.addChild(meshNode);
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