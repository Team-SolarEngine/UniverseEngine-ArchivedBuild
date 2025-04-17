package credits;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import backend.TreeMenu;
import backend.OptionsScreen;
import backend.type.*;
import credits.*;
import haxe.xml.Access;
import backend.assets.AssetsLibraryList.AssetSource;

using StringTools;

class CreditsState extends TreeMenu
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var items:Array<OptionType> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	var pisspoop:Array<Array<String>>;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Credits Menu", null);
		#end

		persistentUpdate = true;
		if (ClientPrefs.data.darkmode)
		{
			bg = new FlxSprite(0, 0).loadGraphic(Paths.image("aboutMenu", "preload"));
			add(bg);
			bg.screenCenter();
		}
		else
		{
			bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
			add(bg);
			bg.screenCenter();
		}

		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(20, 20);
		grid.alpha = 0;
		FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(grid);

		var xmlPath = Paths.configxml('config/credits');

		for (source in [AssetSource.SOURCE, AssetSource.MODS])
		{
			if (Paths.assetsTree.existsSpecific(xmlPath, "TEXT", source))
			{
				var access:Access = null;
				try
				{
					access = new Access(Xml.parse(Paths.assetsTree.getSpecificAsset(xmlPath, "TEXT", source)));
				}
				catch (e)
				{
					trace('Error while parsing credits.xml: ${Std.string(e)}');
				}

				if (access != null)
					for (c in parseCreditsFromXML(access, source))
						items.push(c);
			}
		}
		// items.push(new TextOption("Universe Engine >", "Select this to see all the contributors of the engine!", function()
		// {
			// optionsTree.add(Type.createInstance(UECredits, []));
		// }));
		// items.push(new TextOption("Psych Engine", "Select this to see the credits of Psych Engine", function()
		// {
			// optionsTree.add(Type.createInstance(PECredits, []));
		// }));
		// items.push(new TextOption("Friday Night Funkin'", "Select this see the creators of the game", function()
		// {
			// optionsTree.add(Type.createInstance(FNFCredits, []));
		// }));

		main = new OptionsScreen('Credits', 'The people who made this possible!', items);

		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		super.update(elapsed);
	}

	public function parseCreditsFromXML(xml:Access, source:Bool):Array<OptionType>
	{
		var credsMenus:Array<OptionType> = [];

		for (node in xml.elements)
		{
			var desc = node.att.resolve("desc");
			
			if (!node.has.name)
			{
				continue;
			}
			var name = node.att.resolve("name");

			switch (node.name)
			{
				case "credit":
					var opt:PortraitOption = new PortraitOption(name, desc, function() if (node.has.url)
						CoolUtil.browserLoad(node.att.url), node.has.icon && Paths.assetsTree.existsSpecific(Paths.getPath('images/credits/${node.att.icon}.png'), "IMAGE", source) ? FlxG.bitmap.add(Paths.image('credits/${node.att.icon}')) : null,
						node.has.size ? Std.parseInt(node.att.size) : 96, node.has.portrait ? node.att.portrait.toLowerCase() == "false" ? false : true : true);
					if (node.has.color)
						@:privateAccess opt.__text.color = FlxColor.fromString(node.att.color);
					credsMenus.push(opt);

				case "menu":
					credsMenus.push(new TextOption(name + " >", desc, function()
					{
						optionsTree.add(new OptionsScreen(name, desc, parseCreditsFromXML(node, source)));
					}));
			}
		}

		return credsMenus;
	}
}
