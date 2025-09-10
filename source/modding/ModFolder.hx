package modding;

class ModFolder 
{
    public var id:String; // The assosciated mod id polymod uses for this mod folder
    public var name:String; // To make sure there are no folder conflicts.. somehow.
    public var enabled:Bool = true; // Whether this mod is enabled

    public function new(id:String, name:String, enabled:Bool)
    {
        this.id = id; this.name = name; this.enabled = enabled;
    }
}