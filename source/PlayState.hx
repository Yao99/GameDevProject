package;

import flixel.FlxState;

class PlayState extends FlxState {
	
	var _player:Player;
	
	override public function create():Void
	{
		//pass 0 for frog, 1 for elephant
		_player = new Player(20,20, 1);
		add(_player);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
