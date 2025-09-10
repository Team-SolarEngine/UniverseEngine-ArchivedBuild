package modding;

import haxe.PosInfos;
#if MODS_ALLOWED
import polymod.Polymod;
import polymod.Polymod.PolymodError;
import polymod.util.DefineUtil.getDefineString;
import polymod.util.DefineUtil.getDefineBool;

import modding.ModFolder;
import modding.ScriptContext;
import modding.ScriptContext.ModScriptContexts;

import sys.FileSystem as Fs;
import sys.io.File; // Just in case, may get removed later if unused.

class PolymodHandler {
    static var modRoot:String = #if TEST_BUILD "../../../new_example_mods" #else "mods" #end;
    static var apiVersion:String = "1.0.0"; // This should match the current engine version.

    static var curMods_folder:Array<ModFolder> = [];
    static var raw_curMods:Array<ModMetadata> = [];
    static var scriptContexts:Array<ModScriptContexts> = [];

    static var customAssetLibrary:Map<String, String> = [
        #if VIDEOS_ALLOWED "videos" => "./videos", #end
        "songs" => "./songs",
        "shared" => "shared",
        "week2" => "./week1",
        "week3" => "./week2",
        "week4" => "./week3",
        "week5" => "./week4",
        "week6" => "./week5",
        "week7" => "./week7",
        "shaders" => "./shaders"
    ];
    
    public static function initMods()
    {
        curMods_folder = [];
        raw_curMods = [];
        scriptContexts = [];
        
        trace("Let's have a mod load.. /ref");

        raw_curMods = Polymod.scan({
            modRoot: modRoot,
            apiVersionRule: '>=$apiVersion',
            errorCallback: function(e:PolymodError) errorCallback(e)
        });

        var modDirs:Array<String> = [];
        for (mod in raw_curMods)
        {
            modDirs.push(mod.id);
        }

        Polymod.init({
            modRoot: modRoot,
            apiVersionRule: '>=$apiVersion',
            errorCallback: function(e:PolymodError) errorCallback(e),
            frameworkParams: {
                assetLibraryPaths: customAssetLibrary
            },
            dirs: modDirs
        });

        try
        {
            for (mod in raw_curMods)
            {
                if (ClientPrefs.data.enabledMods.length > 0)
                {
                    for (modMeta in ClientPrefs.data.enabledMods)
                    {
                        if (mod.id != modMeta[0])
                        {
                            if (mod.title != modMeta[1])
                            {
                                fireModDisable(mod.id);
                            }
                            fireModDisable(mod.id);
                        }
                        else
                        {
                            Logs.traceNew("Loaded mod: `" + mod.title + '`[${mod.id}]', INFO);
                            curMods_folder.push(new ModFolder(mod.id, mod.title, true));

                            //scriptContexts.push(initScriptContexts(mod.modPath, mod.id));
                        }
                    }
                }
                else
                {
                    Logs.traceNew("Loaded mod: `" + mod.title + '`[${mod.id}]', INFO);
                    curMods_folder.push(new ModFolder(mod.id, mod.title, true));

                    //scriptContexts.push(initScriptContexts(mod.modPath, mod.id));
                }
            }
        }
        catch(e:Dynamic)
        {
            Logs.traceNew("Mod loading didn't work! `" + Std.string(e) + "`", ERROR);
        }

        trace("Loading finished! Final loaded mods: " + Std.string(curMods_folder.length) + ' / ${raw_curMods.length}');
    }

    static function errorCallback(e:PolymodError, ?infos:Null<PosInfos>):Void
    {
        if (e.severity == NOTICE)
        {
            Logs.traceNew(e.message, INFO, infos);
        }

        if (e.severity == WARNING)
        {
            Logs.traceNew(e.message, WARNING, infos);
        }

        if (e.severity == ERROR)
        {
            Logs.traceNew(e.message, ERROR, infos);
        }
    }

    static function initScriptContexts(path:String, id:String):ModScriptContexts
    {
        var scriptContexts:Array<ScriptContext> = [];
        var p = path + '/game';
        if (Fs.exists(p))
        {
            var f = Fs.readDirectory(p);
            var sbd:Array<String> = [];
            for (file in f)
            {
                if (Fs.isDirectory(p + '/$file'))
                {
                    sbd.push(file);
                }
                else
                {
                    scriptContexts.push(new ScriptContext(p, file));
                }
            }
        }

        return new ModScriptContexts(id, scriptContexts);
    }

    static function getScriptContexts(mod_id:String):ModScriptContexts
    {
        for (contexts in scriptContexts)
        {
            if (contexts.mod_id == mod_id)
                return contexts;
        }

        trace("Couldn't find that mod id!");
        return null;
    }

    /*
    * This is here so that mod scripts can find the folder they're currently in
    */
    public static function getScriptContext(sFileName:String, id:String):ScriptContext
    {
        var contexts = getScriptContexts(id);

        for (script in contexts.contexts)
        {
            if (script.script == sFileName)
                return script;
        }

        trace("Not a validly loaded script!");
        return null;
    }

    public static function get_modByID(id:String):ModMetadata
    {
        for (mod in raw_curMods)
        {
            if (mod.id == id)
            {
                return mod;
            }
        }

        trace("Couldn't find a mod with that ID!");
        return null;
    }

    public static function get_enabledModByID(id:String):ModFolder
    {
        for (mod in curMods_folder)
        {
            if (mod.id == id)
            return mod;
        }

        trace("Couldn't find a mod with that ID!");
        return null;
    }

    /* 
    * ONLY USE THIS FUNCTION AFTER INIT HAS FINISHED.
    */
    public static function disableMod(id:String):Bool return fireModDisable(id, false);

    static function fireModDisable(id:String, isInitPhase:Bool = true):Bool
    {
        if (!isInitPhase) trace('Disabling mod `${get_modByID(id).title}[$id]');

        Polymod.unloadMod(id);
        scriptContexts.remove(getScriptContexts(id));
        return curMods_folder.remove(get_enabledModByID(id));
    }

    public static function enableMod(id:String)
    {
        var tempMods:Array<ModMetadata> = Polymod.loadMod(id);
        var mod:ModMetadata = get_modByID(id);
        scriptContexts.push(initScriptContexts(mod.modPath, mod.id));
        curMods_folder.push(new ModFolder(mod.id, mod.title, true));

        trace("Enabled mod: `" + mod.title + '`[$id]');
    }
}
#end