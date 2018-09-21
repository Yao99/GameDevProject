 package;

 import flixel.FlxSprite;
 import flixel.FlxObject;
 import flixel.FlxG;
 import flixel.math.FlxPoint;
 import flixel.system.FlxAssets.FlxGraphicAsset;

 class Key extends FlxSprite {
 	public function new(?X:Float=0, ?Y:Float=0) {
        super(X, Y);
        loadGraphic("assets/images/key.png", true, 33, 22);
        width = 33;
    	height = 22;
    	graphicLoaded();
    }
}

