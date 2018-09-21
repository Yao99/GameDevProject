 package;

 import flixel.FlxSprite;
 import flixel.FlxObject;
 import flixel.FlxG;
 import flixel.math.FlxPoint;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.math.FlxMath;
 import flixel.util.FlxTimer;
 import flixel.system.FlxSound;
 import flixel.ui.FlxButton;

 class Player extends FlxSprite {
	 
 	public var gravity:Float = 500;	//set to negative for fans?
    public var touchingFloor:Bool = true;
    public var touchingWall:Bool = false;
    public var inCloud:Bool = false;
	public var inflated:Bool = false;
	public var elephant:Bool = false;	//start as false
	public var squirrel:Bool = false;	//"   "
	public var snake:Bool = false;		//"   "
	public var species:Int = 0;
	public var dead:Bool = false;
	public var gameOver:FlxSound;
	public var has_key:Bool = false;

	private var xlimit:Float = 250;
 	private var ylimit:Float = 800;	
 	private var specFrog:Bool = false;
	private var specElephant:Bool = false;
	private var specSquirrel:Bool = false;
	private var specSnake:Bool = false;
	private var specTimer:FlxTimer;
	private var expandTimer:FlxTimer;
	private var expandTime:Float = 0;
	private var deathTimer:FlxTimer;
	private var ribbitTimer:FlxTimer;
	private var ribbit:FlxSound;
	private var jumpSnd:FlxSound;
	private var popSnd:FlxSound;
	
	var icons:Array<FlxButton> = new Array<FlxButton>();
	
	//species
	//var oldSpecies:Int;

    public function new(?X:Float=0, ?Y:Float=0, ?s:Int=0) {
         super(X, Y);
		 species = s;
		 speciesSetup();
		 soundSetup();

		 //offset.y = 5;
		 //updateHitbox();
		 specTimer = new FlxTimer();
		 expandTimer = new FlxTimer();
		 deathTimer = new FlxTimer();
		 maxVelocity.set(xlimit, ylimit);
		 drag.x = maxVelocity.x * 4;
		 
		 if (s >= 1){
			 squirrel = true;
		 }
		 
		 if (s >= 2){
			 elephant = true;
		 }

		 if (s >= 3){
			 snake = true;
		 }
		 
		 //create icons
		 
		 for (i in 0...4){
		  icons.push(new FlxButton(i * 85, 0, "",changeSpecies.bind(i)));
		  icons[i].loadGraphic("assets/images/icon_"+i+".png", true, 85, 85);
		  icons[i].animation.add("unlocked", [0], 1, true);
		  icons[i].animation.add("equipped", [1], 1, true);
		  icons[i].animation.add("locked", [2], 1, true);
		  if (species == i){
			  icons[i].animation.play("equipped");
		  }else{
			icons[i].animation.play("unlocked");
		  }
		  if (i == 0){
			  		  FlxG.state.add(icons[i]);
		  }else if (i == 1 && squirrel){
			  		  FlxG.state.add(icons[i]);
		  }else if (i == 2 && elephant){
		  		  FlxG.state.add(icons[i]);
		  }else if (i == 3 && snake){
		  		  FlxG.state.add(icons[i]);
		  }

		 }
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
			if (species != 1 && squirrel) {
				species = 1;
				speciesSetup();
			}
		}
		if (FlxG.keys.justPressed.THREE){
			if (species != 2 && elephant) {
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
			if (!inflated) {
				animation.play("inhale");
				//inflate
				//while inCloud, track time
				expandTimer.start(3, 0);
			}
			inflated = true;
		}

		if (FlxG.keys.justReleased.DOWN) {
			expandTime = expandTimer.elapsedTime * 2;
			if (expandTime > 5)
				expandTime = 5;
			expandTimer.cancel();
			animation.play("inhaled");
		}


		if (FlxG.keys.justPressed.UP && inflated) {
			animation.play("exhale");
			inflated = false;
			specSnake = specElephant = specSquirrel = specFrog = false;
			if (species == 3) {
				specSnake = true;
			} else if (species == 2) {
				specElephant = true;
			} else if (species == 1) {
				specSquirrel = true;
				//expandTime = 10;
			} else 
				specFrog = true;
			specTimer.start(expandTime, function(Timer:FlxTimer) {specSnake = specElephant = specSquirrel = specFrog = false;}, 1);
			
		}

		
		
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
					jumpSnd.play();
 					/*if (inflated)
 						velocity.y /= 2;*/	//jump nerfed
 					if (specFrog) {	//can leap
 						maxVelocity.y = ylimit * 1.7;
 						velocity.y = -maxVelocity.y;
 					} else if (!specFrog)
 						maxVelocity.y = ylimit;
 				} else if (specElephant)	//can multi-jump
 					velocity.y = -maxVelocity.y / 2;
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
 					velocity.x /= 1.5;
					/*if (animation.name == "inhale" && animation.finished)
 						animation.play("slowWalk");
 					else 
 						animation.play("slowWalk");*/
 				} else if (!touchingFloor && specSquirrel) {
 					//while (!touchingFloor)
	 				acceleration.y = 0;
	 				velocity.y = 50;
 					animation.play("glide");
 				} else if (animation.name == "exhale" && animation.finished)
 						animation.play("walk");
 				else
 					animation.play("walk");
			}
 		} else {
			if (touchingFloor && velocity.x == 0) {
				if (!inflated) {
					if (animation.name == "exhale" && animation.finished){
						animation.play("idle");
					} else if (animation.name != "exhale"){
						animation.play("idle");
					}
				} else {
					if (animation.name == "inhale" && animation.finished) {
						animation.play("inhaled");
					} else if (animation.name != "inhale"){
						animation.play("inhaled");
					}
				}
			}
	
		}
		if (touchingFloor)
			specSquirrel = false;

 		//reset !!!!!!!!!!!!!!!!REMOVE LATER!!!!!!!!!!!!!!!!!!	
 		if (FlxG.keys.pressed.BACKSPACE) {
 			x = 0;
 			y = 2400;
 			inflated = false;
			specSnake = specElephant = specSquirrel = specFrog = false;
 		}
		
		acceleration.x = 0;
		if (!specSquirrel || touchingFloor || (_left && _right) || !(_left || _right)) {
			acceleration.y = gravity;
			velocity.y = FlxMath.lerp(velocity.y, maxVelocity.y, .01);
		}

		trace(acceleration.y);
		

		/*if (y >= 3750)
			kill();*/
		
    }

	public function speciesSetup():Void {
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
        } else if (species == 2) {
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
        } else if (species == 1) {
         	loadGraphic("assets/images/squirrelAnimations.png", true, 76, 85);
         	setFacingFlip(FlxObject.LEFT, true, false);
         	setFacingFlip(FlxObject.RIGHT, false, false);
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
        graphicLoaded();
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
		} else if (species == 2) {
			loadGraphic("assets/images/poomSquirrel.png", true, 25, 25);
			animation.add("death", [0, 1, 2, 3, 4, 5, 6, 7], 8, false);
			animation.play("death");
		} else {
			loadGraphic("assets/images/poomCobra.png", true, 50, 50);
			animation.add("death", [0, 1, 2, 3, 4, 5, 6, 7], 8, false);
		}
		graphicLoaded();
		animation.play("death");
		popSnd.play();

				//while (!dead) {}
		//kill();
	}

	public function soundSetup():Void {
		ribbit = FlxG.sound.load(AssetPaths.ribbit__wav);
		ribbitTimer = new FlxTimer();
		ribbitTimer.start(7, function(Timer:FlxTimer) {
			if (species == 0 && alive)
				ribbit.play();
		}, 0);
		jumpSnd= FlxG.sound.load(AssetPaths.jumpShort__wav);
		popSnd = FlxG.sound.load(AssetPaths.pop__wav);
		gameOver = FlxG.sound.load(AssetPaths.game_over__wav);

	}

	
    override public function update(elapsed:Float):Void {
    	movement();
    	super.update(elapsed);
    }
	
	public function changeSpecies(i:Int):Void{
		species = i;
		speciesSetup();
	}
}