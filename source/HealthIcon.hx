package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public var imageFile:String;
	public function changeIcon(char:String) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			imageFile = name;
			var file:Dynamic = Paths.image(name);

			var imageRatio:Int = Math.round(width / height); // The ratio for the image, used to divide the image.
			loadGraphic(file); //Load stupidly first for getting the file size
			var framesArray:Array<Int> = [0, 1]; // The amount of animation frames
			var w2 = width;
			loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); //Then load it fr
			for (i in 0...imageRatio)
			{
				iconOffsets[i] = (width - 150) / imageRatio;
				framesArray[i] = i;
			}
			updateHitbox();

			animation.add(char, framesArray, 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.data.globalAntialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}
}
