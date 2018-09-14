 package;

 import flixel.FlxSprite;
 import flixel.FlxObject;
 import flixel.FlxG;
 import flixel.math.FlxPoint;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;

 class Player extends FlxSprite {
 	public var speed:Float = 200;	
 	public var gravity = 200;

     public function new(?X:Float=0, ?Y:Float=0, species:Float) {
         super(X, Y);
         if (species == 0) {
         	loadGraphic("assets/images/FrogWalk.png", true, 80, 85);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	setFacingFlip(FlxObject.RIGHT, false, false);
         	animation.add("walk", [0, 1, 2], 4, true);
         	animation.add("idle", [0], 1, false);
         }
		 /*loadGraphic("assets/images/duck.png", true, 100, 114);
		 setFacingFlip(FlxObject.LEFT, true, false);
		 setFacingFlip(FlxObject.RIGHT,false,false);
		 animation.add("walk", [0, 3, 0, 2], 10, true);
		 animation.play("walk");
		 facing = FlxObject.LEFT;*/

		 //make hitbox
		 //makeGraphic(40, 60, FlxColor.WHITE);

		 drag.x = drag.y = 1600;

     }
     function movement():Void {
     	var _left = false;
     	var _right = false;
     	var _jump = false;
     	var mA:Float = 0;		//angle of travel, up -> <0
     	var yVelocity = 0;

 		_left = FlxG.keys.anyPressed([LEFT, A]);
 		_right = FlxG.keys.anyPressed([RIGHT, D]);
 		_jump = FlxG.keys.anyPressed([SPACE]);

 		/*
 		 *	<Temporary> reset
		*/
		var _reset = false;
		_reset = FlxG.keys.anyPressed([BACKSPACE]);
		if (_reset) {
			x = y = 100;
		}

 		//cancel opposing directions
 		if (_left && _right)
 			_left = _right = false;

 		if (_left || _right || _jump) {
			if (_jump) {
			    mA = -90;
			    yVelocity = gravity;
			    if (_left)
			        mA -= 45;
			    else if (_right)
			        mA += 45;
			} else if (_left) {
			    mA = 180;
			    velocity.set(speed, 0);
				velocity.rotate(FlxPoint.weak(0,0), mA);
				facing = FlxObject.LEFT;
				animation.play("walk");
				
			}
			else if (_right) {
			    mA = 0;
			    velocity.set(speed, 0);
				velocity.rotate(FlxPoint.weak(0,0), mA);
				facing = FlxObject.RIGHT;
				animation.play("walk");
				
			} 

			/*velocity.set(speed, yVelocity);
			velocity.rotate(FlxPoint.weak(0,0), mA);*/
		} else {
				animation.play("idle");
		}
    }

    override public function update(elapsed:Float):Void {
    	movement();
    	super.update(elapsed);
    }
}