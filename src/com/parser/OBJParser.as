package com.parser
{
	import flash.utils.ByteArray;
	
	/**
	 * OBJ文件解析器
	 * @author vanCopper
	 */
	public class OBJParser
	{
		private var _lines:Array;
		private const LINE_FEED:String = String.fromCharCode(10);
		private const SPACE:String = String.fromCharCode(32);
		private var _scale:Number;
		public function OBJParser(objfile:ByteArray,scale:Number = 1)
		{
			_scale = scale;
			if(objfile)
			{
				var lineStr:String = parserToStr(objfile);
				_lines = lineStr.split(LINE_FEED);
				var loop:uint = _lines.length;
				for(var i:uint = 0; i < loop; i++)
				{
					parseLine(_lines[i]);
				}
			}	
		}
		
		private const VERTEX:String = 'v';
		private const UV:String = 'vt';
		private const INDEX_DATA:String = 'f';
		private const NORMAL:String = 'vn';
		private function parseLine(lineStr:String):void
		{
			var data:Array = lineStr.split(SPACE);
			if(!data.length)return;
			var key:String = data[0];
			var parseData:Array = data.slice(1);
			switch(key)
			{
				case VERTEX:
					parseVertex(parseData);
					break;
				case UV:
					parseUV(parseData);
					break;
				case INDEX_DATA:
					parseIndexData(parseData);
					break;
				case NORMAL:
					parseNormalData(parseData);
					break;
			}
		}
		
		private var _vertices:Vector.<Number> = new Vector.<Number>();
		private function parseVertex(data:Array):void
		{
			if(data[0] == '' || data[0] == " ")
			{
				data = data.slice(1);
			}
			var loop:uint = data.length;
			for(var i:uint = 0; i < loop; i++)
			{
				var value:Number = Number(data[i]);
				_vertices.push(value*_scale);
			}
		}
		
		private var _uvs:Vector.<Number> = new Vector.<Number>();
		private function parseUV(data:Array):void
		{
			if(data[0] == '' || data[0] == " ")
			{
				data = data.slice(1);
			}
//			var loop:uint = 2;
//			for(var i:uint = 0; i < loop; i++)
//			{
//				var value:Number = Number(data[i]);
//				_uvs.push(value*_scale);
//			}
			_uvs.push(data[0], data[1]);
			
		}
		
//		private function parseUV(trunk:Array):void
//		{
//			if (trunk.length > 3) {
//				var nTrunk:Array = [];
//				var val:Number;
//				for (var i:uint = 1; i < trunk.length; ++i) {
//					val = parseFloat(trunk[i]);
//					if (!isNaN(val))
//						nTrunk.push(val);
//				}
//				_uvs.push(nTrunk[0], 1 - nTrunk[1]);
//				
//			} else
//				_uvs.push(parseFloat(trunk[1]),1 - parseFloat(trunk[2]));
//			trace();
//		}
		
		private var _normals:Vector.<Number> = new Vector.<Number>();
		private function parseNormalData(data:Array):void
		{
			if (data.length > 4) {
				var nTrunk:Array = [];
				var val:Number;
				for (var i:uint = 1; i < data.length; ++i) {
					val = parseFloat(data[i]);
					if (!isNaN(val))
						nTrunk.push(val);
				}
				_normals.push(nTrunk[0], nTrunk[1], -nTrunk[2]);
				
			} else
				_normals.push(parseFloat(data[0]), parseFloat(data[0]), -parseFloat(data[0]));
			
		}
		
		
		private const SLASH:String = "/";
		private var _indexData:Vector.<uint> = new Vector.<uint>();
		private var _vertexsData:Vector.<Number> = new Vector.<Number>();
		private var _uvData:Vector.<Number> = new Vector.<Number>();
		private var _faceIndex:uint;
		private function parseIndexData(data:Array):void
		{
			var index:uint = 0;
			while((data[index] == '') || (data[index] == ' '))index++;
			var loop:uint = index+3;
			
			var vertexIndex:int;
			var uvIndex:int;
			var normalIndex:int;
			for(var i:uint = index; i < loop; i++)
			{
				var triplet:String = data[i];
				var subdata:Array = triplet.split(SLASH);
				vertexIndex = int(subdata[0]) - 1;
				uvIndex     = int(subdata[1]) - 1;
				
				
				if(vertexIndex < 0) vertexIndex = 0;
				if(uvIndex < 0) uvIndex = 0;
				
				index = 3*vertexIndex;
				_vertexsData.push(_vertices[index + 0], 
				_vertices[index + 1], _vertices[index + 2]);
				
				index = 2*uvIndex;
				_uvData.push(1-_uvs[index+0],1-_uvs[index+1]);
			}
			_indexData.push(_faceIndex+0,_faceIndex+1,_faceIndex+2);
			_faceIndex += 3;
		}
		
		private function parserToStr(objFileByteArray:ByteArray):String
		{
			return objFileByteArray.readUTFBytes(objFileByteArray.bytesAvailable);
		}

		/**
		 * 顶点数据 
		 * @return 
		 * 
		 */		
		public function get vertexsData():Vector.<Number>
		{
			return _vertexsData;
		}

		/**
		 * UV数据 
		 * @return 
		 * 
		 */		
		public function get uvData():Vector.<Number>
		{
			return _uvData;
		}

		/**
		 * 索引数据 
		 * @return 
		 * 
		 */		
		public function get indexData():Vector.<uint>
		{
			return _indexData;
		}

		/**
		 * 法线数据 
		 * @return 
		 * 
		 */		
		public function get normalData():Vector.<Number>
		{
			return _normals;
		}

	}
}