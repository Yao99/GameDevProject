package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.addons.editors.tiled.*;
import flixel.addons.tile.*;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

/*
 *	Level Four will load the fourth map and use the cobra character
 */
class LevelFourState extends FlxState {
	
	var _player:Player;
	//var _key:FlxSprite; // should key be a custom class?
	//var has_key:Bool = false;
	var _map:TiledMap;
	var _mWalls:FlxTilemap;
	var _mSpikes:FlxTilemap;
	var _mExpand:FlxTilemap;
	var _mCage:FlxTilemap;
	var _mFan:FlxTilemap;
	var deathTimer:FlxTimer;
	var dying:Bool = false;
	var _restartButton:FlxButton;
	var _quitButton:FlxButton;
	var _key:Key;
	var _fSpikes:FloatySpikes;
	var _fSpikes1:FloatySpikes;
	var trophy:FlxSprite;
	var victoryMessage:FlxText;
	var done:Bool = false;
	
	override public function create():Void {
		if (FlxG.sound.music != null) // don't restart the music if it's already playing
	{
	 FlxG.sound.music.destroy;
     FlxG.sound.playMusic(AssetPaths.snakeSong__wav, 1, true);
	}
		//load in first map
		_map = new TiledMap(AssetPaths.fourthmapdraft__tmx);
		_mWalls = new FlxTilemap();
		_mSpikes = new FlxTilemap();
		_mExpand = new FlxTilemap();
		_mCage = new FlxTilemap();
		_mFan = new FlxTilemap();
		deathTimer = new FlxTimer();

		_mWalls.loadMapFromArray(cast(_map.getLayer("Walls"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.tilesetfinal__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		for (i in 0...2) 
			_mWalls.setTileProperties(i, FlxObject.NONE);
		//_mWalls.setTileProperties(1, FlxObject.ANY);
		for (i in 17...32)
			_mWalls.setTileProperties(i, FlxObject.ANY);
		_mWalls.setTileProperties(36, FlxObject.NONE);

		/*for (i in 32...36)
			_mWalls.setTileProperties(i, FlxObject.NONE);*/

		_mSpikes.loadMapFromArray(cast(_map.getLayer("Spikes"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.tilesetfinal__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		for (i in 13...17)
			_mSpikes.setTileProperties(i, FlxObject.ANY);
		/*for (i in 0...13)
			_mSpikes.setTileProperties(i, FlxObject.NONE);
		for (i in 17... 36)
			_mSpikes.setTileProperties(i, FlxObject.NONE);
*/
		_mExpand.loadMapFromArray(cast(_map.getLayer("Expand"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.tilesetfinal__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		/*for (i in 0...2)
			_mExpand.setTileProperties(i, FlxObject.NONE);*/
		for (i in 2...13) 
			_mExpand.setTileProperties(i, FlxObject.ANY);
		for (i in 32...37)
			_mExpand.setTileProperties(i, FlxObject.NONE);
		/*for (i in 13...36)
			_mExpand.setTileProperties(i, FlxObject.NONE);
*/
		/*_mCage.loadMapFromArray(cast(_map.getLayer("Cage"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.tilesetfinal__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
	/*	for (i in 0...33)
			_mCage.setTileProperties(i, FlxObject.NONE);*/
	/*	for (i in 33...36) 
			_mCage.setTileProperties(i, FlxObject.ANY);
		*/
		/*_mSpikes.setTileProperties(9, *//*FlxObject.ANY);
		_mSpikes.setTileProperties(17, FlxObject.ANY);
*/		/*_mFan.loadMapFromArray(cast(_map.getLayer("Fans"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.tileset1__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		*/
		//_mWalls.follow();
		//collision directions for walls, spikes, and fans
		
		//background art
		var _background:FlxButton = new FlxButton();
		_background.loadGraphic("assets/images/BackgroundTitle.png", true, 1350, 750);
		_background.screenCenter();
		add(_background);
		
		/*_fSpikes = new FloatySpikes(6*75, 8*75, 0, 3, 6*75,6*75,10*75,6*75);
		add(_fSpikes);

		_fSpikes1 = new FloatySpikes(18*75, 17*75, 3, 0, 22*75,14*75,17*75,17*75,true);
		add(_fSpikes1);*/
		
		
		_mWalls.immovable = true;
		_mSpikes.immovable = true;
		_mExpand.immovable = true;
		_mCage.immovable = true;
		add(_mWalls);
		add(_mSpikes);
		add(_mExpand);
		add(_mCage);

		//pass 0 for frog, 1 for squirrel, 2 for elephant, and 3 for cobra
		_player = new Player(0, 2850, 3);
		/*var tmpMap:TiledObjectLayer = cast _map.getLayer("entities");
		for (e in tmpMap.objects) {
			placeEntities(e.type, e.xmlData.x);
		}*/
		add(_player);

		trophy = new FlxSprite(2200, 2200, "assets/images/trophy.png");
		add(trophy);
/*
		_key = new Key(790, 260);
		add(_key);
*/
		//(0, 1950) for start
		//FlxG.camera.setPosition(0, 540);
		FlxG.camera.setSize(1350, 750);
		FlxG.camera.follow(_player, PLATFORMER, 1);
		FlxG.worldBounds.set(0, 1875, 3375, 2625);


		//adding a key
		/*_key = new FlxSprite(300, 50, "assets/images/Key.png");
		has_key = false;
		add(_key);*/
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (_player.overlaps(_mWalls))
			FlxObject.separate(_player, _mWalls);
		//trace(_mExpand.overlapsWithCallback(_player));
		if (_mExpand.overlapsWithCallback(_player)) {
			_player.inCloud = true;
			FlxObject.separate(_player, _mExpand);
		}
		else 
			_player.inCloud = false;

		//_mCage.overlapsWithCallback(_player, caged);
		//FlxG.collide(_player, _mExpand);
		//FlxG.collide(_player, _mCage);
		//FlxG.collide(_player, _mExpand);
		//FlxG.overlap(_player, _mSpikes, playerPop);
		if (_player.isTouching(FlxObject.FLOOR))
			_player.touchingFloor = true;
		else 
			_player.touchingFloor = false;

		if (_player.isTouching(FlxObject.LEFT) || _player.isTouching(FlxObject.RIGHT))
			_player.touchingWall = true;
		else 
			_player.touchingWall = false;
		
		if (_player.y >= 4500 || _player.y < 1875)
			playerPop();


		/*if (_player.x >= 3400 && _player.x <= 3500)
			_player.floating = true;
		else 
			_player.floating = false;*/

		//trace(FlxG.overlap(_player, _mSpikes, spikeHit));
		_mSpikes.overlapsWithCallback(_player, spikeHit);

		/*if (_player.overlaps(_key))
			collectKey();
*/
		if (_player.overlaps(trophy))
			levelWin();

		/*if (_player.overlaps(_fSpikes))
			playerPop();
			
		if (_player.overlaps(_fSpikes1))
			playerPop();*/
		/*if (_player.overlaps(_fSpikes) || _player.overlaps(_fSpikes1))
			playerPop();*/
		//FlxG.overlap(_player,_key, collectKey);
		super.update(elapsed);
		/*_player.touchingFloor = false;
		FlxG.overlap(_player, _mWalls, grounded);*/
		
		//FlxG.collide(_player, _mSpikes);
		//trace(FlxG.collide(_player, _mSpikes));
		/*if(_mSpikes.overlaps(_player)){
		//	playerPop();
		}*/
		
		
	}

	function placeEntities(entityName:String, entityData:Xml):Void {
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "Player") {
			_player.x = x;
			_player.y = y;
		}
	} 

	function collectKey():Void {
		//some collect key sound
		_player.has_key = true;
		_key.kill();
	}

	function caged(object1:FlxObject, object2:FlxObject):Bool {
		if (_player.has_key) {
			//win
			_player.snake = true;
			levelWin();
			return true;
		}
		FlxObject.separate(object1, object2);
		return false;
	}

	function spikeHit(object1:FlxObject, object2:FlxObject):Bool {
		/*var xCoord:Int = Std.int(object2.x / 75);
		var yCoord:Int = Std.int(object2.y / 75);
		var tileID:Int = _mSpikes.getTile(xCoord, yCoord);*/
		//trace(tileID);
		//if (tileID >= 13 && tileID <= 16)
			playerPop();
			return true;
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
			_player.gameOver.play();
			_player.kill();
			_restartButton = new FlxButton(0, 0, "Restart", reload);
			_restartButton.screenCenter();
			add(_restartButton);
			_quitButton = new FlxButton(0, 0, "Quit", quit);
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
	
	public function levelWin():Void {
		if(!done){
		var _thanks = new FlxButton(0, 0);
		_thanks.loadGraphic("assets/images/recruitText.png", false, 225, 150);
		_thanks.screenCenter();
		_thanks.y -= 100;
		add(_thanks);
		_player.destroy();
		trophy.destroy();
		/*victoryMessage = new FlxText(0, 0, FlxG.width, "Congrats: You win!", 64);
		victoryMessage.setFormat(null, 64, FlxColor.GRAY, CENTER);
		//victoryMessage.screenCenter();
		add(victoryMessage);*/
		var _nextButton = new FlxButton(0, 0, "Play Again", nextlevel);
		_nextButton.screenCenter();
		add(_nextButton);
		var _quitButton = new FlxButton(0, 0, "Quit", quit);
		_quitButton.screenCenter();
		_quitButton.y += 25;
		add(_quitButton);
		}
		done = true;
	}

	function grounded(object1:FlxObject, object2:FlxObject):Void {
		_player.touchingFloor = true;
		FlxObject.separate(object1, object2);
	}
	
	function reload() {
		FlxG.switchState(new LevelFourState());
		
		/*_player.x = 0;
		_player.y =	2000;
		_player.revive();
		_restartButton.kill();
		_quitButton.kill();
		_player.speciesSetup();*/
	}
	
	function quit() {
		FlxG.switchState(new MenuState());
	}
	
	function nextlevel(){
		//load next lvl
		FlxG.switchState(new LevelOneState());

	}
}