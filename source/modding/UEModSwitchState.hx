package modding;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import modding.PolymodHandler.getAvailableMods;
import modding.PolymodHandler.getAvailableModsIDs;

class UEModSwitchState extends MusicBeatState
{
    var bg:FlxSprite;
    var grpMods:FlxTypedSpriteGroup<Alphabet> = new FlxTypedSpriteGroup<Alphabet>();
    var curSelected:Int = 0;
    var camFollow:FlxObject;

    var camBG:FlxCamera;
    var camOptions:FlxCamera;

    var modsList:Array<String>;
    var modIdList:Array<String>;

    public override function create() {
        super.create();

        modsList = getAvailableMods();
        modIdList = getAvailableModsIDs();
        modsList.insert(0, "Disable Mods");
        modIdList.insert(0, "disableMods");

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

        grpMods.cameras = [camOptions];
        add(grpMods);

        // Temp until full mod details are coded in
        for (i in 0...modsList.length)
        {
            var option = modsList[i];
            var text:Alphabet = new Alphabet(0, 150 * i, option, true);
            text.screenCenter(X);
            grpMods.add(text);
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
            // Swap that mod in!
            if (modIdList[curSelected] != "disableMods")
                ClientPrefs.data.lastLoadedMod = [modIdList[curSelected]];
            else
                ClientPrefs.data.lastLoadedMod = [];

            ClientPrefs.saveSettings();
            MusicBeatState.switchState(new LoadState(true, new MainMenuState()));
        }
    }

    function changeSelection(change:Int = 0):Void
    {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelected += change;
        if (curSelected > modsList.length - 1)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = modsList.length - 1;

        for (i in 0...grpMods.members.length)
        {
            var text = grpMods.members[i];

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

    public override function startOutro(onOutroComplete:() -> Void) {
        super.startOutro(onOutroComplete);
        FlxG.cameras.remove(camBG);
        FlxG.cameras.remove(camOptions);
    }
}