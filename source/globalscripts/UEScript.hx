package globalscripts;

import globalscripts.uescripts.Options.DetachedHB;
import globalscripts.uescripts.Options.SmoothHP;
import globalscripts.ScriptMap.ScriptLocator;

import globalscripts.uescripts.Events;
import globalscripts.uescripts.Force.DifficultyLVL;
import globalscripts.uescripts.Force.SongName;
import globalscripts.uescripts.Force.Fire;
import globalscripts.uescripts.Force.Baldi;
import globalscripts.uescripts.Force.DiscordRPCScript;
import globalscripts.uescripts.Force.TrailDoubleNote;

import globalscripts.uescripts.Options.UEHud as HudScript;
import globalscripts.uescripts.Options.IconBop;
import globalscripts.uescripts.Options.Keystrokes;
import globalscripts.uescripts.Options.TauntOnGo;
import globalscripts.uescripts.Options.DarkenCamGame;
import globalscripts.uescripts.Options.ZoomedOut;
import globalscripts.uescripts.Options.EveryHundredCombo;
import globalscripts.uescripts.Options.ShakeOnMiss;

import globalscripts.uescripts.GP.CrashOnMiss;
import globalscripts.uescripts.GP.SusAsOneNote;
import globalscripts.uescripts.GP.HealthDrain;
import globalscripts.uescripts.GP.HealthDrainPT2;


class UEScript extends BaseScript
{
    public static var FORCE:Array<BaseScript> = [];
    public static var OPTIONS:Array<BaseScript> = [];
    public static var GP:Array<BaseScript> = [];
    public static var EXTERN:Array<BaseScript> = [];

    public static var scriptIDs:ScriptMap<String, String> = new ScriptMap<String, String>();

    public static var allLoadedScripts:Map<String, BaseScript> = new Map<String, BaseScript>();

    public static var totalScripts(get, null):Int = 0;
    static function get_totalScripts():Int
    {
        return FORCE.length + OPTIONS.length + GP.length;
    }
    public static var instance:UEScript;

    public function new(?name:String, ?id:String)
    {
        super(name == null ? 'UEScript' : name, id == null ? 'UEScript' : id);

        instance = this;
    }

    function clearScripts()
    {
        if (FORCE.length > 0 || OPTIONS.length > 0 || GP.length > 0 || EXTERN.length > 0)
            {
                // Shouldn't be more then 0, but if it is, clear scripts!
                #if debug trace('RESETTING LOADED SCRIPTS'); #end
    
                var clearedScripts:Int = 0;
    
                for (script in FORCE) {
                    #if debug Logs.traceNew('CLEARING "${script.name}".', INFO); #end
                    script.onDestroy();
                }
                clearedScripts += FORCE.length;
                FORCE = [];
    
                for (script in OPTIONS) {
                    #if debug Logs.traceNew('CLEARING "${script.name}".', INFO); #end
                    script.onDestroy();
                }
                clearedScripts += OPTIONS.length;
                OPTIONS = [];
    
                for (script in GP) {
                    #if debug Logs.traceNew('CLEARING "${script.name}".', INFO); #end
                    script.onDestroy();
                }
                clearedScripts += GP.length;
                GP = [];
    
                for (script in EXTERN) {
                    #if debug trace('CLEARING "${script.name}".'); #end
                    script.onDestroy();
                }
                clearedScripts += EXTERN.length;
                EXTERN = [];
    
                #if debug Logs.traceNew('CLEARED $clearedScripts SCRIPTS', INFO); #end
            }
    }
    public override function initialize():Void
    {
        clearScripts();

        #if debug trace('LOADING SCRIPTS INTO ARRAYS'); #end

        pushScripts(getForcedScripts(), FORCE);
        pushScripts(getOptionScripts(), OPTIONS);
        pushScripts(getGPScripts(), GP);

        #if debug trace('SCRIPTS LOADED: $totalScripts'); #end

        for (script in FORCE) {
            #if debug trace('INITIALIZING ${script.name}'); #end
            script.initialize();
            script.nameCallback = function(s:String):String return updateScriptText(s, script.name, 'force');
            allLoadedScripts.set(script.name, script);
        }
        for (script in OPTIONS) {
            #if debug trace('INITIALIZING ${script.name}'); #end
            script.initialize();
            script.nameCallback = function(s:String):String return updateScriptText(s, script.name, 'options');
            allLoadedScripts.set(script.name, script);
        }
        for (script in GP) {
             #if debug trace('INITIALIZING ${script.name}'); #end
            script.initialize();
            script.nameCallback = function(s:String):String return updateScriptText(s, script.name, 'gp');
            allLoadedScripts.set(script.name, script);
        }

        #if debug trace ('ALL SCRIPTS INITIALIZED'); #end

        // Taken from the initial script, makes sure the FPS display is set to the correct font.
        Main.fpsVar.defaultTextFormat = new openfl.text.TextFormat("funkin.ttf", 15, 10);
        super.initialize();
    }

