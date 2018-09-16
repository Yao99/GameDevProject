package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;


/*
 *	Level One will load the first map and use the frog character
 */
class LevelOneState extends FlxState {
	
	var _player:Player;
	var _key:FlxSprite;
	var has_key:Bool;
	var _map:TiledMap;
	var _mWalls:FlxTilemap;
	var _mSpikes:FlxTilemap;
	var _mFan:FlxTilemap;
	
	override public function create():Void {
		//load in first map
		_map = new TiledMap(AssetPaths.firstmapdraft_tmx);
		_mWalls = new FlxTilemap();
		_mSpikes = new FlxTilemap();
		_mFan = new FlxTilemap();
		_mWalls.loadMapFromArray(cast(_map.getLayer("Walls"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.assets1stMap_tsx, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		_mWalls.setTileProperties()
/*		_mSpikes.loadMapFromArray(cast(_map.getLayer("spikes"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.assets1stMap_tsx, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		_mFan.loadMapFromArray(cast(_map.getLayer("fans"), TiledTileLayer).tileArray, _map.width, _map.height, 
			AssetPaths.assets1stMap_tsx, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		*/_mWalls.follow();
		//collision directions for walls, spikes, and fans
		add(_mWalls);

		//pass 0 for frog, 1 for elephant
		_player = new Player(0);
		var tmpMap:TiledObjectLayer = cast _map.getLayer("entities");
		for (e in tmpMap.objects) {
			placeEntities(e.type, e.xmlData.x);
		}
		add(_player);

		//adding a key
		_key = new FlxSprite(300, 50, "assets/images/Key.png");
		has_key = false;
		add(_key);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(_player, _mWalls);
		FlxG.collide(_player,_key,collectKey);
	}

	function placeEntities(entityName:String, entityData.Xml):Void {
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player") {
			_player.x = x;
			_player.y = y;
		}
	} 

	public function collectKey(object1:FlxObject, object2:FlxObject){
		//some collect key sound
		has_key = true;
		_key.kill();
	}
}
