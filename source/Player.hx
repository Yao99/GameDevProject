 package;

 import flixel.FlxSprite;
 import flixel.FlxObject;
 import flixel.FlxG;
 import flixel.math.FlxPoint;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.math.FlxMath;
 import flixel.util.FlxTimer;

 class Player extends FlxSprite {
	 
 	public var gravity:Float = 500;	//set to negative for fans?
    public var touchingFloor:Bool = true;
    public var touchingWall:Bool = false;
    public var inCloud:Bool = true;
	public var inflated:Bool = false;
	public var elephant:Bool = true;	//start as false
	public var squirrel:Bool = true;	//"   "
	public var snake:Bool = true;		//"   "

	private var xlimit:Float = 250;
 	private var ylimit:Float = 750;	
 	private var species:Int = 0;
	private var specFrog:Bool = false;
	private var specElephant:Bool = false;
	private var specSquirrel:Bool = false;
	private var specSnake:Bool = false;
	private var specTimer:FlxTimer;
	private var expandTimer:FlxTimer;
	private var expandTime:Float = 0;


	
	//species
	//var oldSpecies:Int;

    public function new(?X:Float=0, ?Y:Float=0, ?s:Int=0) {
         super(X, Y);
		 species = s;
		 speciesSetup();

		 //offset.y = 5;
		 //updateHitbox();
		 specTimer = new FlxTimer();
		 expandTimer = new FlxTimer();
		 maxVelocity.set(xlimit, ylimit);
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
			if (species != 0) {
				species = 0;
				speciesSetup();
			}
		}
		if (FlxG.keys.justPressed.TWO){
			if (species != 1 && elephant) {
				species = 1;
				speciesSetup();
			}
		}
		if (FlxG.keys.justPressed.THREE){
			if (species != 2 && squirrel) {
				species = 2;
				speciesSetup();
			}
		}
		if (FlxG.keys.justPressed.FOUR){
			if (species != 3 && snake) {
				species = 3;
				speciesSetup();
			}
		}

		if (FlxG.keys.justPressed.DOWN && inCloud) {
			//inflate
			//while inCloud, track time
			expandTimer.start(3, 0);
			inflated = true;
		}

		if (FlxG.keys.justReleased.DOWN) {
			expandTime = expandTimer.elapsedTime;
			if (expandTime > 3)
				expandTime = 3;
			expandTimer.cancel();
		}

		if (FlxG.keys.justPressed.UP && inflated) {
			inflated = false;
			specSnake = specElephant = specSquirrel = specFrog = false;
			if (species == 3) {
				specSnake = true;
			} else if (species == 1) {
				specElephant = true;
			} else if (species == 2) {
				specSquirrel = true;
			} else 
				specFrog = true;
			specTimer.start(expandTime, function(Timer:FlxTimer) {specSnake = specElephant = specSquirrel = specFrog = false;}, 1);
		}

		acceleration.x = 0;
		acceleration.y = gravity;

 		if (_left || _right || _jump) {
 			if (_jump) {
 				if (touchingFloor) {
 					velocity.y = -maxVelocity.y;
 					if (inflated)
 						velocity.y /= 2;	//jump nerfed
 					else if (specFrog) {	//can leap
 						maxVelocity.y = ylimit * 2;
 						velocity.y = -maxVelocity.y;
 					} else if (!specFrog)
 						maxVelocity.y = ylimit;
 				} else if (specElephant)	//can multi-jump
 					velocity.y = -maxVelocity.y;
 				else if (specSnake && touchingWall) {	//can wall jump
 					velocity.y = -maxVelocity.y; 
 				}
 			}

 			if (_left && !_right) {
 				velocity.x = FlxMath.lerp(velocity.x, -maxVelocity.x, .5);
 				if (inflated) {
 					velocity.x /= 2;
 					animation.play("slowWalk");
 				} else if (!touchingFloor && specSquirrel) {
 					acceleration.y = gravity / 4;
 					animation.play("glide");
 				} else
 					animation.play("walk");
 				facing = FlxObject.LEFT;
 			} else if (_right && !_left) {
 				velocity.x = FlxMath.lerp(velocity.x, maxVelocity.x, .5);
 				if (inflated) {
 					velocity.x /= 2;
 					animation.play("slowWalk");
 				} else if (!touchingFloor && specSquirrel) {
 					acceleration.y = gravity / 4;
 					animation.play("glide");
 				} else
 					animation.play("walk");
 				facing = FlxObject.RIGHT;
 				
 			} else {
 				animation.play("idle");
 			}
 		} else 
 			animation.play("idle");

 		//reset !!!!!!!!!!!!!!!!REMOVE LATER!!!!!!!!!!!!!!!!!!	
 		if (FlxG.keys.pressed.BACKSPACE) {
 			x = 0;
 			y = 2400;
 			inflated = false;
			specSnake = specElephant = specSquirrel = specFrog = false;
 		}
		
		velocity.y = FlxMath.lerp(velocity.y, maxVelocity.y, .01);
		
    }

	function speciesSetup():Void {
		specSnake = specElephant = specSquirrel = specFrog = false;
		if (touchingFloor)
			y -= 50;
		if (species == 0) {
         	loadGraphic("assets/images/Frog1.png", true, 81, 85);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	setFacingFlip(FlxObject.RIGHT, false, false);
         	animation.add("walk", [0, 1, 2], 4, true);
         	animation.add("walk", [0, 1, 2], 2, true);
         	animation.add("idle", [0, 0, 0, 3], 1, true);
			width = 81;
			height = 85;
        } else if (species == 1) {
        	/*if (!elephant) {
        		species = oldSpecies;
        		return;
        	}*/
         	loadGraphic("assets/images/Elephant.png", true, 137, 125);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	setFacingFlip(FlxObject.RIGHT, false, false);
         	animation.add("walk", [0, 2, 10], 3, true);
         	animation.add("slowWalk", [0, 1, 2], 1, true);
         	animation.add("idle", [10, 10, 10, 0, 0], 1, true);
			width = 137;
			height = 125;
        } else if (species == 2) {
         	loadGraphic("assets/images/squirrelGlide.png", true, 87, 100);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	setFacingFlip(FlxObject.RIGHT, false, false);
         	animation.add("walk", [0, 1, 2], 3, true);
         	animation.add("slowWalk", [0, 1, 2], 1, true);
         	animation.add("idle", [0], 1, false);
         	animation.add("glide", [5, 5, 6, 6], 1, true);
			width = 87;
			height = 100;
        } else if (species == 3) {
        	loadGraphic("assets/images/CobraSlithering.png", true, 140, 150);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	setFacingFlip(FlxObject.RIGHT, false, false);
         	animation.add("walk", [0, 1, 2], 3, true);
         	animation.add("slowWalk", [0, 1, 2], 1, true);
         	animation.add("idle", [0], 1, false);
			width = 140;
			height = 150;
        }
	}
	
    override public function update(elapsed:Float):Void {
    	movement();
    	super.update(elapsed);
    }
}