    public override function onCreate() {
        super.onCreate();

        for (script in FORCE)
            script.onCreate();
        for (script in OPTIONS)
            script.onCreate();
        for (script in GP)
            script.onCreate();
    }
    public override function onRating(name:String) {
        super.onRating(name);

        for (script in FORCE)
            script.onRating(name);
        for (script in OPTIONS)
            script.onRating(name);
        for (script in GP)
            script.onRating(name);
    }

    public override function onMoveCamera(focus:String)
    {
        super.onMoveCamera(focus);

        for (script in FORCE)
            script.onMoveCamera(focus);
        for (script in OPTIONS)
            script.onMoveCamera(focus);
        for (script in GP)
            script.onMoveCamera(focus);
    }

    function updateScriptText(s:String, oldName:String, arrayName:String):String
    {
        try
        {
            var scriptNames_FORCE:Array<String> = [];

            for (script in FORCE)
                scriptNames_FORCE.push(script.name);

            var scriptNames_OPTIONS:Array<String> = [];

            for (script in OPTIONS)
                scriptNames_OPTIONS.push(script.name);

            var scriptNames_GP:Array<String> = [];

            for (script in GP)
                scriptNames_GP.push(script.name);

            var scriptNames_EXTERN:Array<String> = [];

            for (script in EXTERN)
                scriptNames_EXTERN.push(script.name);

            switch (arrayName.lower())
            {
                case 'force':
                    for (name in scriptNames_FORCE)
                    {
                        if (name == oldName)
                            name = s;
                    }

                case 'options':
                    for (name in scriptNames_OPTIONS)
                    {
                        if (name == oldName)
                            name = s;
                    }
                    
                case 'gp' | 'gameplay':
                    for (name in scriptNames_GP)
                    {
                        if (name == oldName)
                            name = s;
                    }
                case 'extern' | 'external':
                    for (name in scriptNames_EXTERN)
                    {
                        if (name == oldName)
                            name = s;
                    }
            }
            scriptsLoaded.text = 'Scripts Loaded: $totalScripts\nFORCE: $scriptNames_FORCE\nOPTIONS: $scriptNames_OPTIONS\nGameplay Settings: $scriptNames_GP\nExternal: $scriptNames_EXTERN';
        }
        catch(e:Dynamic){}

        return s;
    }
    var UEenginescriptlocateOPTIONS = "uescript/OPTIONS/";
    var UEenginescriptlocateFORCE = "uescript/FORCE/";
    var UEenginescriptlocateGP = "uescript/GP/";

    function getForcedScripts():Array<BaseScript>
    {
        var array:Array<BaseScript> = [
            new DifficultyLVL(),
            new SongName(),
            new Fire(),
            new Baldi(),
            new DiscordRPCScript(),
            new TrailDoubleNote(),
            new Events()
        ];

        return array;
    }

    function getOptionScripts():Array<BaseScript>
    {
        var array:Array<BaseScript> = [];

        if (UEHud)
            array.push(new HudScript());
        if (UEDetachedHB)
            array.push(new DetachedHB());
        if (UEhudZoomOut)
            array.push(new ZoomedOut());
        if (UEcCounter)
            addLuaScript(UEenginescriptlocateOPTIONS + 'Combo Counter');
        if (UESmoothHP)
            array.push(new SmoothHP());
        if (UEe100C)
            array.push(new EveryHundredCombo());
        if (UEshakeMiss)
            array.push(new ShakeOnMiss());
        if (UEdarkenCamGame)
            array.push(new DarkenCamGame());
        if (UEstrumsplash)
            addLuaScript(UEenginescriptlocateOPTIONS + 'Strum Splash');
        if (UEmisssounds)
            addLuaScript(UEenginescriptlocateOPTIONS + "Miss Sounds");
        if (UEresultscreen)
            addLuaScript(UEenginescriptlocateOPTIONS + 'Results Screen'); // Remember to remove when new results screen is made!
        if (UEiconBop)
            array.push(new IconBop());
        if (UEkeystrokes)
            array.push(new Keystrokes());
        if (UEtauntGo)
            array.push(new TauntOnGo());

        return array;
    }
    
    function getGPScripts():Array<BaseScript>
    {
        var array:Array<BaseScript> = [];
        
        if (UEsd)
            array.push(new CrashOnMiss());
        if (UEsustainOneNote)
            array.push(new SusAsOneNote());
        if (UEhealthDrain)
            array.push(new HealthDrain());
        if (UEhealthdrainp2)
            array.push(new HealthDrainPT2());
        if (UEplayBothSides)
            addLuaScript(UEenginescriptlocateGP +  "Play Both Sides");
        if (UEIncreasePBR)
            addLuaScript(UEenginescriptlocateGP +  'Increase Playback');

        return array;
    }

