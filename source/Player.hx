 package;

 import flixel.FlxSprite;
 import flixel.FlxObject;
 import flixel.system.FlxAssets.FlxGraphicAsset;

 class Player extends FlxSprite
 {
     public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
     {
         super(X, Y, SimpleGraphic);
		 loadGraphic("assets/images/duck.png", true, 100, 114);
		 setFacingFlip(FlxObject.LEFT, true, false);
		 setFacingFlip(FlxObject.RIGHT,false,false);
		 animation.add("walk", [0, 3, 0, 2], 10, true);
		 animation.play("walk");
		 facing = FlxObject.LEFT;
     }
 }