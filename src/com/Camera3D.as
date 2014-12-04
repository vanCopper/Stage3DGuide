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
		
		private var _transformationMatrix:Matrix3D = new Matrix3D();
		
		/**
		 * 相机位置 
		 */		
		public var camPos:Vector3D = new Vector3D();
		private var _camTarget:Vector3D = new Vector3D();
		
		public var camUp:Vector3D = Vector3D.Y_AXIS;
		public var camRight:Vector3D = Vector3D.X_AXIS;
		public var camForward:Vector3D = Vector3D.Z_AXIS;
		public var viewWidth:Number = 800;
		public var viewHeight:Number = 600;
		public var near:Number = 0.002;
		public var far:Number = 1000;
		
		
		public var projectionMatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D();
		private var _viewMatrix:Matrix3D = new Matrix3D();	
		
		private static var XV:Vector3D = new Vector3D();
		private static var YV:Vector3D = new Vector3D();
		private static var ZV:Vector3D = new Vector3D();
		private static var WV:Vector3D = new Vector3D();
		
		private var _needUpdate:Boolean = true;
		
		public function Camera3D()
		{
			// 45 degrees FOV, 700/500 aspect ratio, 0.1=near, 100=far
			projectionMatrix.perspectiveFieldOfViewRH(Math.PI/4, viewWidth / viewHeight, near, far);
		}
		
		private function update():void
		{
			_transformationMatrix.identity();
			_transformationMatrix.appendRotation(_xDegrees, Vector3D.X_AXIS);
			_transformationMatrix.appendRotation(_yDegrees, Vector3D.Y_AXIS);
			_transformationMatrix.appendRotation(_zDegrees, Vector3D.Z_AXIS);
			
			var camRU:Vector3D = _transformationMatrix.transformVector(Vector3D.Y_AXIS);
			camUp = new Vector3D().add(camRU);
			
			camPos = _transformationMatrix.transformVector(camForward);
			camPos.scaleBy(-distance);
			camPos = camPos.add(camTarget);
		}
		
		private var _xDegrees:Number = 0;
		private var _yDegrees:Number = 0;
		private var _zDegrees:Number = 0;
		public function rotaion(degrees:Number, axis:String):void
		{
			axis = axis.toLowerCase();
			switch(axis)
			{
				case "x":
					_xDegrees += degrees;
					break;
				case "y":
					_yDegrees += degrees;
					break;
				case "z":
					_zDegrees += degrees;
					break;
			}
			_needUpdate = true;
		}
		
		public function updateView(w:Number, h:Number):void
		{
			viewWidth = w;
			viewHeight = h;
			
			projectionMatrix.perspectiveFieldOfViewRH(Math.PI/4, viewWidth/viewHeight, near, far);	
		}
		
		public function get viewMatrix():Matrix3D
		{
			if(_needUpdate)
			{
				update();
				_viewMatrix = lookAtRH();
				_needUpdate = false;
			}
			return _viewMatrix;
		}
		
		private function lookAtRH():Matrix3D
		{
			var vm:Matrix3D = new Matrix3D();
			
			XV = camPos.subtract(camTarget);
			XV.normalize();
			
			ZV.copyFrom(camUp);
			crossProd(ZV, XV);
			ZV.normalize();
			
			YV.copyFrom(XV);
			crossProd(YV, ZV);
			
			var raw:Vector.<Number> = vm.rawData;
			raw[0] = ZV.x;
			raw[1] = YV.x;
			raw[2] = XV.x;
			raw[3] = 0.0;
			
			raw[4] = ZV.y;
			raw[5] = YV.y;
			raw[6] = XV.y;
			raw[7] = 0.0;
			
			raw[8] = ZV.z;
			raw[9] = YV.z;
			raw[10] = XV.z;
			raw[11] = 0.0;
			
			raw[12] = - ZV.dotProduct(camPos);
			raw[13] = -YV.dotProduct(camPos);
			raw[14] = -XV.dotProduct(camPos);
			raw[15] = 1.0;
			
			vm.copyRawDataFrom(raw);
			
			return vm;
		}
		
		private function crossProd(a:Vector3D, b:Vector3D):void
		{
			WV.x = a.y * b.z - a.z * b.y;
			WV.y = a.z * b.x - a.x * b.z;
			WV.z = a.x * b.y - a.y * b.x;
			WV.w = 1.0;
			a.copyFrom(WV);
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

		/**
		 * 相机目标点 
		 */
		public function get camTarget():Vector3D
		{
			return _camTarget;
		}

		/**
		 * @private
		 */
		public function set camTarget(value:Vector3D):void
		{
			_needUpdate = true;
			_camTarget = value;
			
		}

	}
}