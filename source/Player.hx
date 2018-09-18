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
 	public var gravity:Float = 2000;
	public var xVelocity:Float = 0;
    public var yVelocity:Float = 0;

    public function new(?X:Float=0, ?Y:Float=0, species:Float) {
         super(X, Y);
         if (species == 0) {
         	loadGraphic("assets/images/Frog.png", true, 80, 85);
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
		 //makeGraphic(40, 60, FlxColor.WHITE);

		 drag.x = drag.y = 1600;

     }
	 
     function movement():Void {
     	var _left = false;
     	var _right = false;
     	var _jump = false;

 		_left = FlxG.keys.anyPressed([LEFT, A]);
 		_right = FlxG.keys.anyPressed([RIGHT, D]);
 		_jump = FlxG.keys.anyPressed([SPACE]);
		
		//reset !!!!!!!!!!!!!!!!REMOVE LATER!!!!!!!!!!!!!!!!!!
		var _reset = false;
		_reset = FlxG.keys.anyPressed([BACKSPACE]);
		if (_reset) {
			x = y = 100;
		}

 		//cancel opposing directions
 		if (_left && _right)
 			_left = _right = false;
		
		//directions
		if (_left) {
			xVelocity = FlxMath.lerp(xVelocity, -speed_limit, .5);
			velocity.rotate(FlxPoint.weak(0,0), 180);
			facing = FlxObject.LEFT;
			animation.play("walk");				
		}else if (_right) {
		    xVelocity = FlxMath.lerp(xVelocity, speed_limit, .5);
			velocity.rotate(FlxPoint.weak(0,0), 0);
			facing = FlxObject.LEFT;
			animation.play("walk");			
		}else{
			xVelocity = FlxMath.lerp(xVelocity, 0, .9);
		}
		
		if (_jump) {
			yVelocity = -200;
			facing = FlxObject.LEFT;
			animation.play("walk");
		}
		
		if (!_jump && !_left && !_right){
			animation.play("idle");
		}

		velocity.x = xVelocity;
		velocity.y = FlxMath.lerp(yVelocity,100,.5);
    }

    override public function update(elapsed:Float):Void {
    	movement();
    	super.update(elapsed);
    }
}