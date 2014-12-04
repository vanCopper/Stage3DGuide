package com.core.geometry
{
	import com.Stage3DProxy;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	/**
	 * 
	 * @author vancopper
	 * 
	 */
	public class GeometryBase
	{
		private var _preContext3D:Context3D;
		private var _indexBuffer:IndexBuffer3D;
		private var _vertexBuffer:VertexBuffer3D;
		
		private var _vertexes:Vector.<Number>;
		private var _indexes:Vector.<uint>;
		private var _uvs:Vector.<Number>;
		private var _normals:Vector.<Number>;
		/**
		 * 0-2 顶点 x, y, z
		 * 3-4 UV u, v
		 * 5-7 法线 x, y, z
		 */		
		private var _raws:Vector.<Number> = new Vector.<Number>();
		private var _needUpdateRaw:Boolean = true;
		
		public function GeometryBase()
		{
		}
		
		public function updateVertexData(vertexes:Vector.<Number>):void
		{
			//TODO:
			_vertexes = vertexes.concat();
			_needUpdateRaw = true;
		}
		
		public function updateIndexData(indexes:Vector.<uint>):void
		{
			//TODO:
			_indexes = indexes;			
		}
		
		public function updateUVData(uvs:Vector.<Number>):void
		{
			//TODO:
			_uvs = uvs;
			_needUpdateRaw = true;
		}
		
		public function updateNormalData(normals:Vector.<Number>):void
		{
			//TODO:
			_normals = normals;	
			_needUpdateRaw = true;
		}
		
		public function active():void
		{
			//TODO:
			
			if(_needUpdateRaw)
			{
				updateRaw();
				_needUpdateRaw = false;
			}
			
			if(!_vertexBuffer || _preContext3D != Stage3DProxy.instance.context3d)
			{
				_vertexBuffer = Stage3DProxy.instance.context3d.createVertexBuffer(_raws.length / 8, 8);
				
				_vertexBuffer.uploadFromVector(_raws, 0, _raws.length / 8);
				//va0 顶点
				Stage3DProxy.instance.context3d.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				//va1 uv
				Stage3DProxy.instance.context3d.setVertexBufferAt(1, _vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
				//va2 法线
				Stage3DProxy.instance.context3d.setVertexBufferAt(2, _vertexBuffer, 5, Context3DVertexBufferFormat.FLOAT_3);
			}
			
			if(!_indexBuffer || _preContext3D != Stage3DProxy.instance.context3d)
			{
				_indexBuffer = Stage3DProxy.instance.context3d.createIndexBuffer(_indexes.length);
				_indexBuffer.uploadFromVector(_indexes, 0, _indexes.length);
			}
			
			_preContext3D = Stage3DProxy.instance.context3d;
		}
		
		public function deactive():void
		{
			//va0 顶点
			Stage3DProxy.instance.context3d.setVertexBufferAt(0, null);
			//va1 uv
			Stage3DProxy.instance.context3d.setVertexBufferAt(1, null);
			//va2 法线
			Stage3DProxy.instance.context3d.setVertexBufferAt(2, null);
		}
		
		public function get indexBuffer():IndexBuffer3D
		{
			return _indexBuffer;
		}
		
		public function get rawData():Vector.<Number>
		{
			updateRaw();
			return _raws;
		}
		
		public function get triangleNum():uint
		{
			return _indexes.length / 3;
		}
		
		public function dispose():void
		{
			//TODO:
		}
		
		private function updateRaw():void
		{
			if(!_vertexes || _vertexes.length == 0)
			{
				throw new Error("Bad Geometry Data");
			}
			
			var len:uint = _vertexes.length / 3;
			for(var i:int = 0; i < len; i++)
			{
				//vertex
				_raws[i*8] = _vertexes[i*3];
				_raws[i*8 + 1] = _vertexes[i*3 + 1];
				_raws[i*8 + 2] = _vertexes[i*3 + 2];
				//uv
				_raws[i*8 + 3] = _uvs[i*2] ? _uvs[i*2] : 0 ;
				_raws[i*8 + 4] = _uvs[i*2 + 1] ? _uvs[i*2 + 1] : 0;
				//normal
				_raws[i*8 + 5] = _normals ? _normals[i*3] : 0;
				_raws[i*8 + 6] = _normals ? _normals[i*3 + 1] : 0;
				_raws[i*8 + 7] = _normals ? _normals[i*3 + 2] : 0;
			}
		}
	}
}