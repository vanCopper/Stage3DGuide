package com
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	

	/**
	 * Camera3D
	 * @author vancopper
	 * 
	 */	
	public class Camera3D
	{
		private var _distance:Number = 20;
		public var minDistance:Number = 6;
		public var maxDistance:Number = 25;
		
		private var _pitchAngle:Number = 45;
		
		public var eyePos:Vector3D = new Vector3D();
		public var camTarget:Vector3D = new Vector3D();
		public var camUp:Vector3D = Vector3D.Z_AXIS;
		public var camRight:Vector3D = Vector3D.X_AXIS;
		public var camForward:Vector3D = Vector3D.Y_AXIS;
		public var projectionmatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D()
		
		private static var _x:Vector3D = new Vector3D();
		private static var _y:Vector3D = new Vector3D();
		private static var _z:Vector3D = new Vector3D();
		private static var _w:Vector3D = new Vector3D();
		
		private var _needUpdate:Boolean = true;
		
		public function Camera3D()
		{
			// 45 degrees FOV, 700/500 aspect ratio, 0.1=near, 100=far
			projectionmatrix.perspectiveFieldOfViewRH(Math.PI/4, 800 / 600, 0.01, 100.0);
		}
		
		private function update():void
		{
			var matrix:Matrix3D = new Matrix3D();
			matrix.appendRotation(-pitchAngle, camRight);
			matrix.appendRotation(pitchAngle, camUp);
			
			eyePos = matrix.transformVector(camForward);
			eyePos.scaleBy(-distance);
			eyePos = eyePos.add(camTarget);
		}
		
		public function updateView(viewWidth:Number, viewHeight:Number):void
		{
			projectionmatrix.perspectiveFieldOfViewRH(45.0, viewWidth/viewHeight, 0.01, 100);	
		}
		
		public function lookAtRH():Matrix3D
		{
			if(_needUpdate)
			{
				update();
				_needUpdate = false;
			}
			
			var vm:Matrix3D = new Matrix3D();
			
			_x = eyePos.subtract(camTarget);
			_x.normalize();
			
			_z.copyFrom(camUp);
			crossProd(_z, _x);
			_z.normalize();
			
			_y.copyFrom(_x);
			crossProd(_y, _z);
			
			var raw:Vector.<Number> = vm.rawData;
			raw[0] = _z.x;
			raw[1] = _y.x;
			raw[2] = _x.x;
			raw[3] = 0.0;
			
			raw[4] = _z.y;
			raw[5] = _y.y;
			raw[6] = _x.y;
			raw[7] = 0.0;
			
			raw[8] = _z.z;
			raw[9] = _y.z;
			raw[10] = _x.z;
			raw[11] = 0.0;
			
			raw[12] = - _z.dotProduct(eyePos);
			raw[13] = -_y.dotProduct(eyePos);
			raw[14] = -_x.dotProduct(eyePos);
			raw[15] = 1.0;
			
			vm.copyRawDataFrom(raw);
			
			
			return vm;
		}
		
		private function crossProd(a:Vector3D, b:Vector3D):void
		{
			_w.x = a.y * b.z - a.z * b.y;
			_w.y = a.z * b.x - a.x * b.z;
			_w.z = a.x * b.y - a.y * b.x;
			_w.w = 1.0;
			a.copyFrom(_w);
		}

		public function get distance():Number
		{
			return _distance;
		}

		public function set distance(value:Number):void
		{
			_distance = value;
			_needUpdate = true;
		}

		public function get pitchAngle():Number
		{
			return _pitchAngle;
		}

		public function set pitchAngle(value:Number):void
		{
			_pitchAngle = value;
			_needUpdate = true;
		}

		
	}
}