package options.ue;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import MusicBeatState;
import Controls;
import lime.app.Application;
#if windows import winapi.WindowsAPI; #end

using StringTools;

class UEGameOptions extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Universe Game options';
		rpcTitle = 'Game options of the engine'; // for Discord Rich Presence

		var option:Option = new Option('Main Menu Music', 'Change the main menu song', 'mmm', 'string', 'Universe', [
			'Universe',
			'FunkinParadise',
			"AAC V4",
			'VS Impostor V4',
			'VS Shaggy',
			'VS Nonsense V2',
			'DNB Old',
			'Stay Funky',
			'Marked Engine',
			'IdiotXD',
			'Normal Collections',
			'Daveberry'
		]);
		addOption(option);
		option.onChange = changeSong;

		var option:Option = new Option('Cute Mode', if (ClientPrefs.data.cm == true)
		{
			'i coded this UwU';
		} else
		{
			'What is this option i never coded this';
		}, 'cm', 'bool', false);
		addOption(option);
		option.onChange = restart;

		/*
		var option:Option = new Option('Check for Updates', 'On Release builds, turn this on to check for updates when you start the game.',
			'checkForUpdates', 'bool', true);
		addOption(option);
		*/

		var option:Option = new Option('Dark Mode', 'Basically dark mode on every website, but cooler', 'darkmode', 'bool', false);
		addOption(option);

		var option:Option = new Option('Loading Screen', 'Loading screen!\nalso, this just does nothing lol', 'loadscreen', 'bool', false);
		addOption(option);

		/*var option:Option = new Option('Silly Bounce', "Makes the dots behind the main menu bounce", 'sillyBob', 'bool', true);
		addOption(option);*/

		var option:Option = new Option('Hide Original Credits', "Hides the original credits built-in in source.", 'hideOriCredits', 'bool', false);
		addOption(option);

		#if windows
		var option:Option = new Option("Dangerous Functions", "This does DANGEROUS stuff to your OS. Not deleting your files, just a extenal window of a message box, hiding the taskbar, etc etc...", "windows", "bool", false);
		addOption(option);
		option.onChange = window;
		#end

		super();
	}

	var changedMusic:Bool = false;

	function onChangePauseMusic()
	{
		if (ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if (changedMusic)
			FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm));
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if (Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}
	#end

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
	}

	function onChangeHitSound()
	{
		FlxG.sound.play(Paths.sound("hitsound-" + ClientPrefs.data.ht), ClientPrefs.data.hitsoundVolume);
	}

	function changeSong()
	{
		FlxG.sound.playMusic(Paths.music("freakyMenu-" + ClientPrefs.data.mmm), 0.7);
	}

	function restart()
	{
		ClientPrefs.saveSettings();
		TitleState.initialized = false;
		TitleState.closedState = false;
		if (FreeplayState.vocals != null)
		{
			FreeplayState.vocals.fadeOut(0.3);
			FreeplayState.vocals = null;
		}
		FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
	}
	#if windows
	function window()
	{
		WindowsAPI.showMessageBox("Warning", "Are you sure, this will mess with your pc", MessageBoxIcon.MSG_QUESTION);
	}
	#end
}
