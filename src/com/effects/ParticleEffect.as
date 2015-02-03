package com.effects
{
	import com.copper3d;
	import com.core.utils.BoundBox;
	
	import flash.geom.Vector3D;

	use namespace copper3d
	/**
	 * 
	 * @author vancopper
	 * 
	 */	
	public class ParticleEffect
	{
		public var name:String;
		
		public var scale:Number = 1;
		
		public var boundBox:BoundBox;
		
		/**
		 * @private
		 */
		copper3d var next:ParticleEffect;
		/**
		 * @private
		 */
		copper3d var nextInSystem:ParticleEffect;
		/**
		 * @private
		 */
		copper3d var system:ParticleSystem;
		/**
		 * @private
		 */
		copper3d var startTime:Number;
		/**
		 * @private
		 */
		copper3d var lifeTime:Number = Number.MAX_VALUE;
		/**
		 * @private
		 */
		copper3d var particleList:Particle;
		/**
		 * @private
		 */
		copper3d var aabb:BoundBox = new BoundBox();
		/**
		 * @private
		 */
		copper3d var keyPosition:Vector3D;
		
		protected var keyDirection:Vector3D;
		
		protected var timeKeys:Vector.<Number> = new Vector.<Number>();
		protected var positionKeys:Vector.<Vector3D> = new Vector.<Vector3D>();
		protected var directionKeys:Vector.<Vector3D> = new Vector.<Vector3D>();
		protected var scriptKeys:Vector.<Function> = new Vector.<Function>();
		protected var keysCount:int = 0;
		
		private static var randomNumbers:Vector.<Number>;
		private static const randomNumbersCount:int = 1000;
		
		private static const vector:Vector3D = new Vector3D();
		
		private var randomOffset:int;
		private var randomCounter:int;
		
		private var _position:Vector3D = new Vector3D(0, 0, 0);
		private var _direction:Vector3D = new Vector3D(0, 0, 1);
		public function ParticleEffect()
		{
			if (randomNumbers == null) 
			{
				randomNumbers = new Vector.<Number>();
				for (var i:int = 0; i < randomNumbersCount; i++) randomNumbers[i] = Math.random();
			}
			randomOffset = Math.random()*randomNumbersCount;
		}
		
		public function get position():Vector3D {
			return _position.clone();
		}
		
		public function set position(value:Vector3D):void {
			_position.x = value.x;
			_position.y = value.y;
			_position.z = value.z;
			_position.w = value.w;
			if (system != null) setPositionKeys(system.getTime() - startTime);
		}
		
		public function get direction():Vector3D {
			return _direction.clone();
		}
		
		public function set direction(value:Vector3D):void {
			_direction.x = value.x;
			_direction.y = value.y;
			_direction.z = value.z;
			_direction.w = value.w;
			if (system != null) setDirectionKeys(system.getTime() - startTime);
		}
		
		public function stop():void {
			var time:Number = system.getTime() - startTime;
			for (var i:int = 0; i < keysCount; i++) {
				if (time < timeKeys[i]) break;
			}
			keysCount = i;
		}
		
		protected function get particleSystem():ParticleSystem {
			return system;
		}
		/*
		protected function get cameraTransform():Transform3D {
			return system.cameraToLocalTransform;
		}*/
		
		protected function random():Number {
			var res:Number = randomNumbers[randomCounter]; randomCounter++;
			if (randomCounter == randomNumbersCount) randomCounter = 0;
			return res;
		}
		
		protected function addKey(time:Number, script:Function):void {
			timeKeys[keysCount] = time;
			positionKeys[keysCount] = new Vector3D();
			directionKeys[keysCount] = new Vector3D();
			scriptKeys[keysCount] = script;
			keysCount++;
		}
		
		protected function setLife(time:Number):void {
			lifeTime = time;
		}
		
		/**
		 * @private
		 */
		copper3d function calculateAABB():void {
			aabb.minX = boundBox.minX*scale + _position.x;
			aabb.minY = boundBox.minY*scale + _position.y;
			aabb.minZ = boundBox.minZ*scale + _position.z;
			aabb.maxX = boundBox.maxX*scale + _position.x;
			aabb.maxY = boundBox.maxY*scale + _position.y;
			aabb.maxZ = boundBox.maxZ*scale + _position.z;
		}
		
		/**
		 * @private
		 */
		copper3d function setPositionKeys(time:Number):void {
			for (var i:int = 0; i < keysCount; i++) {
				if (time <= timeKeys[i]) {
					var pos:Vector3D = positionKeys[i];
					pos.x = _position.x;
					pos.y = _position.y;
					pos.z = _position.z;
				}
			}
		}
		
		/**
		 * @private
		 */
		copper3d function setDirectionKeys(time:Number):void {
			vector.x = _direction.x;
			vector.y = _direction.y;
			vector.z = _direction.z;
			vector.normalize();
			for (var i:int = 0; i < keysCount; i++) {
				if (time <= timeKeys[i]) {
					var dir:Vector3D = directionKeys[i];
					dir.x = vector.x;
					dir.y = vector.y;
					dir.z = vector.z;
				}
			}
		}
		
		/**
		 * @private
		 */
		copper3d function calculate(time:Number):Boolean {
			randomCounter = randomOffset;
			for (var i:int = 0; i < keysCount; i++) {
				var keyTime:Number = timeKeys[i];
				if (time >= keyTime) {
					keyPosition = positionKeys[i];
					keyDirection = directionKeys[i];
					var script:Function = scriptKeys[i];
					script.call(this, keyTime, time - keyTime);
				} else break;
			}
			return i < keysCount || particleList != null;
		}
	}
}