package modding;

import polymod.Polymod;
import flixel.addons.ui.FlxUIInputText;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import modding.PolymodHandler.getAvailableMods;
import modding.PolymodHandler.getAvailableModsIDs;

class UEModSwitchState extends MusicBeatState
{
    var bg:FlxSprite;
    var grpMods:FlxTypedSpriteGroup<Alphabet> = new FlxTypedSpriteGroup<Alphabet>();
    public var curSelected:Int = 0;
    var camFollow:FlxObject;
    var init:Bool = false;

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
        modsList.push("Create New Mod");
        modIdList.push("newMod");

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
        var delayTimer = new FlxTimer().start(0.1, function(_) {
            init = true;
            selectable = true;
        });
    }

    var selectable:Bool = false;
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
        if (controls.ACCEPT && selectable)
        {
            selectable = false;
            // Swap that mod in!
            if (modIdList[curSelected] == "newMod")
            {
                openSubState(new NewModSubstate(this));
            }
            else
            {
                modSwitchCallback();
            }
        }
    }

    public function modSwitchCallback(resetState:Bool = false)
    {
        if (modIdList[curSelected] != "disableMods")
                ClientPrefs.data.lastLoadedMod = [modIdList[curSelected]];
        else
            ClientPrefs.data.lastLoadedMod = [];

        ClientPrefs.saveSettings();
        MusicBeatState.switchState(new LoadState(true, !resetState ? new MainMenuState() : new UEModSwitchState()));
    }

    public function changeSelection(change:Int = 0):Void
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


class NewModSubstate extends MusicBeatSubstate
{
    var bg:FlxSprite;
    var text1:Alphabet;
    var modTitle:Alphabet;
    var camNewMod:FlxCamera;

    var newModName:String = "newmod";
    var bgTween:FlxTween;
    var text1Tween:FlxTween;
    var modTitleTween:FlxTween;

    var initialized:Bool = false;
    var inputBox:FlxUIInputText;
    var instance:UEModSwitchState;

    public function new(i:UEModSwitchState)
    {
        super();
        instance = i;
    }

    public override function create() {
        super.create();

        camNewMod = new FlxCamera();
        FlxG.cameras.add(camNewMod, false);
        this.cameras = [camNewMod];

        inputBox = new FlxUIInputText(0, 0, FlxG.width, newModName, 1);
        add(inputBox);
        bg = new FlxSprite().loadGraphic(Paths.image("aboutMenu"));
        bg.alpha = 0;
        add(bg);

        text1 = new Alphabet(0, 100, "MOD NAME");
        text1.alpha = 0;
        text1.screenCenter(X);
        add(text1);

        modTitle = new Alphabet(0, 0, newModName);
        modTitle.alpha = 0;
        modTitle.screenCenter();
        add(modTitle);

        bgTween = FlxTween.tween(bg, {alpha: 1}, 2);
        text1Tween = FlxTween.tween(text1, {alpha: 1}, 2);
        modTitleTween = FlxTween.tween(modTitle, {alpha: 1}, 2);
        var delayTimer = new FlxTimer().start(2.5, function(_) initialized = true);
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);

        if (!initialized) return;
        var exit:Bool = FlxG.keys.justPressed.ESCAPE;
        var accept:Bool = FlxG.keys.justPressed.ENTER;
        if (accept)
        {
            PolymodHandler.createModFromTemplate(newModName);
            tweenOut();
        }
        if (exit)
        {
            tweenOut();
        }
        inputBox.hasFocus = true;
        modTitle.text = newModName = inputBox.text;
    }

    function tweenOut()
    {
        bgTween = FlxTween.tween(bg, {alpha: 0}, 2);
        text1Tween = FlxTween.tween(text1, {alpha: 0}, 2);
        modTitleTween = FlxTween.tween(modTitle, {alpha: 0}, 2);
        var delayTimer = new FlxTimer().start(2.5, function(_)
        {
            close();
            PolymodHandler.initModList();
            instance.curSelected = 0;
            instance.changeSelection();
            instance.modSwitchCallback();
        });
    }

    public override function close() {
        super.close();
        FlxG.cameras.remove(camNewMod);
    }
}