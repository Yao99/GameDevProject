package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;

class MenuState extends FlxState
{
	var _playButton: FlxButton;
	var _background: FlxSprite;
	
	override public function create():Void
	{
		if (FlxG.sound.music == null) // don't restart the music if it's already playing
 {
     FlxG.sound.playMusic(AssetPaths.mainMenu__wav, 1, true);
 }
		super.create();
		_background = new FlxSprite();
		/*make background image here
		_background.loadGraphic();
		add(_background);*/
		
		_playButton = new FlxButton(0, 0, clickPlay);
		_playButton.loadGraphic("assets/images/play.png", true, 300, 150);
		_playButton.screenCenter();
		add(_playButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	function clickPlay():Void{
		FlxG.switchState(new LevelOneState());
	}
	
}
