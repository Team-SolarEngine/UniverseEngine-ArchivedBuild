package modding;

class ScriptContext
{
    public var folder:String;
    public var script:String;

    /*
    * f - Folder
    * s - Script
    */
    public function new(f:String, s:String)
    {
        folder = f; script = s;
    }
}

class ModScriptContexts
{
    public var mod_id:String;
    public var contexts:Array<ScriptContext>;

    public function new(id:String, cs:Array<ScriptContext>)
    {
        mod_id = id; contexts = cs;
    }
}