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
	public var species:Int = 0;
	public var dead:Bool = false;


	private var xlimit:Float = 250;
 	private var ylimit:Float = 750;	
 	private var specFrog:Bool = false;
	private var specElephant:Bool = false;
	private var specSquirrel:Bool = false;
	private var specSnake:Bool = false;
	private var specTimer:FlxTimer;
	private var expandTimer:FlxTimer;
	private var expandTime:Float = 0;
	private var deathTimer:FlxTimer;
	

	
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
		 deathTimer = new FlxTimer();
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
			animation.play("inhale");
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
			animation.play("inhaled");
		}


		if (FlxG.keys.justPressed.UP && inflated) {
			animation.play("exhale");
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
		
		/*if (touchingFloor && !inflated && velocity.x == 0){
			animation.play("idle");
		}else if (touchingFloor && inflated && !FlxG.keys.anyPressed([DOWN])){
			animation.play("inflated");
		}*/
		//controls
 		if (_left || _right || _jump) {
 			if (_jump) {
 				if (touchingFloor) {
 					velocity.y = -maxVelocity.y;
					animation.play("jump");
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
 				facing = FlxObject.LEFT;
 			} else if (_right && !_left) {
 				velocity.x = FlxMath.lerp(velocity.x, maxVelocity.x, .5);
 				facing = FlxObject.RIGHT;	
 			}
			
			if (_left || _right && !(_left && _right)){
				if (inflated) {
 					velocity.x /= 2;
					if(animation.finished)
 					animation.play("slowWalk");
 				} else if (!touchingFloor && specSquirrel) {
 					acceleration.y = gravity / 4;
 					animation.play("glide");
 				} else
 					if(animation.finished)animation.play("walk");
			}
 		}else{
			if (touchingFloor && !inflated && velocity.x == 0){
				if (animation.name == "exhale" && animation.finished){
					animation.play("idle");
				}else if (animation.name != "exhale"){
					animation.play("idle");
				}
			}
			
	
		}

 		//reset !!!!!!!!!!!!!!!!REMOVE LATER!!!!!!!!!!!!!!!!!!	
 		if (FlxG.keys.pressed.BACKSPACE) {
 			x = 0;
 			y = 2400;
 			inflated = false;
			specSnake = specElephant = specSquirrel = specFrog = false;
 		}
		
		velocity.y = FlxMath.lerp(velocity.y, maxVelocity.y, .01);

		/*if (y >= 3750)
			kill();*/
		
    }

	function speciesSetup():Void {
		specSnake = specElephant = specSquirrel = specFrog = false;
		if (touchingFloor)
			y -= 50;
		if (species == 0) {
         	loadGraphic("assets/images/FrogFinalAnimation.png", true, 85, 85);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	setFacingFlip(FlxObject.RIGHT, false, false);
         	animation.add("walk", [0, 1, 2], 4, true);
         	animation.add("slowWalk", [0, 1, 2], 2, true);
         	animation.add("idle", [0, 0, 0, 2], 1, true);
			animation.add("inhale", [3, 4, 5], 4, false);
			animation.add("exhale", [4, 3], 4, false);
			animation.add("inhaled", [5], 1, true);
			animation.add("jump", [7, 8, 9,0], 5, false);
			width = 85;
			height = 85;
        } else if (species == 1) {
        	/*if (!elephant) {
        		species = oldSpecies;
        		return;
        	}*/
         	loadGraphic("assets/images/ElephantFinalAnimations.png", true, 85, 85);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	setFacingFlip(FlxObject.RIGHT, false, false);
			animation.add("walk", [0, 1], 4, true);
			animation.add("slowWalk", [0, 1], 2, true);
         	animation.add("idle", [0], 1, true);
			animation.add("inhale", [4, 5, 6], 4, false);
			animation.add("exhale", [5, 4], 4, false);
			animation.add("inhaled", [6], 1, true);
			animation.add("jump", [2, 3, 2,3], 5, false);
			width = 85;
			height = 85;
        } else if (species == 2) {
         	loadGraphic("assets/images/squirrelAnimations.png", true, 76, 85);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	animation.add("glide", [8, 9, 8, 9], 1, true);
			animation.add("walk", [0, 6], 4, true);
			animation.add("slowWalk", [0, 6], 2, true);
         	animation.add("idle", [0], 1, true);
			animation.add("inhale", [2, 3, 4], 4, false);
			animation.add("exhale", [3, 2], 4, false);
			animation.add("inhaled", [4], 1, true);
			animation.add("jump", [6, 7, 7], 5, false);
			width = 76;
			height = 85;
        } else if (species == 3) {
        	loadGraphic("assets/images/CobraAnimations.png", true, 78, 99);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	setFacingFlip(FlxObject.RIGHT, false, false);
			animation.add("walk", [0, 1, 2, 3], 4, true);
			animation.add("walk", [0, 1, 2, 3], 2, true);
         	animation.add("idle", [0], 1, true);
			animation.add("inhale", [6, 7, 8], 4, false);
			animation.add("exhale", [7, 6], 4, false);
			animation.add("inhaled", [8], 1, true);
			animation.add("jump", [3, 5 ,5], 5, false);
			width = 78;
			height = 99;
        }
	}

	public function death() {
		if (species == 0) {
			loadGraphic("assets/images/poomFrog.png", true, 50, 50);
			animation.add("death", [0, 1, 2, 3, 4, 5, 6, 7], 8, false);
			//animation.play("death");
		} else if (species == 1) {
			loadGraphic("assets/images/poomElephant.png", true, 25, 25);
			animation.add("death", [0, 1, 2, 3, 4, 5, 6, 7], 8, false);
			//animation.play("death"); }
		/*} else if (species == 2) {
			loadGraphic("assets/images/poomSquirrel.png", true, 50, 50);
			animation.add("death", [0, 1, 2, 3, 4, 5, 6, 7], 2, false);
			animation.play("death");*/
		} else {
			loadGraphic("assets/images/poomCobra.png", true, 50, 50);
			animation.add("death", [0, 1, 2, 3, 4, 5, 6, 7], 8, false);
		}
		graphicLoaded();
		animation.play("death");

				//while (!dead) {}
		//kill();
	}

	
    override public function update(elapsed:Float):Void {
    	movement();
    	super.update(elapsed);
    }
}