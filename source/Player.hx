 package;

 import flixel.FlxSprite;
 import flixel.FlxObject;
 import flixel.FlxG;
 import flixel.math.FlxPoint;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.math.FlxMath;

 class Player extends FlxSprite {
	 
	//movement
 	public var speed_limit:Float = 1000;	
 	public var gravity:Float = 500;
    public var touchingFloor:Bool = true;
	public var jumping:Bool = false;
	
	//species
	var species:Int;

    public function new(?X:Float=0, ?Y:Float=0, s:Int) {
         super(X, Y);
		 species = s;
		 speciesSetup();

		 //offset.y = 5;
		 //updateHitbox();

		 maxVelocity.set(250, 750);
		 acceleration.y = gravity;
		 drag.x = maxVelocity.x * 4;

     }
	 
    function movement():Void {
     	var _left = false;
     	var _right = false;
     	var _jump = false;
     	//var gravity = 600;

 		_left = FlxG.keys.anyPressed([LEFT, A]);
 		_right = FlxG.keys.anyPressed([RIGHT, D]);
 		_jump = FlxG.keys.justPressed.SPACE;

 		if (FlxG.keys.justPressed.ONE){
			if (species != 0){
				species = 0;
				speciesSetup();
			}
		}
		if (FlxG.keys.justPressed.TWO){
			if (species != 1){
				species = 1;
				speciesSetup();
			}
		}
		if (FlxG.keys.justPressed.THREE){
			if (species != 2){
				species = 2;
				speciesSetup();
			}
		}

 		if (_left || _right || _jump) {
 			if (_jump && touchingFloor) {
 				velocity.y = -750;
 			}

 			if (_left && !_right) {
 				velocity.x = FlxMath.lerp(velocity.x, -speed_limit, .5);
 				facing = FlxObject.LEFT;
 				animation.play("walk");
 			} else if (_right && !_left) {
 				velocity.x = FlxMath.lerp(velocity.x, speed_limit, .5);
 				facing = FlxObject.RIGHT;
 				animation.play("walk");
 			} else {
 				animation.play("idle");
 			}
 		} else 
 			animation.play("idle");

 		//reset !!!!!!!!!!!!!!!!REMOVE LATER!!!!!!!!!!!!!!!!!!	
 		if (FlxG.keys.pressed.BACKSPACE) {
 			x = 0;
 			y = 2475;
 		}
		
		velocity.y = FlxMath.lerp(velocity.y, speed_limit, .01);
		
    }

	function speciesSetup():Void{
		if(touchingFloor)
		y -= 50;
		 if (species == 0) {
         	loadGraphic("assets/images/Frog1.png", true, 81, 85);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	setFacingFlip(FlxObject.RIGHT, false, false);
         	animation.add("walk", [0, 1, 2], 4, true);
         	animation.add("idle", [0, 0, 0, 3], 1, false);
			width = 81;
			height = 85;
         } else if (species == 1) {
         	loadGraphic("assets/images/Elephant.png", true, 137, 125);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	setFacingFlip(FlxObject.RIGHT, false, false);
         	animation.add("walk", [0, 2, 10], 3, true);
         	animation.add("idle", [10, 10, 10, 0, 0], 1, false);
			width = 137;
			height = 125;
         }else if (species == 2) {
         	loadGraphic("assets/images/squirrelGlide.png", true, 87, 100);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	setFacingFlip(FlxObject.RIGHT, false, false);
         	animation.add("walk", [0, 1, 2], 3, true);
         	animation.add("idle", [0], 1, false);
			width = 87;
			height = 100;
         }
	}
	
    override public function update(elapsed:Float):Void {
    	movement();
    	super.update(elapsed);
    }
}