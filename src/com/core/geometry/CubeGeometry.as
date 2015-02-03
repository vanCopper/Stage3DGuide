package com.core.geometry
{
	import com.copper3d;
	
	use namespace copper3d;
	
	/**
	 * Cube 修改自Away3d
	 */
	public class CubeGeometry extends GeometryBase
	{
		private var _width:Number;
		private var _height:Number;
		private var _depth:Number;
		private var _tile6:Boolean;
		
		private var _segmentsW:Number;
		private var _segmentsH:Number;
		private var _segmentsD:Number;
		
		/**
		 * Creates a new Cube object.
		 * @param width The size of the cube along its X-axis.
		 * @param height The size of the cube along its Y-axis.
		 * @param depth The size of the cube along its Z-axis.
		 * @param segmentsW The number of segments that make up the cube along the X-axis.
		 * @param segmentsH The number of segments that make up the cube along the Y-axis.
		 * @param segmentsD The number of segments that make up the cube along the Z-axis.
		 * @param tile6 The type of uv mapping to use. When true, a texture will be subdivided in a 2x3 grid, each used for a single face. When false, the entire image is mapped on each face.
		 */
		public function CubeGeometry(width:Number = 100, height:Number = 100, depth:Number = 100, segmentsW:uint = 1, segmentsH:uint = 1, segmentsD:uint = 1, tile6:Boolean = false)
		{
			super();
			
			_width = width;
			_height = height;
			_depth = depth;
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			_segmentsD = segmentsD;
			_tile6 = tile6;
			build();
		}
		
		/**
		 * The type of uv mapping to use. When false, the entire image is mapped on each face.
		 * When true, a texture will be subdivided in a 3x2 grid, each used for a single face.
		 * Reading the tiles from left to right, top to bottom they represent the faces of the
		 * cube in the following order: bottom, top, back, left, front, right. This creates
		 * several shared edges (between the top, front, left and right faces) which simplifies
		 * texture painting.
		 */
		public function get tile6():Boolean
		{
			return _tile6;
		}
		
		
		/**
		 * @inheritDoc
		 */
		private function build():void
		{
			var vertices:Vector.<Number>;
			var indices:Vector.<uint>;
			
			var tl:uint, tr:uint, bl:uint, br:uint;
			var i:uint, j:uint, inc:uint = 0;
			
			var vidx:uint, fidx:uint; // indices
			var hw:Number, hh:Number, hd:Number; // halves
			var dw:Number, dh:Number, dd:Number; // deltas
			
			var outer_pos:Number;
			
			var numVerts:uint = ((_segmentsW + 1)*(_segmentsH + 1) +
				(_segmentsW + 1)*(_segmentsD + 1) +
				(_segmentsH + 1)*(_segmentsD + 1))*2;
			
			
			vertices = new Vector.<Number>(numVerts*3, true);
			indices = new Vector.<uint>((_segmentsW*_segmentsH + _segmentsW*_segmentsD + _segmentsH*_segmentsD)*12, true);
			
			// half cube dimensions
			hw = _width/2;
			hh = _height/2;
			hd = _depth/2;
			
			// Segment dimensions
			dw = _width/_segmentsW;
			dh = _height/_segmentsH;
			dd = _depth/_segmentsD;
			
			for (i = 0; i <= _segmentsW; i++) {
				outer_pos = -hw + i*dw;
				
				for (j = 0; j <= _segmentsH; j++) {
					// front
					vertices[vidx++] = outer_pos;
					vertices[vidx++] = -hh + j*dh;
					vertices[vidx++] = -hd;
					
					// back
					vertices[vidx++] = outer_pos;
					vertices[vidx++] = -hh + j*dh;
					vertices[vidx++] = hd;
					
					if (i && j) {
						tl = 2*((i - 1)*(_segmentsH + 1) + (j - 1));
						tr = 2*(i*(_segmentsH + 1) + (j - 1));
						bl = tl + 2;
						br = tr + 2;
						
						indices[fidx++] = tl;
						indices[fidx++] = bl;
						indices[fidx++] = br;
						indices[fidx++] = tl;
						indices[fidx++] = br;
						indices[fidx++] = tr;
						indices[fidx++] = tr + 1;
						indices[fidx++] = br + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tr + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tl + 1;
					}
				}
			}
			
			inc += 2*(_segmentsW + 1)*(_segmentsH + 1);
			
			for (i = 0; i <= _segmentsW; i++) {
				outer_pos = -hw + i*dw;
				
				for (j = 0; j <= _segmentsD; j++) {
					// top
					vertices[vidx++] = outer_pos;
					vertices[vidx++] = hh;
					vertices[vidx++] = -hd + j*dd;
					
					// bottom
					vertices[vidx++] = outer_pos;
					vertices[vidx++] = -hh;
					vertices[vidx++] = -hd + j*dd;
					
					if (i && j) {
						tl = inc + 2*((i - 1)*(_segmentsD + 1) + (j - 1));
						tr = inc + 2*(i*(_segmentsD + 1) + (j - 1));
						bl = tl + 2;
						br = tr + 2;
						
						indices[fidx++] = tl;
						indices[fidx++] = bl;
						indices[fidx++] = br;
						indices[fidx++] = tl;
						indices[fidx++] = br;
						indices[fidx++] = tr;
						indices[fidx++] = tr + 1;
						indices[fidx++] = br + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tr + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tl + 1;
					}
				}
			}
			
			inc += 2*(_segmentsW + 1)*(_segmentsD + 1);
			
			for (i = 0; i <= _segmentsD; i++) {
				outer_pos = hd - i*dd;
				
				for (j = 0; j <= _segmentsH; j++) {
					// left
					vertices[vidx++] = -hw;
					vertices[vidx++] = -hh + j*dh;
					vertices[vidx++] = outer_pos;
					
					// right
					vertices[vidx++] = hw;
					vertices[vidx++] = -hh + j*dh;
					vertices[vidx++] = outer_pos;
					
					if (i && j) {
						tl = inc + 2*((i - 1)*(_segmentsH + 1) + (j - 1));
						tr = inc + 2*(i*(_segmentsH + 1) + (j - 1));
						bl = tl + 2;
						br = tr + 2;
						
						indices[fidx++] = tl;
						indices[fidx++] = bl;
						indices[fidx++] = br;
						indices[fidx++] = tl;
						indices[fidx++] = br;
						indices[fidx++] = tr;
						indices[fidx++] = tr + 1;
						indices[fidx++] = br + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tr + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tl + 1;
					}
				}
			}
			
			updateVertexData(vertices);
			updateIndexData(indices);
			buildUVs();
		}
		
		/**
		 * @inheritDoc
		 */
		private function buildUVs():void
		{
			var i:uint, j:uint, uidx:uint;
			var data:Vector.<Number>;
			
			var u_tile_dim:Number, v_tile_dim:Number;
			var u_tile_step:Number, v_tile_step:Number;
			var tl0u:Number, tl0v:Number;
			var tl1u:Number, tl1v:Number;
			var du:Number, dv:Number;
			var numUvs:uint = ((_segmentsW + 1)*(_segmentsH + 1) +
				(_segmentsW + 1)*(_segmentsD + 1) +
				(_segmentsH + 1)*(_segmentsD + 1))*2/**stride*/;
			data = new Vector.<Number>(numUvs*2, true);
			
			if (_tile6) {
				u_tile_dim = u_tile_step = 1/3;
				v_tile_dim = v_tile_step = 1/2;
			} else {
				u_tile_dim = v_tile_dim = 1;
				u_tile_step = v_tile_step = 0;
			}
			
			// Create planes two and two, the same way that they were
			// constructed in the buildGeometry() function. First calculate
			// the top-left UV coordinate for both planes, and then loop
			// over the points, calculating the UVs from these numbers.
			
			// When tile6 is true, the layout is as follows:
			//       .-----.-----.-----. (1,1)
			//       | Bot |  T  | Bak |
			//       |-----+-----+-----|
			//       |  L  |  F  |  R  |
			// (0,0)'-----'-----'-----'
			
			uidx = 0;// target.UVOffset;
			
			// FRONT / BACK
			tl0u = 1*u_tile_step;
			tl0v = 1*v_tile_step;
			tl1u = 2*u_tile_step;
			tl1v = 0*v_tile_step;
			du = u_tile_dim/_segmentsW;
			dv = v_tile_dim/_segmentsH;
			for (i = 0; i <= _segmentsW; i++) {
				for (j = 0; j <= _segmentsH; j++) {
					data[uidx++] = ( tl0u + i*du )/**target.scaleU*/;
					data[uidx++] = ( tl0v + (v_tile_dim - j*dv))/**target.scaleV*/;
					data[uidx++] = ( tl1u + (u_tile_dim - i*du))/**target.scaleU*/;
					data[uidx++] = ( tl1v + (v_tile_dim - j*dv))/**target.scaleV*/;
				}
			}
			
			// TOP / BOTTOM
			tl0u = 1*u_tile_step;
			tl0v = 0*v_tile_step;
			tl1u = 0*u_tile_step;
			tl1v = 0*v_tile_step;
			du = u_tile_dim/_segmentsW;
			dv = v_tile_dim/_segmentsD;
			for (i = 0; i <= _segmentsW; i++) {
				for (j = 0; j <= _segmentsD; j++) {
					data[uidx++] = ( tl0u + i*du)/**target.scaleU*/;
					data[uidx++] = ( tl0v + (v_tile_dim - j*dv))/**target.scaleV*/;
					data[uidx++] = ( tl1u + i*du)/**target.scaleU*/;
					data[uidx++] = ( tl1v + j*dv)/**target.scaleV*/;
				}
			}
			
			// LEFT / RIGHT
			tl0u = 0*u_tile_step;
			tl0v = 1*v_tile_step;
			tl1u = 2*u_tile_step;
			tl1v = 1*v_tile_step;
			du = u_tile_dim/_segmentsD;
			dv = v_tile_dim/_segmentsH;
			for (i = 0; i <= _segmentsD; i++) {
				for (j = 0; j <= _segmentsH; j++) {
					data[uidx++] = ( tl0u + i*du)/**target.scaleU*/;;
					data[uidx++] = ( tl0v + (v_tile_dim - j*dv))/**target.scaleV*/;
					data[uidx++] = ( tl1u + (u_tile_dim - i*du))/**target.scaleU*/;
					data[uidx++] = ( tl1v + (v_tile_dim - j*dv))/**target.scaleV*/;
				}
			}
			updateUVData(data);
		}
	}
}
