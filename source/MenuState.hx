package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;

class MenuState extends FlxState
{
	var _playButton: FlxButton;
	var _background: FlxSprite;
	var _exitButton: FlxButton;
	
	override public function create():Void
	{
		if (FlxG.sound.music == null) // don't restart the music if it's already playing
 {
     FlxG.sound.playMusic(AssetPaths.mainMenu__wav, 1, true);
 }
		super.create();
		_background = new FlxSprite();
		_background.loadGraphic("assets/images/BackgroundTitle.png", true, 1350, 750);
		_background.screenCenter();
		add(_background);
		
		_playButton = new FlxButton(0, 0, clickPlay);
		_playButton.loadGraphic("assets/images/play.png", true, 300, 150);
		_playButton.screenCenter();
		_playButton.y -= 80;
		add(_playButton);
		
		_exitButton = new FlxButton(0, 0, clickExit);
		_exitButton.loadGraphic("assets/images/Exit.png", true, 225, 150);
		_exitButton.screenCenter();
		_exitButton.y += 80;
		add(_exitButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	function clickPlay():Void{
		//load level one
		FlxG.switchState(new LevelFourState());
	}
	
	function clickExit():Void{
		//load level one
		Sys.exit(0);
	}
	
}
