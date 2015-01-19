package
{
	import com.Stage3DProxy;
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
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	[SWF(width='800',height='600',backgroundColor='0x333333',frameRate="60")]
	public class Stage3DGuide extends Sprite
	{
		[Embed(source="../assets/bkg.jpg")]
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
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onkeyDown);
			
		}
		
		private function onEnter(e:Event):void
		{
			_view3d.configBackBuffer();
			Stage3DProxy.instance.context3d.clear();
			_view3d.render();
		}
		
		private var _gl:Number = 15;
		private function onkeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.X:
					_view3d.camera3D.rotaion(_gl, "x");
					break;
				case Keyboard.Y:
					_view3d.camera3D.rotaion(_gl, "y");
					break;
				case Keyboard.Z:
					_view3d.camera3D.rotaion(_gl, "z");
					break;
				case Keyboard.W:
					_view3d.camera3D.distance -= 1;
					break;
				case Keyboard.S:
					_view3d.camera3D.distance += 1;
					break;
			}
			
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
			
			var meshNode:MeshNode = new MeshNode(pGeo, mat, new DefaultShader());
//			meshNode.z = 15;
			
			_view3d.scene3D.addChild(meshNode);
			this.stage.addEventListener(Event.ENTER_FRAME, onEnter);
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