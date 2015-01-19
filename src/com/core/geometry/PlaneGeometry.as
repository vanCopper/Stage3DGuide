package com.core.geometry
{
	
	/**
	 * 
	 * @author vancopper
	 * 
	 */
	public class PlaneGeometry extends GeometryBase
	{
		private var _width:Number;
		private var _height:Number;
		
		public function PlaneGeometry(width:Number = 100, height:Number = 100)
		{
			_width = width;
			_height = height;
			build();
			super();
		}
		
		private function build():void
		{
			var vertexes:Vector.<Number> = new Vector.<Number>();
			
			vertexes[0] = _width/2;
			vertexes[1] = _height/2;
			vertexes[2] = 0;
			
			vertexes[3] = _width/2;
			vertexes[4] = -_height/2;
			vertexes[5] = 0;
			
			vertexes[6] = -_width/2;
			vertexes[7] = -_height/2;
			vertexes[8] = 0;
			
			vertexes[9] = _width/2;
			vertexes[10] = _height/2;
			vertexes[11] = 0;
			
			vertexes[12] = -_width/2;
			vertexes[13] = -_height/2;
			vertexes[14] = 0;
			
			vertexes[15] = -_width/2;
			vertexes[16] = _height/2;
			vertexes[17] = 0;
			
			updateVertexData(vertexes);
			
			var uvs:Vector.<Number> = new Vector.<Number>();
			uvs[0] = 1;
			uvs[1] = 0;
			
			uvs[2] = 1;
			uvs[3] = 1;
			
			uvs[4] = 0;
			uvs[5] = 1;
			
			uvs[6] = 1;
			uvs[7] = 0;
			
			uvs[8] = 0; 
			uvs[9] = 1;
			
			uvs[10] = 0;
			uvs[11] = 0;
			
			updateUVData(uvs);
			
			var indexes:Vector.<uint> = new Vector.<uint>();
			indexes[0] = 0;
			indexes[1] = 1;
			indexes[2] = 2;
			indexes[3] = 3;
			indexes[4] = 4;
			indexes[5] = 5;
			updateIndexData(indexes);
		}
	}
}