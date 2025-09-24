package modding;

import polymod.Polymod;

class LoadState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
    
    var stateToLoad:Class<FlxState>;
    public function new(?hotReload:Bool = false, ?lastState:FlxState = null)
    {
        super();

        if (hotReload)
        {
            stateToLoad = Type.getClass(lastState);
            Polymod.clearScripts();
        }
    }

    public override function create() {
        super.create();

        Logs.traceNew("Game Setup - Loading Prefs/Mods", INFO);

        if (!PolymodHandler.isInit)
        {
            Paths.clearStoredMemory();
            Paths.clearUnusedMemory();
        }

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
        #if MODS_ALLOWED
        PolymodHandler.init();
        #end

        Logs.traceNew("Finished loading!", INFO);

        PolymodHandler.isInit = true;
        if (stateToLoad != null)
        {
            FlxG.switchState(Type.createInstance(stateToLoad, []));
        }
        else
        {
            FlxG.switchState(new TitleState());
        }
    }
}