package globalscripts;

#if !macro
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxGroup;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.sound.FlxSound;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import scripting.FunkinLua.ModchartSprite;
import globalscripts.CustomIntIterator;
// Leave this in for people backporting anything to ue 0.5.5 :3c - Char
#if (UEVERSION <= "0.5.5")
import FancyMenuItem; // UE 0.5.5 and below
#end

using StringTools;
using globalscripts.ExtendedStringTools;
using globalscripts.ExtendedStringTools.MathTools;
#end