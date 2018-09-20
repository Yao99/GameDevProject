package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.addons.editors.tiled.*;
import flixel.addons.tile.*;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;

/*
 *	Level One will load the first map and use the frog character
 */
class LevelOneState extends FlxState {
	
	var _player:Player;
	var _key:FlxSprite; // should key be a custom class?
	var has_key:Bool = false;
	var _map:TiledMap;
	var _mWalls:FlxTilemap;
	var _mSpikes:FlxTilemap;
	var _mFan:FlxTilemap;
	var deathTimer:FlxTimer;
	var dying:Bool = false;
	
	override public function create():Void {
		//load in first map
		_map = new TiledMap(AssetPaths.firstmapdraft__tmx);
		_mWalls = new FlxTilemap();
		_mSpikes = new FlxTilemap();
		_mFan = new FlxTilemap();
		deathTimer = new FlxTimer();
		_mWalls.loadMapFromArray(cast(_map.getLayer("Walls"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.tilemapfinal__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		/*for (i in 0...5) 
			_mWalls.setTileProperties(i, FlxObject.ANY);*/
		//_mWalls.setTileProperties(1, FlxObject.ANY);
		for (i in 10...15) 
			_mWalls.setTileProperties(i, FlxObject.ANY);
		_mSpikes.loadMapFromArray(cast(_map.getLayer("Spikes"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.tilemapfinal__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		/*_mSpikes.setTileProperties(9, FlxObject.ANY);
		_mSpikes.setTileProperties(17, FlxObject.ANY);
*/		/*_mFan.loadMapFromArray(cast(_map.getLayer("Fans"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.tileset1__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		*/
		//_mWalls.follow();
		//collision directions for walls, spikes, and fans
		_mWalls.immovable = true;
		_mSpikes.immovable = true;
		add(_mWalls);
		add(_mSpikes);

		//pass 0 for frog, 1 for elephant
		_player = new Player(0, 2400, 0);
		/*var tmpMap:TiledObjectLayer = cast _map.getLayer("entities");
		for (e in tmpMap.objects) {
			placeEntities(e.type, e.xmlData.x);
		}*/
		add(_player);

		//(0, 1950) for start
		//FlxG.camera.setPosition(0, 540);
		FlxG.camera.setSize(1350, 750);
		FlxG.camera.follow(_player, PLATFORMER, 1);
		FlxG.worldBounds.set(0, 0, 11250, 5250);


		//adding a key
		/*_key = new FlxSprite(300, 50, "assets/images/Key.png");
		has_key = false;
		add(_key);*/
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.collide(_player, _mWalls);
		//FlxG.overlap(_player, _mSpikes, playerPop);
		if (_player.isTouching(FlxObject.FLOOR))
			_player.touchingFloor = true;
		else 
			_player.touchingFloor = false;

		if (_player.isTouching(FlxObject.LEFT) || _player.isTouching(FlxObject.RIGHT))
			_player.touchingWall = true;
		else 
			_player.touchingWall = false;
		
		if (_player.y >= 3750)
			playerPop();
		FlxG.overlap(_player,_key, collectKey);
		super.update(elapsed);
		/*_player.touchingFloor = false;
		FlxG.overlap(_player, _mWalls, grounded);*/
		trace(_mSpikes.overlaps(_player));
		//trace(FlxG.collide(_player, _mSpikes));
		/*if(_mSpikes.overlaps(_player)){
		//	playerPop();
		}*/
		//FlxG.overlap(_player, _mSpikes, playerPop);
		
	}

	function placeEntities(entityName:String, entityData:Xml):Void {
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "Player") {
			_player.x = x;
			_player.y = y;
		}
	} 

	function collectKey(object1:FlxObject, object2:FlxObject):Void {
		//some collect key sound
		has_key = true;
		_key.kill();
	}

	function playerPop():Void {
		//player runs into spikes and dies
		if (!dying) {
			dying = true;
			_player.death();
			deathCheck();
		}
		
		//display gameover message and return to menuState
	}


	public function deathCheck():Void {
		deathTimer.start(0.875, function(Timer:FlxTimer) {
			_player.kill();
			var _restartButton = new FlxButton(0, 0, "Restart", reload);
			_restartButton.screenCenter();
			add(_restartButton);
			var _quitButton = new FlxButton(0, 0, "Quit", quit);
			_quitButton.screenCenter();
			_quitButton.y += 25;
			add(_quitButton);
		}, 1);
		/*while (!dead)
			dead = false;*/
		/*while (deathTimer.elapsedTime < 3.5)
			dead = false*/
		//return dead;

	}

	function grounded(object1:FlxObject, object2:FlxObject):Void {
		_player.touchingFloor = true;
		FlxObject.separate(object1, object2);
	}
	
	function reload(){
		FlxG.switchState(new LevelOneState());
	}
	
	function quit(){
		FlxG.switchState(new MenuState());
	}
}
