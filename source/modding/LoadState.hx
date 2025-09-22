package modding;

import polymod.Polymod;

class LoadState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

    var skipBaseInit:Bool = false;
    var stateToLoad:FlxState;
    public function new(?hotReload:Bool = false, ?lastState:FlxState = null)
    {
        super();

        if (hotReload)
        {
            skipBaseInit = true;
            stateToLoad = lastState;
            Polymod.clearScripts();
        }
    }

    public override function create() {
        super.create();

        Logs.traceNew("Loadin Stuffs", INFO);

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

        if (!skipBaseInit)
        {
            #if LUA_ALLOWED
            Paths.pushGlobalMods();
            #end
            // Just to load a mod on start up if ya got one. For mods that change the menu music and bg
            WeekData.loadTheFirstEnabledMod();

            FlxG.game.focusLostFramerate = 10;
            FlxG.sound.muteKeys = muteKeys;
            FlxG.sound.volumeDownKeys = volumeDownKeys;
            FlxG.sound.volumeUpKeys = volumeUpKeys;
            FlxG.keys.preventDefaultKeys = [TAB];

            PlayerSettings.init();

            ClientPrefs.loadPrefs();

            Highscore.load();
        }
        #if MODS_ALLOWED
        PolymodHandler.initMods();
        #end

        Logs.traceNew("Finished loading!", INFO);

        if (stateToLoad != null)
        {
            FlxG.switchState(stateToLoad);
        }
        else
        {
            FlxG.switchState(new TitleState());
        }
    }
}