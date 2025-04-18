package credits;

import flixel.group.FlxGroup.FlxTypedGroup;

class UECredits extends OptionsScreen
{
	var credits:Array<Array<String>> = [
        ['< Universe Engine DEVs >'],
		[
			'Video Bot',
			'videobot',
			'First DEV, In charge of the HX files',
			'https://linktr.ee/videobot',
			'14FFFF'
		],
		[
			'BaranMuzu',
			'baranmuzu',
			'Second DEV, In charge of the LUA files and other',
			'https://linktr.ee/baranmuzu',
			'BE9877'
		],
		[
			'CharGoldenYT',
			'char',
			"Joined the project because me, 'VideoBot', asked him",
			'https://bsky.app/profile/chargoldenyt.bsky.social',
			'FF8800'
		],
		['< Former UE DEV >'],
		[
			'Daveberry',
			'uwenalil',
			'Former DEV, (No Longer) In charge of the LUA, HX files and other',
			'https://daveberry.netlify.app/',
			'008bff'
		],
		['< UE Borrowed Code >'],
		['Edwhak', 'Edwhak', 'Modchart Tool', 'https://www.youtube.com/@EDWHAK', '00FF00'],
		[
			'Rozebud',
			'rozebud',
			"Chart Editor's Lil' Buddies",
			'https://x.com/helpme_thebigt',
			'6D2F83'
		],
		[
			'SilverSpringing',
			'invis',
			'Combo Counter',
			'https://gamebanana.com/members/1823951',
			'00FFFF'
		],
		[
			'Unholywanderer',
			'invis',
			'Smooth HP',
			'https://gamebanana.com/members/1908754',
			'00FFFF'
		],
		[
			'Kiruwu',
			'invis',
			'Weekend 1 Port',
			'https://gamebanana.com/mods/512609',
			'B3715F'
		],
		[
			'Spelo',
			'invis',
			'Play Both Sides',
			'https://www.youtube.com/watch?v=xmUQUi8rd9M',
			'FFFFFF'
		],
		['< UE Special Thanks >'],
		[
			"Codename Engine",
			"cne",
			"HScript Support and new credits system. They're the GOAT",
			"https://codename-engine.com/",
			"ae5cb8"
		],
		[
			'Blitz',
			'Blitz',
			'Universe Logo And Playtester',
			'https://www.youtube.com/@fireballfurby',
			'00FFFF'
		],
		[
			'An Ammar',
			'Ammar',
			'Hype Mode, Detached Health Bar, Playtester',
			'https://gamebanana.com/mods/381804',
			'00FF00'
		],
		[
			'Dinus Game',
			'Dinus Game',
			'freakyMenu Universe Engine music. Also made the design of the Fancy Main Menu',
			'https://gamebanana.com/members/2053946',
			'27FF27'
		],
		[
			'idiotxd',
			'idiotxd',
			'His own freakyMenu music and Universe Banner',
			'https://x.com/IdiottLool',
			'5656FF'
		],
		[
			'JordanSantiago',
			'jor',
			'Most of the code of UE comes from JS',
			'https://gamebanana.com/tools/13575',
			'32CD32'
		],
		["Slushi Engine", "invis", "The windows API is from there", "", "7a8584"],
		["< UE PR's >"],
		[
			'MoxieCoder',
			'moxie',
			"Lua Jit Fork superpowers04 PR",
			'https://x.com/moxie_specalist',
			'00FFFF'
		],
		[
			'soushimiya',
			'invis',
			"Crediting Rozebud",
			'https://github.com/soushimiya',
			'FFFFFF'
		]
	];

	public override function new()
	{
		super("Universe Engine", "All credits to the people who made this possible");
		creditList();
	}

	var grpCredits:FlxTypedGroup<PortraitOption> = new FlxTypedGroup<PortraitOption>();

	function creditList()
	{
		for (credit in credits)
		{
			var opt:PortraitOption = new PortraitOption(credit[0], credit[2], function() CoolUtil.browserLoad(credit[3]),
				FlxG.bitmap.add(Paths.image("credits/" + credit[1])), 1, true);
			@:privateAccess opt.__text.color = if (credit[4] == null) FlxColor.WHITE else FlxColor.fromString("0x" + credit[4]);
			add(opt);
			grpCredits.add(opt);
		}
	}

	/**
	 * Does a function then calls chamgeSelection().
	 * @param func 
	 */
	function creditFunc(func:Void->Void)
	{
		func();
		changeSelection(1);
		changeSelection(-1);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.J)
		{
			if (grpCredits.members[curSelected].text == 'CharGoldenYT')
			{
				creditFunc(function() grpCredits.members[curSelected].desc = "Joined the project because me, 'VideoBot', asked him\nHi it's me Char.\nI'M BEING HELD HOSTAGE UNTILL THE MOD FOLDER SUPPORT IS DONE /J");
			}
		}
	}
}
