package modding;

import haxe.Log;
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
import sys.io.File;

class PolymodHandler {
    static var modRoot:String = #if TEST_BUILD "../../../new_example_mods" #else "mods" #end;
    static var apiVersion:String = "1.0.0"; // This should match the current engine version.
    static var scriptContexts:Array<ModScriptContexts> = [];

    static var modsList:Array<ModMetadata> = [];
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
    static var selectedMod:Array<String>;

    public static var isInit:Bool = false;
    
    public static function initModList()
    {
        modsList = [];
        scriptContexts = [];
        
        trace("Searching for mods!");

        modsList = Polymod.scan({
            modRoot: modRoot,
            apiVersionRule: '>=$apiVersion',
            errorCallback: function(e:PolymodError) errorCallback(e)
        });

        trace("Scan finished!");
    }

    public static function init()
    {
        trace("Let's have a load.. /ref");
        if (!isInit) initModList();
        selectedMod = ClientPrefs.data.lastLoadedMod ?? [];
        var modExists:Bool = false;
        for (mod in modsList)
        {
            if (mod.id == selectedMod[0])
                modExists = true;
        }

        if (!modExists)
        {
            selectedMod = []; // Prevent an error due to missing mod id
        }

        Polymod.init({
            modRoot: modRoot,
            apiVersionRule: '<=$apiVersion',
            errorCallback: function(e:PolymodError) errorCallback(e),
            frameworkParams: {
                assetLibraryPaths: customAssetLibrary
            },
            dirs: selectedMod
        });
        trace("Finished loading mods!");
    }

    public static function getLoadedMod():String
    {
        if (selectedMod.length > 0) return selectedMod[0];

        return "None";
    }

    public static function getAvailableMods():Array<String>
    {
        var a:Array<String> = [];

        for (mod in modsList)
        {
            a.push(mod.title);
        }

        return a;
    }

    public static function getAvailableModsIDs():Array<String>
    {
        var a:Array<String> = [];

        for (mod in modsList)
        {
            a.push(mod.id);
        }

        return a;
    }

    /*
    * Meant for string representation of the current mods list.
    */
    public static function formattedModList():String
    {
        var s:String = '';
        for (mod in getAvailableMods())
        {
            s += mod + '\n';
        }

        return s.trim();
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

        if (isInit) visual_errorCallback(e, infos);
    }

    /*
    * Creates a visible, in-window error (DIFFERENT FROM CoolUtil.coolError)
    */
    public static function visual_errorCallback(e:Dynamic, ?infos:Null<PosInfos>):Void
    {
        var text:FlxText = new FlxText(0, 0, FlxG.width, Log.formatOutput(e, infos));
        text.setFormat(Paths.font("funkin.ttf"), 8, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
        CoolUtil.addToCurrentState(text);
    }

    public static function createModFromTemplate(name:String)
    {
        Fs.createDirectory('mods/$name');
        File.saveContent('mods/$name/${getDefineString("POLYMOD_MOD_METADATA_FILE")}', getTemplateJSON(name));
        File.copy('assets/images/templates/mods/templateIcon.png', 'mods/$name/${getDefineString("POLYMOD_MOD_ICON_FILE")}');
    }

    static function getTemplateJSON(name:String):String
    {
        return '{
	"title":"$name",
	"description":"Add your description here!",
	"api_version":"1.0.0",
	"mod_version":"0.0.1"
}
        ';
    }
}
#end