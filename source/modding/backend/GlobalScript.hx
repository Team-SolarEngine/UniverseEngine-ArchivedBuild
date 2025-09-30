package modding.backend;

import polymod.hscript.HScriptedClass;

/*
* This is the global script
*/
class GlobalScript
{
    public var curBeat(get, null):Int;
    public var curStep(get, null):Int;
    public var curSection(get, null):Int;
    public var game(default, set):Dynamic;
    public var onPlayState:Bool = false;

    public function new()
    {
        if (game == null) game = FlxG.state;
    }

    // Basic script functions
    public function onCreate() {}
    public function onCreatePost() {}
    public function onUpdate(elapsed:Float) {}
    public function onUpdatePost(elapsed:Float) {}
    public function onStateSwitch(nextState:FlxState) {}
    public function postStateSwitch(nextState:FlxState) {}

    // PlayState specific functions
    public function onBeatHit() {}
    public function onSectionHit() {}
    public function onStepHit() {}

    // Other loader specific things
    public function addRedirect(b:Class<FlxState>, r:Class<FlxState>)
    {
        MusicBeatState.redirects.push(new RedirectHandler(b, r));
    }

    // Variable getters
    function get_curBeat():Int
    {
        return MusicBeatState.curBeat;
    }
    function get_curStep():Int
    {
        return MusicBeatState.curStep;
    }
    function get_curSection():Int
    {
        return MusicBeatState.curSection;
    }

    // Variable Setters
    function set_game(v:Dynamic):Dynamic
    {
        onPlayState = Std.isOfType(v, PlayState);
        game = v;
        return v;
    }
}

@:hscriptClass
class GScript extends GlobalScript implements HScriptedClass {}