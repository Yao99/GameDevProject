package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;

class LevelSelect extends FlxState
{
	var _level1button:FlxButton;
	var _level2button:FlxButton;
	var _level3button:FlxButton;
	var _level4button:FlxButton;
	var _background:FlxSprite;
	
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

		_level1button = new FlxButton(0,0,"Level One",lvl1);
		_level1button.screenCenter();
		_level1button.y -= 60;
		add(_level1button);
		
		_level2button = new FlxButton(0,0,"Level Two",lvl2);
		_level2button.screenCenter();
		_level2button.y -= 20;
		add(_level2button);
		
		_level3button = new FlxButton(0,0,"Level Three",lvl3);
		_level3button.screenCenter();
		_level3button.y += 20;
		add(_level3button);
		
		_level4button = new FlxButton(0,0,"Level Four",lvl4);
		_level4button.screenCenter();
		_level4button.y += 60;
		add(_level4button);
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.pressed.ESCAPE)
			FlxG.switchState(new MenuState());
		super.update(elapsed);
	}
	
	function lvl1():Void{
		//load level one
		FlxG.switchState(new LevelOneState());
	}
	
	function lvl2():Void{
		//load level one
		FlxG.switchState(new LevelTwoState());
	}
	
	function lvl3():Void{
		//load level one
		FlxG.switchState(new LevelThreeState());
	}
	
	function lvl4():Void{
		//load level one
		FlxG.switchState(new LevelFourState());
	}
	
	
}
