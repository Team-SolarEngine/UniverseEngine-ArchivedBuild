package globalscripts;

import haxe.ds.StringMap;
import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
import haxe.ds.EnumValueMap;
import haxe.Constraints.IMap;

using StringTools;

@:transitive
@:multiType(@:followWithAbstracts K)
class ScriptLocator {
	public var name:String;
	public var array:String;

	public function new(Name:String, _Array:String)
	{
		name = Name.replace('|', '||');
		array = _Array.replace('|', '||');
	}

	public static function parseString(S:String):ScriptLocator
	{
		var splitString = S.split('| ');
		return new ScriptLocator(splitString[0], splitString[1]);
	}

	public inline function toString():String
	{
		return '${name}| ${array}';
	}
}

class ScriptMap<K:String, V:String> {
	var map:Map<K, V>;
	public var length(get, null):Int;
	private function get_length():Int
	{
		var l:Int = 0;
		for (key in map)
		{
			l++;
		}
		return l;
	}
	public function new() map = new Map<K, V>();
	public inline function get(key:K):String return map.get(key);
	public inline function set(key:K, value:V):V
	{
		map.set(key, value);
		return value;
	}
	public inline function copy():ScriptMap<K, V> return this;
	public inline function exists(key:K):Bool return map.exists(key);
	public inline function getLocator(key:K):ScriptLocator return ScriptLocator.parseString(map.get(key));
	public inline function setLocator(key:K, locator:ScriptLocator) set(key, cast locator.toString());
}