package globalscripts.uescripts;

class Events extends BaseScript {
    public function new() super('Events Script', 'Events');
    public override function onEvent(name:String, value1:String, value2:String, strumTime:Float)
    {
        super.onEvent(name, value1, value2, strumTime);
        switch (name)
        {
            case 'fuckyou :3':
                trace('DIE');
        }
    }
}