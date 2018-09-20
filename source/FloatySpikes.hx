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

 class FloatySpikes extends FlxSprite {
	 public var xupper:Float;
	 public var xlower:Float;
	 public var yupper:Float;
	 public var ylower:Float;
	 public var xspeed:Float;
	 public var yspeed:Float;
	 
    public function new(?X:Float = 0, ?Y:Float = 0, ?sx:Float = 0,?sy:Float = 0, ?xu:Float = 0, ?xl:Float = 0,?yu:Float = 0, ?yl:Float = 0,?r:Bool = false) {
		super(X, Y);
		
		
		loadGraphic("assets/data/PlatformAssets/FloatySpike.png", true, 75, 150); 
		
		if (r){
			angle = 90;
		}
       
		
		xupper = xu;
		xlower = xl;
		yupper = yu;
		ylower = yl;
		xspeed = sx;
		yspeed = sy;
    }
	 
    function movement():Void {
		x += xspeed;
		y += yspeed;
		if (x > xupper || x < xlower){
			xspeed *= -1;
		}
		if (y > yupper || y < ylower){
			yspeed *= -1;
		}
    }
	
    override public function update(elapsed:Float):Void {
    	movement();
    	super.update(elapsed);
    }

}