    override function addLuaScript(LuaFile:String, ?ignoreAlreadyRunning:Bool = false) {
        if (LuaFile != (UEenginescriptlocateGP +  "Play Both Sides")) Logs.traceNew("Reminder to port `" + LuaFile + "` to source!", INFO);
        super.addLuaScript(LuaFile, ignoreAlreadyRunning);
    }

    static var scriptsLoaded:FlxText;

    public function scriptFunc(func:BaseScript->Void)
    {
        var totalScripts:Array<Array<BaseScript>> = [
            FORCE,
            OPTIONS,
            GP,
            EXTERN
        ];

        for (scripts in totalScripts)
        {
            for (script in scripts)
            {
                func(script);
            }
        }
    }

    public override function onCreatePost() {
        super.onCreatePost();

        scriptFunc(function(script:BaseScript) script.onCreatePost());
        
        if (ClientPrefs.data.showLoadedScripts)
        {
            var FORCE:Array<BaseScript> = UEScript.FORCE;
            var OPTIONS:Array<BaseScript> = UEScript.OPTIONS;
            var GP:Array<BaseScript> = UEScript.GP;
            var EXTERN:Array<BaseScript> = UEScript.EXTERN;
            
            var scriptNames_FORCE:Array<String> = [];
            for (script in FORCE)
                scriptNames_FORCE.push('${script.name}[${script.id}]');
            var scriptNames_OPTIONS:Array<String> = [];
            for (script in OPTIONS)
                scriptNames_OPTIONS.push('${script.name}[${script.id}]');
            var scriptNames_GP:Array<String> = [];
            for (script in GP)
                scriptNames_GP.push('${script.name}[${script.id}]');
            var scriptNames_EXTERN:Array<String> = [];
            for (script in EXTERN)
                scriptNames_EXTERN.push('${script.name}[${script.id}]');

            scriptsLoaded = new FlxText(0,0,FlxG.width, 'Scripts Loaded: $totalScripts\nFORCE: $scriptNames_FORCE\nOPTIONS: $scriptNames_OPTIONS\nGameplay Settings: $scriptNames_GP\nExternal: $scriptNames_EXTERN', 10);
            scriptsLoaded.alpha = 0.8;
            scriptsLoaded.cameras = [game.camOther]; // camOther so it always stays in the game widnow!
            scriptsLoaded.borderStyle = OUTLINE;
            scriptsLoaded.borderColor = 0xFF000000;
            scriptsLoaded.screenCenter(Y);
            add(scriptsLoaded);
        }
    }

    public override function goodNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.goodNoteHit(id, direction, noteType, isSustainNote);

