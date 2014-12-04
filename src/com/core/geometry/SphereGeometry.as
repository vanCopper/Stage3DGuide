package com.core.geometry
{
	/**
	 * 球体 form away3d SphereGeometry.as 
	 * @author vancopper
	 * 
	 */	
	public class SphereGeometry extends GeometryBase
	{
		private var _radius:Number;
		private var _segmentsW:uint;
		private var _segmentsH:uint;
		
//		private var _vertexStride:uint = 13;
//		private var _uvStride:uint = 13;
		
		public function SphereGeometry(radius:Number = 50, segmentsW:uint = 16, segmentsH:uint = 12)
		{
			super();
			
			_radius = radius;
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			build();
		}
		
		private function build():void
		{
			buildGeometry();
			buildUVs();
		}
		
		/**
		 * Updates the vertex data. All vertex properties are contained in a single Vector, and the order is as follows:
		 * 0 - 2: vertex position X, Y, Z
		 * 3 - 5: normal X, Y, Z
		 * 6 - 8: tangent X, Y, Z
		 * 9 - 10: U V
		 * 11 - 12: Secondary U V
		 */
		
		private function buildGeometry():void
		{
			var vertices:Vector.<Number>;
			var normals:Vector.<Number>;
			var indices:Vector.<uint>;
			var i:uint, j:uint, triIndex:uint;
			var numVerts:uint = (_segmentsH + 1)*(_segmentsW + 1);
			
			vertices = new Vector.<Number>(numVerts*3, true);
			normals = new Vector.<Number>(numVerts*3, true);
			indices = new Vector.<uint>((_segmentsH - 1)*_segmentsW*6, true);
			
			var startIndex:uint;
			var index:uint = 0;
			var normalIndex:uint = 0;
			
			var comp1:Number, comp2:Number/*, t1:Number, t2:Number*/;
			
			for (j = 0; j <= _segmentsH; ++j) {
				
				startIndex = index;
				
				var horangle:Number = Math.PI*j/_segmentsH;
				var z:Number = -_radius*Math.cos(horangle);
				var ringradius:Number = _radius*Math.sin(horangle);
				
				for (i = 0; i <= _segmentsW; ++i) {
					var verangle:Number = 2*Math.PI*i/_segmentsW;
					var x:Number = ringradius*Math.cos(verangle);
					var y:Number = ringradius*Math.sin(verangle);
					var normLen:Number = 1/Math.sqrt(x*x + y*y + z*z);
					var tanLen:Number = Math.sqrt(y*y + x*x);
					
//					t1 = tanLen > .007? x/tanLen : 0;
//					t2 = 0;
					comp1 = y;
					comp2 = z;
					
					if (i == _segmentsW) {
						vertices[index++] = vertices[startIndex];
						vertices[index++] = vertices[startIndex + 1];
						vertices[index++] = vertices[startIndex + 2];
						normals[normalIndex++] = vertices[startIndex + 3] + (x*normLen)*.5;
						normals[normalIndex++] = vertices[startIndex + 4] + ( comp1*normLen)*.5;
						normals[normalIndex++] = vertices[startIndex + 5] + (comp2*normLen)*.5;
//						vertices[index++] = tanLen > .007? -y/tanLen : 1;
//						vertices[index++] = t1;
//						vertices[index++] = t2;
						
					} else {
						vertices[index++] = x;
						vertices[index++] = comp1;
						vertices[index++] = comp2;
						normals[normalIndex++] = x*normLen;
						normals[normalIndex++] = comp1*normLen;
						normals[normalIndex++] = comp2*normLen;
//						vertices[index++] = tanLen > .007? -y/tanLen : 1;
//						vertices[index++] = t1;
//						vertices[index++] = t2;
					}
					
					if (i > 0 && j > 0) {
						var a:int = (_segmentsW + 1)*j + i;
						var b:int = (_segmentsW + 1)*j + i - 1;
						var c:int = (_segmentsW + 1)*(j - 1) + i - 1;
						var d:int = (_segmentsW + 1)*(j - 1) + i;
						
						if (j == _segmentsH) {
							vertices[index - 9] = vertices[startIndex];
							vertices[index - 8] = vertices[startIndex + 1];
							vertices[index - 7] = vertices[startIndex + 2];
							
							indices[triIndex++] = a;
							indices[triIndex++] = c;
							indices[triIndex++] = d;
							
						} else if (j == 1) {
							indices[triIndex++] = a;
							indices[triIndex++] = b;
							indices[triIndex++] = c;
							
						} else {
							indices[triIndex++] = a;
							indices[triIndex++] = b;
							indices[triIndex++] = c;
							indices[triIndex++] = a;
							indices[triIndex++] = c;
							indices[triIndex++] = d;
						}
					}
				}
			}
			
			updateVertexData(vertices);
			updateNormalData(normals);
			updateIndexData(indices);
		}
		
		private function buildUVs():void
		{
			var i:int, j:int;
			var numUvs:uint = (_segmentsH + 1)*(_segmentsW + 1);
			var data:Vector.<Number>;
			data = new Vector.<Number>(numUvs*2, true);
				
			var index:int = 0;
			for (j = 0; j <= _segmentsH; ++j) {
				for (i = 0; i <= _segmentsW; ++i) {
					data[index++] = ( i/_segmentsW )/**target.scaleU*/;
					data[index++] = ( j/_segmentsH )/**target.scaleV*/;
//					index += 1;
				}
			}
			updateUVData(data);
		}
	
	}
}