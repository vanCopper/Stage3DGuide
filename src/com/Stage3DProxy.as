package com
{
	import com.core.entities.NodeBase;
	
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;

	/**
	 * 
	 * @author vancopper
	 * 
	 */
	public class Stage3DProxy
	{
		private static var _instance:Stage3DProxy;
		
		private var _profile:String;
		private var _stage3d:Stage3D;
		private var _context3d:Context3D;
		
		private var _wm:Matrix3D;
		private var _vm:Matrix3D;
		private var _pm:Matrix3D;
		
		public function Stage3DProxy()
		{
			if(_instance == null)
			{
				_instance = this;
			}else
			{
				throw new Error("实例化单例类出错-Stage3DProxy");
			}
		}
		
		public function init(stage3d:Stage3D, profile:String):void
		{
			//TODO:
			_stage3d = stage3d;
			_context3d = stage3d.context3D;
			_context3d.enableErrorChecking = true;
			_profile = profile;
		}
		
		public function render(rootNode:NodeBase):void
		{
			//TODO:
			if(!rootNode) return;
			var nodes:Vector.<NodeBase> = rootNode.nodes;
			if(!nodes && !nodes.length)return;
			
			for(var i:int = 0; i < nodes.length; i++)
			{
				var node:NodeBase = nodes[i];
				node.render();
			}
		}
		

		public function get profile():String
		{
			return _profile;
		}
		
		public function get stage3d():Stage3D
		{
			return _stage3d;
		}
		
		public function get context3d():Context3D
		{
			return _context3d;
		}
		
		public static function get instance():Stage3DProxy
		{
			if(_instance == null)
			{
				_instance = new Stage3DProxy();	
			}
			return _instance;
		}

		public function get wm():Matrix3D
		{
			return _wm;
		}

		public function set wm(value:Matrix3D):void
		{
			_wm = value;
			updateM();
		}

		public function get vm():Matrix3D
		{
			return _vm;
		}

		public function set vm(value:Matrix3D):void
		{
			_vm = value;
		}

		public function get pm():Matrix3D
		{
			return _pm;
		}

		public function set pm(value:Matrix3D):void
		{
			_pm = value;
		}

		private var _viewM:Matrix3D = new Matrix3D();
		private function updateM():void
		{
			_viewM.identity();
			_viewM.append(_wm);
			_viewM.append(_vm);
			_viewM.append(_pm);
			
			_context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _viewM, true);
		}
	}
}