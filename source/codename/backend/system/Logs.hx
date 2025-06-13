package codename.backend.system;

import haxe.Log;
import haxe.PosInfos;
import lime.app.Application;
using codename.backend.system.Logs.LogTools;

class AlertParams
{
    public var content:String = 'None';
    public var title:Null<String> = null;

    public function new(content:String = 'None', ?title:Null<String>)
    {
        this.content = content;
        this.title = title;
    }
}

class LogTools
{
    @:deprecated('The level.toLevel() function will soon be removed from backend.LogTools.') public static inline function toLevel(level:Level):String
    {
        return levelToString(level);
    }

    public static inline function levelToString(level:Level):String
    {
        switch (level)
        {
            case INFO | NONE:
                return '[  INFO    ]';
            case WARNING:
                return '[  WARNING ]';
            case ERROR:
                return '[  ERROR   ]';
            default:
                return '[  MISC    ]';
        }
    }

    public static inline function spawnAlertWindow(params:AlertParams, ?infos:haxe.PosInfos)
    {
        Logs.traceNew(params.content, ERROR, infos);
        Application.current.window.alert(params.content, params.title);
    }
}

class Logs
{
	public static var nativeTrace = Log.trace;

    public static function init()
    {
        Log.trace = traceOverride;
    }

    static function levelToInt(l:Level):Int
    {
        switch(l)
        {
            case INFO:
                return 0;
            case MISC:
                return 1;
            case NONE:
                return 2;
            case WARNING:
                return 3;
            case ERROR:
                return 4;
        }
    }

    static function traceOverride(v:Dynamic, ?infos:PosInfos):Void traceNew(v, NONE, infos);

    public static function traceNew(v:Dynamic, level:Level, ?infos:PosInfos):Void
    {
        var str = '${level.toLevel()} : ' + Log.formatOutput(v, infos).replace('\n\n', '\n').replace('\n', '\n${level.toLevel()} : ${infos.fileName}:${infos.lineNumber}: ');
        #if js
        if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null)
            (untyped console).log(str);
        #elseif lua
        untyped __define_feature__("use._hx_print", _hx_print(str));
        #elseif sys
        Sys.println(str);
        #else
        throw new haxe.exceptions.NotImplementedException()
        #end
    }
}

enum abstract TraceStyle(String) {
    var ALL = 'ALL';
    var WARNINGS_PLUS = 'WARNINGS+';
    var ERRORS_ONLY = 'ERRORS_ONLY';
    var NONE = 'NONE';
}

enum abstract Level(Int)
{
    var INFO = 0;
    var MISC = 1;
    var NONE = 2;
	var WARNING = 3;
	var ERROR = 4;
}