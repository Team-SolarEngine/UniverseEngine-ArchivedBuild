package codename.backend.utils;

import flixel.system.frontEnds.LogFrontEnd;
import flixel.system.debug.log.LogStyle;

class LogUtils extends LogFrontEnd
{
    public static var onLogs:Dynamic->LogStyle->Bool->Void;

    override function advanced(Data:Dynamic, ?Style:LogStyle, FireOnce:Bool = false):Void
    {
        if (onLogs != null)
			onLogs(Data, Style, FireOnce);
    }
}