package ue.modding;

import haxe.io.Path;
import flixel.util.FlxSignal.FlxTypedSignal;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.FlxG;
import lime.text.Font;
import openfl.text.Font as OpenFLFont;

#if MODS_ALLOWED
import sys.FileSystem;
#end

class ModsFolder {
    @:dox(hide) public static var onModSwitch:FlxTypedSignal<String->Void> = new FlxTypedSignal<String->Void>();

    public static var currentModFolder:String = null;
    public static var modsPath:String = './mods/';
    public static var addonsPath:String = './addons/';
    public static var useLibFile:Bool = true;
    private static var __firstTime:Bool = true;

    public static function init() {
        if (!getModsList().contains(ClientPrefs.data.lastLoadedMod))
            ClientPrefs.data.lastLoadedMod = null;
    }

    public static function switchMod(mod:String) {
        ClientPrefs.data.lastLoadedMod = currentModFolder = mod;
        reloadMods();
    }

    public static function reloadMods(){
        if (!__firstTime)
            FlxG.switchState(new MainMenuState());
        __firstTime = false;
    }

    public static function getModsList():Array<String> {
        var mods:Array<String> = [];
        #if MODS_ALLOWED
        final modsList:Array<String> = FileSystem.readDirectory(modsPath);

        if (modsList == null || modsList.length <= 0)
            return mods;

        for (modFolder in modsList)
        {
            if (FileSystem.isDirectory('${modsPath}${modFolder}')) {
                mods.push(modFolder);
            }
        }
        #end
        return mods;
    }

	/**
	 * Loads a mod library from the specified path. Supports folders and zips.
	 * @param modName Name of the mod
	 * @param force Whenever the mod should be reloaded if it has already been loaded
	 */
	public static function loadModLib(path:String, force:Bool = false, ?modName:String) {
		#if MOD_SUPPORT
		return loadLibraryFromFolder('$path'.toLowerCase(), '$path', force, modName);

		#else
		return null;
		#end
	}
    
	public static function getLoadedMods():Array<String> {
		var libs = [];
		for (i in Paths.assetsTree.libraries) {
			var l = i;
			if (l is openfl.utils.AssetLibrary) {
				var al = cast(l, openfl.utils.AssetLibrary);
				@:privateAccess
				if (al.__proxy != null) l = al.__proxy;
			}
			var libString:String;
			if (l is ScriptedAssetLibrary || l is IModsAssetLibrary) libString = cast(l, IModsAssetLibrary).modName;
			else continue;
			libs.push(libString);
		}
		return libs;
	}
	public static function prepareLibrary(libName:String, force:Bool = false) {
		var assets:AssetManifest = new AssetManifest();
		assets.name = libName;
		assets.version = 2;
		assets.libraryArgs = [];
		assets.assets = [];

		return AssetLibrary.fromManifest(assets);
	}

	public static function registerFont(font:Font) {
		var openflFont = new OpenFLFont();
		@:privateAccess
		openflFont.__fromLimeFont(font);
		OpenFLFont.registerFont(openflFont);
		return font;
	}

	public static function prepareModLibrary(libName:String, lib:IModsAssetLibrary, force:Bool = false) {
		var openLib = prepareLibrary(libName, force);
		lib.prefix = 'assets/';
		@:privateAccess
		openLib.__proxy = cast(lib, lime.utils.AssetLibrary);
		return openLib;
	}

	#if MOD_SUPPORT
	public static function loadLibraryFromFolder(libName:String, folder:String, force:Bool = false, ?modName:String) {
		return prepareModLibrary(libName, new ModsFolderLibrary(folder, libName, modName), force);
	}
	#end
}