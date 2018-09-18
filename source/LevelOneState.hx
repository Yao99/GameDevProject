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
	
	override public function create():Void {
		//load in first map
		_map = new TiledMap(AssetPaths.firstmapdraft__tmx);
		_mWalls = new FlxTilemap();
		_mSpikes = new FlxTilemap();
		_mFan = new FlxTilemap();
		_mWalls.loadMapFromArray(cast(_map.getLayer("Walls"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.tileset1__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		for (i in 10...15) 
			_mWalls.setTileProperties(i, FlxObject.ANY);
		_mSpikes.loadMapFromArray(cast(_map.getLayer("Spikes"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.tileset1__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		_mSpikes.setTileProperties(10, FlxObject.ANY);
		_mSpikes.setTileProperties(20, FlxObject.ANY);
		/*_mFan.loadMapFromArray(cast(_map.getLayer("Fans"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.tileset1__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		*/
		//_mWalls.follow();
		//collision directions for walls, spikes, and fans
		_mWalls.immovable = true;
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
		FlxG.collide(_mWalls,cast(_player,FlxSprite));
		if ((_player.isTouching(FlxObject.FLOOR)))
			_player.touchingFloor = true;
		else 
			_player.touchingFloor = false;
		//FlxG.overlap(_player, _mSpikes, playerPop);
		FlxG.overlap(_player,_key, collectKey);
		super.update(elapsed);
		/*_player.touchingFloor = false;
		FlxG.overlap(_player, _mWalls, grounded);*/
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

	function playerPop(object1:FlxObject, object2:FlxObject):Void {
		//player runs into spikes and dies
		_player.kill();
		//display gameover message and return to menuState
	}

	function grounded(object1:FlxObject, object2:FlxObject):Void {
		_player.touchingFloor = true;
		FlxObject.separate(object1, object2);
	}
}
