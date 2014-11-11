package com.core.entities
{
	import flash.geom.Matrix3D;

	/**
	 * 
	 * @author vancopper
	 * 
	 */	
	public class NodeBase
	{
		private var _nodes:Vector.<NodeBase> = new Vector.<NodeBase>();
		private var _modelMatrix:Matrix3D = new Matrix3D();
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _z:Number = 0;
		public function NodeBase()
		{
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
			_modelMatrix.identity();
			_modelMatrix.appendTranslation(_x, _y, _z);
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


	}
}