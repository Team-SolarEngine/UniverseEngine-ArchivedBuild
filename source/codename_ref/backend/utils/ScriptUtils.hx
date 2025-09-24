package codename.backend.utils;

class ScriptUtils
{
	@:noUsing public static inline function getMacroAbstractClass(className:String)
	{
		return Type.resolveClass('${className}_HSC');
	}
}
