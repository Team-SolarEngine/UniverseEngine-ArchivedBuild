package charengine.sys.logger;

import charengine.sys.logger.AnsiColors;
import charengine.sys.logger.Level;

class LogTools
{
    public static inline function levelToString(level:Level):String
    {
        switch (level)
        {
            case INFO:
                return AnsiColors.LightPurple + '[  INFO    ]';
            case WARNING:
                return AnsiColors.LightYellow + '[  WARNING ]';
            case ERROR:
                return AnsiColors.Error + '[  ERROR   ]';
            default:
                return '[  MISC    ]';
        }
    }
}