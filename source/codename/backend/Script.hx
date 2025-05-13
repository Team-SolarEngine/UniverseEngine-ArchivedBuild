package codename.backend;

/**
 * VideoBot, you can make this actually do shit yourself, this is just required to start loading mods.
 * 
 * Not referencing actual CNE code for this class.
 */
class Script {
    public function new(script:String) {}
    public static function create(script:String):Script return new Script(script);
    public function call(funcName:String, ?args:Array<Dynamic> = null):Dynamic return null;
    public function set(name:String, value:Dynamic)
    {
        // This would likely be the same thing as set in FunkinLua.
    }
    public function load() {
        // I have 0 clue what this does
    }
    public function setParent(value:Dynamic) {}
}