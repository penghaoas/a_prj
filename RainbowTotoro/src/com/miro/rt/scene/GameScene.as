package com.miro.rt.scene
{
	import com.miro.rt.core.GameManager;
	import com.miro.rt.core.PatternManager;
	import com.miro.rt.core.TouchInput;
	import com.miro.rt.data.Config;
	import com.miro.rt.obj.Backgroud;
	import com.miro.rt.obj.Rainbow;
	import com.miro.rt.obj.RainbowDrawer;
	import com.miro.rt.obj.Totoro;
	import com.miro.rt.obj.TotoroState;
	import com.miro.rt.res.ResAssets;
	import com.miro.rt.ui.HUD;
	import com.miro.rt.ui.Sounds;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import Box2D.Common.Math.b2Vec2;
	
	import citrus.core.starling.StarlingState;
	import citrus.physics.box2d.Box2D;

	public class GameScene extends StarlingState implements IScene
	{
		private var _totoro:Totoro;
		private var _rainbow:Rainbow;
		private var _back:Backgroud;
		private var _rainbowDrawer:RainbowDrawer;
		private var _box2D:Box2D;
		private var _isStart:Boolean;
		private var _touchInput:TouchInput;
		private var _hud:HUD;
		
		
		
		public function GameScene()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();

			_box2D = new Box2D("box2d");
			_box2D.gravity = new b2Vec2(0, Config.G);
			add(_box2D);
			
			_touchInput = new TouchInput();
			_touchInput.initialize();
			
			var totoroView:* = null;
			
//			_box2D.visible = true;
			_back = new Backgroud();
			totoroView = ResAssets.getAtlas().getTexture("totoro");
			_rainbowDrawer = new RainbowDrawer();
			
			_totoro = new Totoro("hero", {offsetX:34, offsetY: -32, radius:2, hurtVelocityX:5, hurtVelocityY:8, group:Config.DEPTH_MAX, view: totoroView});
			_totoro.x = Config.HEOR_START_X * _box2D.scale;
			_totoro.y = -10 * _box2D.scale;
			add(_totoro);
			
			_rainbow = new Rainbow("hills",{rider:_totoro, sliceWidth:30, roundFactor:15, group:Config.DEPTH_MAX, sliceHeight:800, widthHills:stage.stageWidth, registration:"topLeft", view:_rainbowDrawer});
			add(_rainbow);
			
			_hud = new HUD();
			addChild(_hud);
			
			camera.allowZoom = true;
			camera.setUp(_totoro,new Rectangle(0, -_ce.screenHeight * Config.RAINBOW_OFF_Y, _ce.screenWidth * 50000, _ce.screenHeight), new Point(0.2, 0.8));
			
			// Play screen background music.
			if (!Sounds.muted) Sounds.sndBgGame.play(0, 999);
		}
//		private var _debugSprite:Sprite;
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
//			if(!_debugSprite)
//			{
//				_debugSprite = new Sprite();
//				_debugSprite.scaleX = 0.1 * 0.6;
//				_debugSprite.scaleY = 0.1 * 0.6;
//				_debugSprite.x = 0;
//				_debugSprite.y = 100;
//				GameManager.instance.engine.addChild(_debugSprite);
//			}
//			camera.renderDebug(_debugSprite);
			
			if(_rainbowDrawer) 
			{
				_rainbowDrawer.update();
			}
			
			if(_isStart)
			{
				PatternManager.instance.update();
				
				// Set the background's x based on hero's x.
				if(_back)
				{
					_back.update(_totoro.x);
				}
				_totoro.state = _touchInput.screenTouched ? TotoroState.ADD_V : TotoroState.FLY;
				
				//游戏状态
				GameManager.instance.gameData.distance = Math.round(_totoro.x / _box2D.scale);
				if(_hud)
				{
					_hud.distance = GameManager.instance.gameData.distance;
					_hud.foodScore = GameManager.instance.gameData.score;
				}
			}
			else
			{
				if(_touchInput.screenTouched)
				{
					_isStart = true;
					PatternManager.instance.initialize();
				}
			}
		}
		
		override public function destroy():void
		{
			_totoro.destroy();
			_rainbow.destroy();
			_back.destroy();
			_rainbowDrawer.destroy();
			_box2D.destroy();
			_touchInput.destroy();
			_rainbowDrawer.destroy();
			_hud.dispose();
			
			_totoro = null;
			_rainbow = null;
			_back = null;
			_rainbowDrawer = null;
			_box2D = null;
			_touchInput = null;
			_rainbowDrawer = null;
			_hud = null;
			
			super.destroy();
		}
	}
}