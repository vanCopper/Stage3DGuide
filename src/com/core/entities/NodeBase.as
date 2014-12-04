package com.core.entities
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/**
	 * 
	 * @author vancopper
	 * 
	 */	
	public class NodeBase
	{
		private var _nodes:Vector.<NodeBase> = new Vector.<NodeBase>();
		private var _modelMatrix:Matrix3D = new Matrix3D();
		private var _transformComponents:Vector.<Vector3D>;
		private var _pos:Vector3D = new Vector3D();
		private var _rot:Vector3D = new Vector3D();
		private var _sca:Vector3D = new Vector3D();
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _z:Number = 0;
		
		private var _rotationX:int = 0;
		private var _rotationY:int = 0;
		private var _rotationZ:int = 0;
		
		private var _scaleX:int = 1;
		private var _scaleY:int = 1;
		private var _scaleZ:int = 1;
		
		public function NodeBase()
		{
			_transformComponents = new Vector.<Vector3D>(3, true);
			_transformComponents[0] = _pos;
			_transformComponents[1] = _rot;
			_transformComponents[2] = _sca;
		}
		
		public function render():void
		{
			//TODO:
		}
		
		public function addChild(node:NodeBase):void
		{
			//TODO:
			if(_nodes.indexOf(node) == -1)
			{
				_nodes.push(node);
			}
		}
		
		public function removeChild(node:NodeBase):void
		{
			//TODO:
			var index:int = _nodes.indexOf(node);
			_nodes.splice(index, 1);
		}

		public function get modelMatrix():Matrix3D
		{
//			_modelMatrix.identity();
			
			_pos.x = _x;
			_pos.y = _y;
			_pos.z = _z;
			
			_rot.x = _rotationX * ( Math.PI/180 );
			_rot.y = _rotationY * ( Math.PI/180 );
			_rot.z = _rotationZ * ( Math.PI/180 );
			
			_sca.x = _scaleX;
			_sca.y = _scaleY;
			_sca.z = _scaleZ;
			
			_modelMatrix.recompose(_transformComponents);
//			_modelMatrix.appendTranslation(_x, _y, _z);
//			_modelMatrix.appendRotation(_rotationY, Vector3D.Y_AXIS);
			return _modelMatrix;
		}

		public function set modelMatrix(value:Matrix3D):void
		{
			_modelMatrix = value;
		}

		public function get nodes():Vector.<NodeBase>
		{
			return _nodes;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get z():Number
		{
			return _z;
		}

		public function set z(value:Number):void
		{
			_z = value;
		}

		public function get rotationX():int
		{
			return _rotationX;
		}

		public function set rotationX(value:int):void
		{
			_rotationX = value;
		}

		public function get rotationY():int
		{
			return _rotationY;
		}

		public function set rotationY(value:int):void
		{
			_rotationY = value;
		}

		public function get rotationZ():int
		{
			return _rotationZ;
		}

		public function set rotationZ(value:int):void
		{
			_rotationZ = value;
		}

		public function get scaleX():int
		{
			return _scaleX;
		}

		public function set scaleX(value:int):void
		{
			_scaleX = value;
		}

		public function get scaleY():int
		{
			return _scaleY;
		}

		public function set scaleY(value:int):void
		{
			_scaleY = value;
		}

		public function get scaleZ():int
		{
			return _scaleZ;
		}

		public function set scaleZ(value:int):void
		{
			_scaleZ = value;
		}


	}
}