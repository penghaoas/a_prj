package com.miro.rt.data
{
	import Box2D.Common.Math.b2Vec2;

	public class Config
	{
		public static const G:Number = 3;
		public static const CHASE_MIN_V:int = 3;
		public static const HEOR_START_X:int = 20;
		public static const CHASE_GAP:int = 10;
		public static const HERO_MAX_V:int = 20;
		public static const HERO_MIN_V:int = 2;
		public static const HERO_DEVICE_V:b2Vec2 = new b2Vec2(1, 5);
		public static const BACK0_MOVE_RATE:Number = 0.1;
		public static const BACK1_MOVE_RATE:Number = 0.3;
		public static const HERO_MIN_GAP:int = 100;
		public static const DEPTH_MAX:int = 100;
		public static const RAINBOW_OFF_Y:Number = 2/ 3;
	}
}