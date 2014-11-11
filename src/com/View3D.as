package com
{
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	/**
	 * 
	 * @author vancopper
	 * 
	 */	
	public class View3D extends Sprite
	{
		private var _scene3D:Scene3D;
		private var _camera3D:Camera3D;
		private var _profile:String;
		
		private var _width:Number;
		private var _height:Number;
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _needUpdateBackBuffer:Boolean = true;
		private var _needUpdatePostion:Boolean = true;
		
		
		public function View3D(camera3d:Camera3D = null, scene3d:Scene3D = null, context3DProfile:String = Context3DProfile.STANDARD)
		{
			_camera3D = camera3d || new Camera3D();
			_scene3D = scene3d || new Scene3D();
			
			_profile = context3DProfile;
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			super();
		}
		
		
		private function onAddToStage(e:Event):void
		{
			if(this.hasEventListener(Event.ADDED_TO_STAGE))
				this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			var stage3d:Stage3D = this.stage.stage3Ds[0];
			if(stage3d)
			{
				stage3d.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
				stage3d.addEventListener(ErrorEvent.ERROR, onContext3DCreateError);
				
				stage3d.requestContext3D(Context3DRenderMode.AUTO, _profile);
			}
			
			_width = this.stage.stageWidth;
			_height = this.stage.stageHeight;
		}
		
		private function onContext3DCreateError(event:ErrorEvent):void
		{
			throw new Error(event.text);			
		}
		
		private function onContext3DCreate(event:Event):void
		{
			var stage3d:Stage3D = event.target as Stage3D;
			if(stage3d)
			{
				Stage3DProxy.instance.init(stage3d, _profile);
				if(this.hasEventListener(Event.ENTER_FRAME))
					this.removeEventListener(Event.ENTER_FRAME, onEnter);
				this.addEventListener(Event.ENTER_FRAME, onEnter);
			}
		}	
		
		private function onEnter(e:Event):void
		{
			if(_needUpdateBackBuffer)
			{
				updateBackBuffer();
				_needUpdateBackBuffer = false;
			}
			
			if(_needUpdatePostion)
			{
				Stage3DProxy.instance.stage3d.x = this.x;
				Stage3DProxy.instance.stage3d.y = this.y;
				_needUpdatePostion = false;
			}
			
			render();
		}
		
		private function render():void
		{
			Stage3DProxy.instance.context3d.clear();
			//暂时用scene3d.nodes来代替rootNode 实际上应该是筛选过的一个rendNode列表
			Stage3DProxy.instance.vm = camera3D.lookAtRH();
			Stage3DProxy.instance.pm = camera3D.projectionmatrix;
			Stage3DProxy.instance.render(scene3D);
			Stage3DProxy.instance.context3d.present();
		}
		
		private function updateBackBuffer():void
		{
			//TODO:
			if(camera3D)
			{
				camera3D.updateView(_width, _height);
			}
			Stage3DProxy.instance.context3d.configureBackBuffer(_width, _height, 0);
		}
		
		override public function get width():Number
		{
			return _width
		}
		
		override public function set width(value:Number):void
		{
			if(_width != value)
			{
				_width = value;
				_needUpdateBackBuffer = true;
			}
		}
		
		override public function get x():Number
		{
			return _x;
		}
		
		override public function set x(value:Number):void
		{
			if(_x != value)
			{
				_x = value;
				_needUpdatePostion = true;
			}
		}
		
		override public function get y():Number
		{
			return _y;
		}
		
		override public function set y(value:Number):void
		{
			if(_y != value)
			{
				_y = value;
				_needUpdatePostion = true;
			}
		}	
		
		override public function get z():Number
		{
			return 0;
		}
		
		override public function set z(value:Number):void
		{
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			if(_height != value)
			{
				_height = value;
				_needUpdateBackBuffer = true;
			}
		}
		
		public function get camera3D():Camera3D
		{
			return _camera3D;
		}

		public function set camera3D(value:Camera3D):void
		{
			if(value)
				_camera3D = value;
		}

		public function get scene3D():Scene3D
		{
			return _scene3D;
		}
		
		public function set scene3D(value:Scene3D):void
		{
			if(value)
				_scene3D = value;
		}
		
		
	}
}