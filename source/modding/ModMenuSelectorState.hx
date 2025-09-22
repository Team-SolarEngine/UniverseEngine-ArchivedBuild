package modding;

import flixel.sound.FlxSound;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class ModMenuSelectorState extends MusicBeatState
{
    var bg:FlxSprite;
    var options:Array<String> = ["Psych Engine Mods", "UE Mod Switcher"];
    var grpOptions:FlxTypedSpriteGroup<Alphabet> = new FlxTypedSpriteGroup<Alphabet>();
    var curSelected:Int = 0;
    var camFollow:FlxObject;

    var camBG:FlxCamera;
    var camOptions:FlxCamera;

    public override function create() {
        super.create();

        //Camera Setup
        camBG = new FlxCamera();
        camOptions = new FlxCamera();
        camOptions.bgColor.alpha = 0;

        camFollow = new FlxObject();
        camFollow.screenCenter(X);
        camOptions.follow(camFollow, LOCKON, 0.06);
        FlxG.cameras.add(camBG);
        FlxG.cameras.add(camOptions, false);

        bg = new FlxSprite().loadGraphic(Paths.image("menuBG"));
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.globalAntialiasing;
        add(bg);

        grpOptions.cameras = [camOptions];
        add(grpOptions);

        for (i in 0...options.length)
        {
            var option = options[i];
            var text:Alphabet = new Alphabet(0, 150 * i, option, true);
            text.screenCenter(X);
            grpOptions.add(text);
        }

        changeSelection();
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK) FlxG.switchState(new MainMenuState());
        if (controls.UI_DOWN_P)
        {
            changeSelection(1);
        }
        if (controls.UI_UP_P)
        {
            changeSelection(-1);
        }
        if (controls.ACCEPT)
        {
            switch(options[curSelected])
            {
                case "Psych Engine Mods":
                    FlxG.switchState(new ModsMenuState());
                case "UE Mod Switcher":
                    CoolUtil.coolError("That state doesn't exist yet", "UE Mod Switcher unavailable");
                    FlxG.sound.play(Paths.sound('cancelMenu'));
            }
        }
    }

    function changeSelection(change:Int = 0):Void
    {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelected += change;
        if (curSelected > options.length - 1)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = options.length - 1;

        for (i in 0...grpOptions.members.length)
        {
            var text = grpOptions.members[i];

            if (i == curSelected)
            {
                text.alpha = 1;
                camFollow.y = text.y;
            }
            else
            {
                text.alpha = 0.5;
            }
        }
    }
}