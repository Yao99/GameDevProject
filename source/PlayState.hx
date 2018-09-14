package;

import flixel.FlxState;

class PlayState extends FlxState {
	
	var _player:Player;
	
	override public function create():Void
	{
		//start with frog
		_player = new Player(20,20, 0);
		add(_player);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
