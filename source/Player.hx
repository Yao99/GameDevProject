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
 	public var speed_limit:Float = 200;	
 	public var gravity:Float = 200;
	public var xVelocity:Float = 0;
    public var yVelocity:Float = 0;
    public var touchingFloor:Bool = true;

    public function new(?X:Float=0, ?Y:Float=0, species:Float) {
         super(X, Y);
         if (species == 0) {
         	loadGraphic("assets/images/Frog1.png", true, 81, 85);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	setFacingFlip(FlxObject.RIGHT, false, false);
         	animation.add("walk", [0, 1, 2], 4, true);
         	animation.add("idle", [0, 0, 0, 3], 1, false);
         } else if (species == 1) {
         	loadGraphic("assets/images/Elephant.png", true, 137, 125);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	setFacingFlip(FlxObject.RIGHT, false, false);
         	animation.add("walk", [0, 2, 10], 3, true);
         	animation.add("idle", [10, 10, 10, 0, 0], 1, false);
         }
		 /*loadGraphic("assets/images/duck.png", true, 100, 114);
		 setFacingFlip(FlxObject.LEFT, true, false);
		 setFacingFlip(FlxObject.RIGHT,false,false);
		 animation.add("walk", [0, 3, 0, 2], 10, true);
		 animation.play("walk");
		 facing = FlxObject.LEFT;*/

		 //make hitbox
		 width = 75;
		 height = 75;
		 //offset.y = 5;
		 //updateHitbox();

		 maxVelocity.set(160, 400);
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
		
		//reset !!!!!!!!!!!!!!!!REMOVE LATER!!!!!!!!!!!!!!!!!!
		/*var _reset = false;
		_reset = FlxG.keys.anyPressed([BACKSPACE]);
		if (_reset) {
			x = y = 100;
		}*/

		acceleration.x = 0;
		

 		//cancel opposing directions
 		/*if (_left && _right)
 			_left = _right = false;*/

 		if (_left || _right || _jump) {
 			if (_jump && touchingFloor) {
 				velocity.y = -maxVelocity.y / 2;
 			}

 			if (_left && !_right) {
 				acceleration.x = -maxVelocity.x * 4;
 				facing = FlxObject.LEFT;
 				animation.play("walk");
 			} else if (_right && !_left) {
 				acceleration.x = maxVelocity.x * 4;
 				facing = FlxObject.RIGHT;
 				animation.play("walk");
 			} else {
 				animation.play("idle");
 			}
 		} else 
 			animation.play("idle");

 		if (FlxG.keys.pressed.BACKSPACE) {
 			x = 0;
 			y = 2475;
 		}
		
		//directions
		/*if (_left) {
			xVelocity = FlxMath.lerp(xVelocity, -speed_limit, .5);
			velocity.rotate(FlxPoint.weak(0,0), 180);
			facing = FlxObject.LEFT;
			animation.play("walk");				
		} else if (_right) {
		    xVelocity = FlxMath.lerp(xVelocity, speed_limit, .5);
			velocity.rotate(FlxPoint.weak(0,0), 0);
			facing = FlxObject.RIGHT;
			animation.play("walk");			
		} else{
			xVelocity = FlxMath.lerp(xVelocity, 0, .9);
		}
		
		if (_jump) {
			yVelocity = -600;
			facing = FlxObject.LEFT;
			animation.play("walk");
		}
		
		if (!_jump && !_left && !_right){
			animation.play("idle");
		}

		if (touchingFloor) {
			velocity.y = 0;
			acceleration.y = 0;
		} else {
			//acceleration.y = gravity;
			acceleration.y = gravity;
		}*/
    }

    override public function update(elapsed:Float):Void {
    	movement();
    	super.update(elapsed);
    }
}