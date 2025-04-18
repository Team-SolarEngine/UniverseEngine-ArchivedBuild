package ue.substates;

#if MOD_SUPPORT
import haxe.io.Path;
import sys.FileSystem;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.math.FlxMath;

class ModSwitchMenu extends MusicBeatSubstate {
	var mods:Array<String> = [];
	var alphabets:FlxTypedGroup<Alphabet>;
	var curSelected:Int = 0;

	public override function create() {
		super.create();

		var bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		bg.updateHitbox();
		bg.scrollFactor.set();
		add(bg);

		bg.alpha = 0;
		FlxTween.tween(bg, {alpha: 0.5}, 0.25, {ease: FlxEase.cubeOut});

		mods = ModsFolder.getModsList();
		mods.push(null);
		mods.push('PSYCH MODS');

		alphabets = new FlxTypedGroup<Alphabet>();
		for(mod in mods) {
			var a = new Alphabet(0, 0, mod == null ? "DISABLE MODS" : mod, true);
			a.isMenuItem = true;
			a.scrollFactor.set();
			alphabets.add(a);
		}
		add(alphabets);
		changeSelection(0, true);
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);

		changeSelection((controls.UI_DOWN_P ? 1 : 0) + (controls.UI_UP_P ? -1 : 0) - FlxG.mouse.wheel);

		if (controls.ACCEPT) {
			if (mods[curSelected] != 'PSYCH MODS')
			{
				ModsFolder.switchMod(mods[curSelected]);
				close();
			}
			else
			{
				close();
				MusicBeatState.switchState(new ModsMenuState());
			}
		}

		if (controls.BACK)
			//close();
			MusicBeatState.switchState(new MainMenuState());
	}

	public function changeSelection(change:Int, force:Bool = false) {
		if (change == 0 && !force) return;

		curSelected = FlxMath.wrap(curSelected + change, 0, alphabets.length-1);

		//CoolUtil.playMenuSFX(SCROLL, 0.7);
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);

		for(k=>alphabet in alphabets.members) {
			alphabet.alpha = 0.6;
			alphabet.targetY = k - curSelected;
		}
		alphabets.members[curSelected].alpha = 1;
	}
}
#end