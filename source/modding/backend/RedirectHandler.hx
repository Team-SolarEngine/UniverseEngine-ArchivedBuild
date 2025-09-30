package modding.backend;

class RedirectHandler
{
    public var baseState:Class<FlxState>;
    public var redirect:Class<FlxState>;
    
    public function new(b:Class<FlxState>, r:Class<FlxState>)
    {
        baseState = b;
        redirect = r;
    }
}