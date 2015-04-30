package
{
	import com.Stage3DProxy;
	import com.View3D;
	import com.core.entities.MeshNode;
	import com.core.geometry.SphereGeometry;
	import com.core.materials.TextureMaterial;
	import com.debug.Stats;
	import com.effects.postprocessing.ColorEffect;
	import com.effects.postprocessing.GrayscaleEffect;
	import com.effects.postprocessing.WaveEffect;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	[SWF(width='600',height='450',backgroundColor='0x333333',frameRate="60")]
	
	public class PostEffectTest extends Sprite
	{
		[Embed(source="../assets/earth.jpg")]
		private static var TextureClass:Class;
		
		private var _view3d:View3D;
		private var _mesh:MeshNode;
		private var _colorEffect:ColorEffect = new ColorEffect();
		private var _grayscaleEffect:GrayscaleEffect = new GrayscaleEffect(); 
		private var _waveEffect:WaveEffect = new WaveEffect();
		private var _info:TextField;
		
		public function PostEffectTest()
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStage);
		}
		
		private function addToStage(e:Event):void
		{
			init();
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.addEventListener(Event.RESIZE, onResize);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.NUMBER_1:
					_view3d.postEffect = null;
					_info.text = "Normal";
					break;
				case Keyboard.NUMBER_2:
					_view3d.postEffect = _colorEffect
					_info.text = "ColorEffect";
					break;
				case Keyboard.NUMBER_3:
					_view3d.postEffect = _grayscaleEffect;
					_info.text = "GrayscaleEffect";
					break;
				case Keyboard.NUMBER_4:
					_view3d.postEffect = _waveEffect;
					_info.text = "WaveEffect";
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
			initInfo();
		}
		
		private function initInfo():void
		{
			_info = new TextField();
			_info.textColor = 0xFF0000;
			_info.x = 80;
			this.stage.addChild(_info);
		}
		
		private function initObject():void
		{
			var loop:uint = 1;
			var mat:TextureMaterial = new TextureMaterial();
			mat.bitmapData = (new TextureClass() as Bitmap).bitmapData;
			var sphereGeo:SphereGeometry = new SphereGeometry(6);
			_mesh = new MeshNode(sphereGeo, mat);
			_view3d.scene3D.addChild(_mesh);
			this.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
//			_view3d.camera3D.rotaion(1, "Y");
//			_mesh.rotationY += 1;
			_view3d.configBackBuffer();
			Stage3DProxy.instance.context3d.clear(/*255, 255, 255*/);
			_view3d.render();
//			_view3d
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