        scriptFunc(function(script:BaseScript) script.goodNoteHit(id, direction, noteType, isSustainNote));
    }

    public override function onNoteMiss(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.onNoteMiss(id, direction, noteType, isSustainNote);

        scriptFunc(function(script:BaseScript) script.onNoteMiss(id, direction, noteType, isSustainNote));
    }

    public override function opponentNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.opponentNoteHit(id, direction, noteType, isSustainNote);

        scriptFunc(function(script:BaseScript) script.opponentNoteHit(id, direction, noteType, isSustainNote));
    }

    public override function onDestroy() {
        super.onDestroy();

        scriptFunc(function(script:BaseScript) script.onDestroy());
    }

    public override function onSongStart() {
        super.onSongStart();

        scriptFunc(function(script:BaseScript) script.onSongStart());
    }

    public override function onUpdate(elapsed:Float) {
        super.onUpdate(elapsed);

        scriptFunc(function(script:BaseScript) script.onUpdate(elapsed));
    }

    public override function onUpdatePost(elapsed:Float) {
        super.onUpdatePost(elapsed);

        scriptFunc(function(script:BaseScript) script.onUpdatePost(elapsed));
    }

    public override function onEvent(name:String, value1:String, value2:String, strumTime:Float) {
        super.onEvent(name, value1, value2, strumTime);

        scriptFunc(function(script:BaseScript) script.onEvent(name, value1, value2, strumTime));
    }

    public override function onBeatHit() {
        super.onBeatHit();

        scriptFunc(function(script:BaseScript) script.onBeatHit());
    }

    public override function onPause() {
        super.onPause();

        scriptFunc(function(script:BaseScript) script.onPause());
    }

    public override function onResume() {
        super.onResume();

        scriptFunc(function(script:BaseScript) script.onResume());
    }

    public override function onCountdownTick(tick:Int)
    {
        super.onCountdownTick(tick);

        scriptFunc(function(script:BaseScript) script.onCountdownTick(tick));
    }

    function pushScripts(scripts:Array<BaseScript>, array:Array<BaseScript>, initialize:Bool = false):Array<BaseScript>
    {
        for (script in scripts)
        {
            pushScript(script, array, initialize);
            Logs.traceNew('LOADED SCRIPT: "${script.name}".', INFO);
            allLoadedScripts.set(script.name, script);
        }

        return array;
    }

    static function getScriptArray(name:String):Array<BaseScript>
    {
        var array = switch (name.lower()) {
            case 'force':
                FORCE;
            case 'option' | 'options':
                OPTIONS;
            case 'gp' | 'gameplay':
                GP;
            default:
                EXTERN;
        };

        return array;
    }

    @:privateAccess static function removeByID(id:String, array:String):Bool
    {
        for (script in getScriptArray(array))
        {
            if (script.id == id)
            {
                getScriptArray(array).remove(script);
                script.onDestroy();
                return true;
            }

        }
        return false;
    }

    public static function _removeScript(internalID:String):Bool
    {
        if (!scriptIDs.exists(internalID))
            trace('HEY `$internalID` DOESN\'T EXIST, HAS IT BEEN ADDED YET?');
            return false;

        var scriptConfig:ScriptLocator = scriptIDs.getLocator(internalID);

        trace('FOUND `${scriptConfig.name}[$internalID]` REMOVING');
        trace('OLD ARRAY FOR "${scriptConfig.array}" `${getScriptArray(scriptConfig.array)}`');

        var result:Bool = removeByID(internalID, scriptConfig.array);

        if (!result)
        {
            trace('COULD NOT REMOVE `${scriptConfig.name}[$internalID]`???');
            return false;
        }
        else
        {
            trace('SUCCESSFULLY REMOVED `${scriptConfig.name}[$internalID]`');
            trace('NEW ARRAY FOR "${scriptConfig.array}" `${getScriptArray(scriptConfig.array)}`');
        }

        if (ClientPrefs.data.showLoadedScripts)
        {
            try
            {
                var scriptNames_FORCE:Array<String> = [];
                for (script in FORCE)
                    scriptNames_FORCE.push(script.name);
                var scriptNames_OPTIONS:Array<String> = [];
                for (script in OPTIONS)
                    scriptNames_OPTIONS.push(script.name);
                var scriptNames_GP:Array<String> = [];
                for (script in GP)
                    scriptNames_GP.push(script.name);
                var scriptNames_EXTERN:Array<String> = [];
                for (script in EXTERN)
                    scriptNames_EXTERN.push(script.name);
                scriptsLoaded.text = 'Scripts Loaded: $totalScripts\nFORCE: $scriptNames_FORCE\nOPTIONS: $scriptNames_OPTIONS\nGameplay Settings: $scriptNames_GP\nExternal: $scriptNames_EXTERN';
            }
            catch(e:Dynamic){}
        }

        return true;
    }

    public static function pushScript(script:BaseScript, ?array:Array<BaseScript>, initialize:Bool = true):Array<BaseScript>
    {
        if (array != null)
            array.push(script);
        else // If no array specified likely is none of the catagorys!
            EXTERN.push(script);

        Logs.traceNew('LOADED SCRIPT: "${script.name}".', INFO);
        if (initialize) script.initialize();
        Logs.traceNew('THE NEW ARRAYS ARE `$FORCE` `$OPTIONS` `$GP` `$EXTERN`', INFO);
        
        if (ClientPrefs.data.showLoadedScripts)
        {
            try
            {
                var scriptNames_FORCE:Array<String> = [];
                for (script in FORCE)
                    scriptNames_FORCE.push(script.name);
                var scriptNames_OPTIONS:Array<String> = [];
                for (script in OPTIONS)
                    scriptNames_OPTIONS.push(script.name);
                var scriptNames_GP:Array<String> = [];
                for (script in GP)
                    scriptNames_GP.push(script.name);
                var scriptNames_EXTERN:Array<String> = [];
                for (script in EXTERN)
                    scriptNames_EXTERN.push(script.name);
                scriptsLoaded.text = 'Scripts Loaded: $totalScripts\nFORCE: $scriptNames_FORCE\nOPTIONS: $scriptNames_OPTIONS\nGameplay Settings: $scriptNames_GP\nExternal: $scriptNames_EXTERN';
            }
            catch(e:Dynamic){}
        }

        allLoadedScripts.set(script.name, script);
        return array;
    }
}

class MasterScript extends BaseScript
{
    public function new(name:String = 'Unnamed Script', ?id:String)
    {
        super(name, id);
    }

    public function callScript(?script:String) {
        if (script != null)
            executeScript('scripts/$script.hx');

        UEScript._removeScript(id);
    }

    function executeScript(path:String)
    {
        trace('NOT DONE YET');
    }
}