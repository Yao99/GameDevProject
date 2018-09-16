package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;

class PlayState extends FlxState {
	
	var _player:Player;
	var _key:FlxSprite;
	
	var has_key:Bool;
	
	override public function create():Void
	{
		//pass 0 for frog, 1 for elephant
		_player = new Player(20,20, 1);
		add(_player);
		
		//adding a key
		_key = new FlxSprite(300, 50, "assets/images/Key.png");
		has_key = false;
		add(_key);
		
		
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.collide(_player,_key,collectKey);
		super.update(elapsed);
	}
	
	public function collectKey(object1:FlxObject, object2:FlxObject){
		//some collect key sound
		has_key = true;
		_key.kill();
	}
}
