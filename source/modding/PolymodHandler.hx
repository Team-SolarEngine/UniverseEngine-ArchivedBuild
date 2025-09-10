package modding;

#if MODS_ALLOWED
import polymod.Polymod;
import polymod.util.DefineUtil.getDefineString;
import polymod.util.DefineUtil.getDefineBool;

import modding.ModFolder;
import modding.ScriptContext;
import modding.ScriptContext.ModScriptContexts;

import sys.FileSystem as Fs;
import sys.io.File; // Just in case, may get removed later if unused.

class PolymodHandler {
    var modRoot:String = #if TEST_BUILD "../../../new_example_mods" #else "mods/" #end;
    var apiVersion:String = "1.0.0"; // This should match the current engine version.

    var curMods_folder:Array<ModFolder> = [];
    var raw_curMods:Array<ModMetadata> = [];
    var scriptContexts:Array<ModScriptContexts> = [];
    
    public static function initMods()
    {
        raw_curMods = Polymod.init({
            modRoot: modRoot,
            apiVersionRule: '>=$apiVersion'
        });

        trace("Let's have a mod load.. /ref");

        for (mod in raw_curMods)
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
                    curMods_folder.push(new ModFolder(mod.id, mod.modPath, mod.title));

                    scriptContexts.push(initScriptContexts(mod.modPath, mod.id));
                }
            }
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

    public static function enableMod(id:String):Bool
    {
        var tempMods:Array<ModMetadata> = Polymod.loadMod(id);
        var mod:ModMetadata = get_modByID(id);
        curMods_folder.push(new ModFolder(id, mod.modFolder, mod.title));
        scriptContexts.push(initScriptContexts(mod.modPath, mod.id));

        trace("Enabled mod: `" + mod.title + '`[$id]');
    }
}
#end