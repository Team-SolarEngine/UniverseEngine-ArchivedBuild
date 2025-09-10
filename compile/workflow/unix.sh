haxelib install lime 8.2.2 && haxelib set lime 8.2.2
haxelib install openfl 9.4.1 && haxelib set openfl 9.4.1
haxelib install flixel 5.5.0 && haxelib set flixel 5.5.0
haxelib install flixel-addons 3.2.0 && haxelib set flixel-addons 3.2.0
haxelib install flixel-ui 2.5.0 && haxelib set flixel-ui 2.5.0
haxelib install hxvlc 1.9.3 && haxelib set hxvlc 1.9.3

haxelib run lime setup flixel
haxelib run lime setup

haxelib install hscript
haxelib install hxcpp-debug-server
haxelib install hxdiscord_rpc

haxelib git hxcpp https://github.com/moxie-coder/hxcpp-compiled
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git hscript-improved https://github.com/CodenameCrew/hscript-improved 