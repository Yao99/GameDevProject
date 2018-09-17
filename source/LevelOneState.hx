package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.addons.editors.tiled.*;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap;


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
			AssetPaths.tileset1__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 0, 1, 3);
		for (i in 11...17) 
			_mWalls.setTileProperties(i, FlxObject.ANY);
		/*_mSpikes.loadMapFromArray(cast(_map.getLayer("Spikes"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.tileset1__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 0, 1, 3);
		_mSpikes.setTileProperties(10, FlxObject.ANY);
		_mSpikes.setTileProperties(20, FlxObject.ANY);*/
		/*_mFan.loadMapFromArray(cast(_map.getLayer("fans"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.assets1stMap_tsx, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		*/
		_mWalls.follow();
		//collision directions for walls, spikes, and fans
		add(_mWalls);

		//pass 0 for frog, 1 for elephant
		_player = new Player(0, 0, 0);
		var tmpMap:TiledObjectLayer = cast _map.getLayer("entities");
		for (e in tmpMap.objects) {
			placeEntities(e.type, e.xmlData.x);
		}
		add(_player);

		//adding a key
		/*_key = new FlxSprite(300, 50, "assets/images/Key.png");
		has_key = false;
		add(_key);*/
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(_player, _mWalls);
		//FlxG.overlap(_player, _mSpikes, playerPop);
		FlxG.overlap(_player,_key, collectKey);
	}

	function placeEntities(entityName:String, entityData:Xml):Void {
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player") {
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
}
