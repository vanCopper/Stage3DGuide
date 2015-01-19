package
{
	import com.Stage3DProxy;
	import com.View3D;
	import com.core.entities.MeshNode;
	import com.core.geometry.PlaneGeometry;
	import com.core.materials.DefaultMaterial;
	import com.core.materials.ColorMaterial;
	import com.core.shaders.DefaultShader;
	import com.debug.Stats;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width='600',height='450',backgroundColor='0x333333',frameRate="60")]
	
	public class SimpleParticleTest extends Sprite
	{
		private var _view3d:View3D;
		
		public function SimpleParticleTest()
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
			var loop:uint = 100;
			while(loop--)
			{
				var meshNode:MeshNode = new MeshNode(new PlaneGeometry(1, 1), new ColorMaterial(), new DefaultShader());
				meshNode.x = 10 * (Math.random() - Math.random());
				meshNode.y = 10 * (Math.random() - Math.random());
				meshNode.z = Math.random() * 10;
				_view3d.scene3D.addChild(meshNode);
			}
			this.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			_view3d.configBackBuffer();
			Stage3DProxy.instance.context3d.clear();
			_view3d.render();
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